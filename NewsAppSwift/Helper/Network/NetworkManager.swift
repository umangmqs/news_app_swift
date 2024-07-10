//
//  NetworkManager.swift
//
//

import Foundation

enum APIError: Error {
    case BadURL
    case NoData
    case DecodingError
    case FetchError
    
    case BadRequest
    case Unauthorized
    case Forbidden
    case NotFound
    case InternalServerError
}

enum BaseUrl: String {
    case production, stagging
    
    var url: String {
        switch self {
        case .production:
            return "https://newsapi.org/v2/"
        case .stagging:
            return "https://newsapi.org/v2/"
        }
    }
}

enum Endpoint: String {
    case headline = "top-headlines"
    case everything = "everything"
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
    
    
    init(apiHandler: APIHandlerDelegate = APIHandler(),
         responseHandler: ResponseHandlerDelegate = ResponseHandler()) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    /// This method is used for calling api and getting response model.
    ///
    /// - Parameters:
    ///   - method: This could be any HTTP request method.
    ///   - endpoint: This is ecompletionndpoint of api.
    ///   - params: This are the query perameters of an api.
    ///   - type: This is generic type which can be model object of api response.
    ///   - completion: Here we get result type. If it is success then we will get response model otherwise will ger error.
    ///
    func fetchRequest<T: Codable>(method: HTTPMethod, endpoint: Endpoint, params: [String: Any], type: T.Type, completion: @escaping(Result<T, APIError>) -> Void) {
        guard let url = URL(string: self.baseURL.appending(endpoint.rawValue)) else {
            completion(.failure(.BadURL))
            return
        }
        
        apiHandler.requestData(method: method, url: url, params: params) { result in
            switch result {
            case .success(let data):
                self.responseHandler.fetchModel(type: type, data: data) { decodedResult in
                    switch decodedResult {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
 
protocol APIHandlerDelegate {
    func requestData(method: HTTPMethod, url: URL, params: [String: Any], completion: @escaping(Result<Data, APIError>) -> Void)
}

class APIHandler: APIHandlerDelegate {
    
    func requestData(method: HTTPMethod, url: URL, params: [String : Any], completion: @escaping (Result<Data, APIError>) -> Void) {
        guard var components = URLComponents(string: url.absoluteString) else {
            completion(.failure(.BadURL))
            return
        }
        
        guard let url = components.url else {
            completion(.failure(.BadURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        AppPrint.debugPrint("========================================= URL =========================================")
        AppPrint.debugPrint(url)
        AppPrint.debugPrint("========================================= PARAMETERS =========================================")
        AppPrint.debugPrint(params)
        
        if method == .get {
            components.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            }
            
            guard let url = components.url else { return }
            
            let tmpReq = URLRequest(url: url)
            request = tmpReq
            
        } else if method == .post {
            let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = bodyData
        }
        
        request.httpMethod = method.rawValue

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if let res = response as? HTTPURLResponse {
                    switch res.statusCode {
                    case 400:
                        completion(.failure(.BadRequest))
                        AppPrint.debugPrint("Bad Request")
                    case 401:
                        completion(.failure(.Unauthorized))
                        AppPrint.debugPrint("Unauthorized")
                    case 403:
                        completion(.failure(.Forbidden))
                        AppPrint.debugPrint("Forbidden")
                    case 404:
                        completion(.failure(.NotFound))
                        AppPrint.debugPrint("Not Found")
                    case 500:
                        completion(.failure(.BadRequest))
                        AppPrint.debugPrint("Internal Server Error")
                    default:
                        AppPrint.debugPrint("statusCode")
                    }
                }
                return completion(.failure(.NoData))
            }
            completion(.success(data))
            
        }.resume()
    }
    
}
 
protocol ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, APIError>) -> Void)
}
 
class ResponseHandler: ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, APIError>) -> Void) {
        let aResponse = try? JSONDecoder().decode(type.self, from: data)
        AppPrint.debugPrint("========================================= RESPONSE =========================================")
        let json = try? JSONSerialization.jsonObject(with: data)
        AppPrint.debugPrint(json!)
        if let myResponse = aResponse {
            return completion(.success(myResponse))
        } else {
            completion(.failure(.DecodingError))
        }
    }
}

