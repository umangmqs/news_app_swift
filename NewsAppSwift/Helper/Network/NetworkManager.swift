//
//  NetworkManager.swift
//
//

import Foundation

enum BaseUrl: String {
    case production, stagging

    var url: String {
        switch self {
        case .production:
            "https://newsapi.org/v2/"
        case .stagging:
            "https://newsapi.org/v2/"
        }
    }
}

enum Endpoint: String {
    case headline = "top-headlines"
    case everything
}

struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")

    let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    let apiHandler: APIHandlerDelegate
    let responseHandler: ResponseHandlerDelegate

    var baseURL = BaseUrl.stagging.url

    init(
        apiHandler: APIHandlerDelegate = APIHandler(),
        responseHandler: ResponseHandlerDelegate = ResponseHandler()
    ) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }

    /// This method is used for calling API and getting the response model.
    ///
    /// - Parameters:
    ///   - method: HTTP request method.
    ///   - endpoint: API endpoint.
    ///   - params: Query parameters for the API.
    ///   - type: Generic type that represents the model object of the API response.
    /// - Returns: A generic model representing the response or throws an error.
    ///
    func fetchRequest<T: Codable>(
        method: HTTPMethod, endpoint: Endpoint, params: [String: Any],
        type: T.Type
    ) async throws -> T {
        guard let url = URL(string: baseURL.appending(endpoint.rawValue)) else {
            throw APIError.badURL
        }

        let data = try await apiHandler.requestData(
            method: method, url: url, params: params)
        let model = try await responseHandler.fetchModel(type: type, data: data)
        return model
    }
}

protocol APIHandlerDelegate: AnyObject {
    func requestData(method: HTTPMethod, url: URL, params: [String: Any])
        async throws -> Data
}

class APIHandler: APIHandlerDelegate {
    func requestData(method: HTTPMethod, url: URL, params: [String: Any])
        async throws -> Data {
        let finalUrl = try constructURL(
            method: method, url: url, params: params)

        AppPrint.debugPrint(
            "========================================= URL ========================================="
        )
        AppPrint.debugPrint("\(finalUrl)\n")
        AppPrint.debugPrint(
            "========================================= PARAMETERS ========================================="
        )
        AppPrint.debugPrint("\(params)\n")

        let request = createRequest(
            method: method, url: finalUrl, params: params)

        let (data, response) = try await URLSession.shared.data(for: request)
        try handleResponse(response)

        return data
    }

    private func constructURL(
        method: HTTPMethod, url: URL, params: [String: Any]
    ) throws -> URL {
        guard var components = URLComponents(string: url.absoluteString) else {
            throw APIError.badURL
        }

        if method == .get {
            components.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }

        guard let finalUrl = components.url else {
            throw APIError.badURL
        }

        return finalUrl
    }

    private func createRequest(
        method: HTTPMethod, url: URL, params: [String: Any]
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if method == .post {
            let bodyData = try? JSONSerialization.data(
                withJSONObject: params, options: [])
            request.httpBody = bodyData
        }

        return request
    }

    private func handleResponse(_ response: URLResponse) throws {
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 400: throw APIError.badRequest
            case 401: throw APIError.unauthorized
            case 403: throw APIError.forbidden
            case 404: throw APIError.notFound
            case 500: throw APIError.internalServerError
            default: break
            }
        }
    }
}

protocol ResponseHandlerDelegate: AnyObject {
    func fetchModel<T: Codable>(type: T.Type, data: Data) async throws -> T
}

class ResponseHandler: ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data) async throws -> T {
        do {
            let decodedModel = try JSONDecoder().decode(type.self, from: data)
            AppPrint.debugPrint(
                "========================================= RESPONSE ========================================="
            )
            AppPrint.debugPrint("\(decodedModel.prettyJSON)\n")
            return decodedModel
        } catch {
            throw APIError.decodingError
        }
    }
}

enum APIError: Error {
    case badURL
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case noData
    case decodingError
}
