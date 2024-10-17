//
//  LoginViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 08/07/24.
//

import Appwrite
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    let appWrite: Appwrite

    @Published var isLoading = false
    @Published var toast: Toast?

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var loginVM: Bool = false
    @Published var remember: Bool = false
    @Published var secured: Bool = true

    @AppStorage(StorageKey.remembarEmail) var remembserEmail = ""
    @AppStorage(StorageKey.remembarPass) var remembserPass = ""

    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

extension LoginViewModel {
    @MainActor
    func validate() -> Bool {
        if let msg = Validator.validateEmail(email) {
            toast = Toast(message: msg)
            return false
        } else if let msg = Validator.validatePassword(password) {
            toast = Toast(message: msg)
            return false
        }
        return true
    }

    @MainActor
    func login() async -> Bool {
        do {
            isLoading = true
//            let sessionId = UserDefaults.standard.value(forKey: StorageKey.sessionId) as? String
//            if sessionId != nil {
//                let _ = try await appWrite.account.deleteSession(sessionId: sessionId!)
//            }
            let session = try await appWrite.account.createEmailPasswordSession(email: email, password: password)
            UserDefaults.standard.set(session.id, forKey: StorageKey.sessionId)
            return await getUserInfo(userId: session.userId)
        } catch {
            AppPrint.debugPrint(error.localizedDescription)
            toast = Toast(message: error.localizedDescription)
            isLoading = false
            return false
        }
    }

    @MainActor
    private func getUserInfo(userId: String) async -> Bool {
        do {
            let result = try await appWrite.databases.listDocuments(
                databaseId: databaseId,
                collectionId: CollectionName.users,
                queries: [Query.equal("userId", value: userId)]
            )

            let data = result.documents.first?.toMap()["data"] as! Data
            let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]

            let userModal: MDLUser? = obj.castToObject()
            try UserDefaults.standard.set<MDLUser>(object: userModal.self, forKey: StorageKey.userInfo)
            Constants.userInfo = userModal

            if remember {
                remembserEmail = email
                remembserPass = password
            } else {
                remembserEmail = ""
                remembserPass = ""
            }

            isLoading = false

            return !(result.documents.isEmpty)
        } catch {
            AppPrint.debugPrint(error.localizedDescription)
            toast = Toast(message: error.localizedDescription)
            isLoading = false
            return false
        }
    }
}
