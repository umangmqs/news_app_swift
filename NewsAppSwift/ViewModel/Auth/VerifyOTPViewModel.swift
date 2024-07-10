//
//  VerifyOTPViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import Foundation
import Appwrite

class VerifyOTPViewModel: ObservableObject {
    let appWrite: Appwrite
    
    @Published var toast: Toast?
    @Published var isLoading: Bool = false
    
    @Published var first: String = ""
    @Published var second: String = ""
    @Published var third: String = ""
    @Published var fourth: String = ""
    @Published var fifth: String = ""
    @Published var sixth: String = ""
    @Published var email: String = ""

    
    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}


extension VerifyOTPViewModel {
    
    @MainActor
    func verifyOTP() async -> Bool {
        let enteredOTP = first + second + third + fourth + fifth + sixth
        
        if enteredOTP == "" {
            toast = Toast(message: "Please enter OTP.")
            return false
        } else if enteredOTP.count < 6 {
            toast = Toast(message: "Please enter valid OTP.")
            return false
        }
        
        do {
            let result = try await appWrite.databases.listDocuments(
                databaseId: databaseId,
                collectionId: CollectionName.otp,
                queries: [Query.equal("deviceId", value: Constants.getDeviceUUID())]
            )
            
            if result.total > 0 {
                let data = result.documents[0].data
                let expiry = (data["expiry"])?.value as? String ?? ""
                let otp = (data["otp"])?.value as? String ?? ""
                
                guard let date = Date(iso8601String: expiry) else {
                    AppPrint.debugPrint("date not found")
                    return false
                }
                let currentDate = Date()
                
                if currentDate > date {
                    toast = Toast(message: "OTP is expired")
                    return false
                } else {
                    if enteredOTP == otp {
                        let _ = try await appWrite.databases.deleteDocument(
                            databaseId: databaseId,
                            collectionId: CollectionName.otp,
                            documentId: result.documents[0].id
                        )
                        return true
                    } else {
                        toast = Toast(message: "Entered OTP is not valid.")
                        return false
                    }
                }
            }
            return false
        } catch {
            toast = Toast(message: error.localizedDescription)
            return false
        }
    }
}
