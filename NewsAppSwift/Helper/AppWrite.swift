//
//  AppWrite.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import Foundation
import Appwrite
import JSONCodable

let serverURL = "https://cloud.appwrite.io/v1"

class Appwrite: ObservableObject {
    private var client: Client
    var account: Account
    var databases: Databases
    var storage: Storage

    
    public init() {
        self.client = Client()
            .setEndpoint(serverURL)
            .setProject(projectId)
        
        self.account = Account(client)
        self.databases = Databases(client);
        self.storage = Storage(client);
    }
    
    func getFileURL(fileId: String) -> String {
        return "\(serverURL)/storage/buckets/\(storageId)/files/\(fileId)/preview?project=\(projectId)"
//    https://cloud.appwrite.io/v1/storage/buckets/[BUCKET_ID]/files/[FILE_ID]/preview?project=[PROJECT_ID]
//    https://cloud.appwrite.io/v1/storage/buckets/668bc45f000e97dd51ad/files/668be0705e967c9ba686/preview?project=667e46960005d9cb1338
    }
}

struct CollectionName {
    static let users = "668bb81a00067041a376"
}
