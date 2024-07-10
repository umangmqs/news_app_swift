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
    
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var secured = true
    @Published var confirmSecured = true
    
    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

extension ChangePasswordViewModel {
    
    @MainActor
    func validate() -> Bool {
        if let msg = Validator.validatePassword(password) {
            toast = Toast(message: msg)
            return false
        } else if let msg = Validator.validateConfirmPassword(confirmPassword, password: password) {
            toast = Toast(message: msg)
            return false
        }
        return true
    }
    
    @MainActor
    func changePassword() async {
        if !validate() {
            return
        }
        
        do {
            let result = try await appWrite.account.createRecovery(email: "umang@yopmail.com", url: "https://cloud.appwrite.io")
            AppPrint.debugPrint("res: \(result.toMap())")
            
//            let recoveryResult = try await appWrite.account.updateRecovery(userId: result.userId, secret: result.secret, password: password)
//            AppPrint.debugPrint("recoveryResult: \(recoveryResult.toMap())")
            
        } catch {
            toast = Toast(message: error.localizedDescription)
        }
    }
}
