//
//  ForgotPasswordViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import UIKit
import Appwrite

class ForgotPasswordViewModel: ObservableObject {
    let appWrite: Appwrite
    
    @Published var toast: Toast?
    @Published var isLoading = false
    
    @Published var email = ""
    
    var otp: String = ""
    
    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

extension ForgotPasswordViewModel {
    
    func validate() -> Bool {
        if let msg = Validator.validateEmail(email) {
            toast = Toast(message: msg)
            return false
        }
        return true
    }
 
    @MainActor
    func checkEmailExist() async -> Bool {
        if !validate() {
            return false
        }
        isLoading = true
        do {
            let res = try await appWrite.databases.listDocuments(
                databaseId: databaseId,
                collectionId: CollectionName.users,
                queries: [
                    Query.equal("email", value: email)
                ]
            )
            isLoading = false
            
            if res.total == 0 {
                toast = Toast(message: "User not found, enter valid email address.")
                return false
            }
            
            return true
            
        } catch {
            toast = Toast(message: error.localizedDescription)
            isLoading = false
            return false
        }
    }
    
    func storeOTP() async -> Bool {
        otp = generateOTP()
        let deviceUniqueId = Constants.getDeviceUUID()
        let expiry = Date().dateByAdd(minutes: 2).ISO8601Format()
        
        do {
            let result = try await appWrite.databases.listDocuments(databaseId: databaseId, collectionId: CollectionName.otp, queries: [Query.equal("deviceId", value: deviceUniqueId)])
            
            result.documents.forEach { d in
                Task {
                    try await appWrite.databases.deleteDocument(databaseId: databaseId, collectionId: CollectionName.otp, documentId: d.id)
                }
            }
            
            let data: JSON = [
                "otp": otp,
                "deviceId": deviceUniqueId,
                "expiry": expiry
            ]
            
            let _ = try await appWrite.databases.createDocument(
                databaseId: databaseId,
                collectionId: CollectionName.otp,
                documentId: ID.unique(),
                data: data
            )
            return true
        } catch {
            toast = Toast(message: error.localizedDescription)
            return false
        }
        
    }
    
    private func generateOTP() -> String {
        let digits = "0123456789"
        var otp = ""
        for _ in 1...6 {
            if let randomDigit = digits.randomElement() {
                otp.append(randomDigit)
            }
        }
        return otp
    }
    
    
}
