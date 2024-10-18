//
//  NewsDetailViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 11/07/24.
//

import Appwrite
import SwiftUI

class NewsDetailViewModel: ObservableObject {
    let appWrite: Appwrite
    @Published var toast: Toast?
    @Published var isLoading: Bool = false
    @Published var isBookmarked = false

    var article: MDLArticle?

    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

extension NewsDetailViewModel {
    @MainActor
    func addRemoveBookmark() async {
        do {
            guard let data = article.dictionary else {
                AppPrint.debugPrint("Article is not in valid format")
                return
            }

            isLoading = true
            if !isBookmarked {
                //                try await appWrite.databases.listDocuments(
                //                    databaseId: databaseId,
                //                    collectionId: CollectionName.users,
                //                    queries: [
                //                        Query.equal("userId", value: Constants.userInfo?.userId ?? ""),
                //                    ]
                //                ).documents[0].id

                let params: JSON = [
                    "url": article?.url ?? "",
                    "article": data.toJson(),
                    "userId": Constants.userInfo?.userId ?? ""
                ]

                _ = try await appWrite.databases.createDocument(
                    databaseId: databaseId,
                    collectionId: CollectionName.bookmark,
                    documentId: ID.unique(),
                    data: params.toJson()
                )

                isLoading = false

            } else {
                let doc = try await appWrite.databases.listDocuments(
                    databaseId: databaseId,
                    collectionId: CollectionName.bookmark,
                    queries: [
                        Query.equal("articleId", value: article!.id.uuidString)
                    ]
                )

                AppPrint.debugPrint("Document: \(doc.total)")
                isLoading = false
            }

            isBookmarked.toggle()
        } catch {
            isLoading = false
            toast = Toast(message: error.localizedDescription)
        }
    }

    @MainActor
    func getIsBookmarked() async {
        do {
            isLoading = true
            let res = try await appWrite.databases.listDocuments(
                databaseId: databaseId,
                collectionId: CollectionName.bookmark,
                queries: [Query.equal("url", value: article!.url!)]
            )

            withAnimation {
                if res.total == 1 {
                    isBookmarked = true
                } else {
                    isBookmarked = false
                }
            }
            isLoading = false
        } catch {
            toast = Toast(message: error.localizedDescription)
            isLoading = false
        }
    }
}
