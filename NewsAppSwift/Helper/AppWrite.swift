//
//  AppWrite.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import Appwrite
import Foundation
import JSONCodable

let serverURL = "https://cloud.appwrite.io/v1"

class Appwrite: ObservableObject {
    private var client: Client
    var account: Account
    var databases: Databases
    var storage: Storage

    public init() {
        client = Client()
            .setEndpoint(serverURL)
            .setProject(projectId)

        account = Account(client)
        databases = Databases(client)
        storage = Storage(client)
    }

    func getFileURL(fileId: String) -> String {
        "\(serverURL)/storage/buckets/\(storageId)/files/\(fileId)/preview?project=\(projectId)"
    }
}

enum CollectionName {
    static let users = "668bb81a00067041a376"
    static let otp = "668e327900341aaf16e8"
    static let bookmark = "668f883800365bb0f995"
}
