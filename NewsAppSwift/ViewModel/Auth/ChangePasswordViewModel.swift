//
//  ChangePasswordViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {
    let appWrite: Appwrite

    @Published var toast: Toast?
    @Published var isLoading = false

    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""

    @Published var oldSecured = true
    @Published var newSecured = true
    @Published var confirmSecured = true

    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

extension ChangePasswordViewModel {
    @MainActor
    func validate() -> Bool {
        if let msg = Validator.validatePassword(oldPassword) {
            toast = Toast(message: msg)
            return false
        } else if let msg = Validator.validateNewPassword(newPassword) {
            toast = Toast(message: msg)
            return false
        } else if let msg = Validator.validateConfirmPassword(confirmPassword, password: newPassword) {
            toast = Toast(message: msg)
            return false
        }
        return true
    }

    @MainActor
    func changePassword() async -> Bool {
        if !validate() {
            return false
        }

        do {
            isLoading = true
            let result = try await appWrite.account.updatePassword(password: newPassword, oldPassword: oldPassword)
            isLoading = false
            return true
        } catch {
            isLoading = false
            toast = Toast(message: error.localizedDescription)
            return false
        }
    }
}
