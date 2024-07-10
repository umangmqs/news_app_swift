//
//  ProfileViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    let appWrite: Appwrite
    
    @Published var toast: Toast?
    @Published var isLoading = false
    
    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

extension ProfileViewModel {
    @MainActor
    func logoutAction() async -> Bool {
        isLoading = true
        guard let sessionId = UserDefaults.standard.value(forKey: StorageKey.sessionId) as? String else {
            return false
        }
        do {
            let res = try await appWrite.account.deleteSession(sessionId: sessionId) as? Bool ?? false
            if res {
                Constants.userInfo = nil
                try UserDefaults.standard.set(object: Constants.userInfo, forKey: StorageKey.userInfo)
            }
            isLoading = false
            return true
        } catch {
            isLoading = false
            toast = Toast(message: error.localizedDescription)
            return false
        }
    }
}
