//
//  BookmarkViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/10/24.
//

import Appwrite
import Combine
import Foundation

@MainActor
class BookmarkViewModel: ObservableObject {
    let appWrite: Appwrite

    @Published var isLoading: Bool = false
    @Published var toast: Toast?
    
    @Published var arrBookmark: [MDLBookmark] = []

    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

extension BookmarkViewModel {
    func getBookmarks() async {
        do {
            isLoading = true
            arrBookmark = []
            let data = try await appWrite.databases.listDocuments(
                databaseId: databaseId,
                collectionId: CollectionName.bookmark,
                queries: [Query.equal("userId", value: Constants.userInfo?.userId ?? "")]
//                nestedType: [MDLBookmark].self
            )
            data.documents.forEach { d in
                let userId = d.data["userId"]?.value as? String ?? ""
                do {
                    let article = (d.data["article"]?.value as? String ?? "").data(using: .utf8)
                    let decodedArticle = try JSONDecoder().decode(MDLArticle.self, from: article!)
                    let url = d.data["url"]?.value as? String ?? ""
                    arrBookmark.append(MDLBookmark(userId: userId, url: url, article: decodedArticle))
                } catch {
                    isLoading = false
                    toast = Toast(message: error.localizedDescription)
                }
            }
            isLoading = false
        } catch {
            isLoading = false
            toast = Toast(message: error.localizedDescription)
        }
    }
}
