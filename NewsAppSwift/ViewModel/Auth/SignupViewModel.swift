//
//  SignupViewModel.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import Appwrite
import Combine
import SwiftUI

class SignupViewModel: ObservableObject {
    let appWrite: Appwrite

    @Published var toast: Toast?

    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var fullname: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var secured: Bool = true
    @Published var confirmSecured: Bool = true

    @Published var isLoading: Bool = false

    @Published var profileImage = Image(.icUser)

    var mediaPicker: MediaManager = .init()

    init(appWrite: Appwrite) {
        self.appWrite = appWrite
    }
}

// MARK: - Action

extension SignupViewModel {
    func btnCameraAction() {
        mediaPicker.allowsEditing = true
        mediaPicker.openCamera { [weak self] image, _ in
            guard let self else {
                return
            }
            guard let image else { return }
            profileImage = Image(uiImage: image)
        }
    }

    func btnGalleryAction() {
        mediaPicker.allowsEditing = true
        mediaPicker.openGallery { [weak self] image, _ in
            guard let self else {
                return
            }
            guard let image else { return }
            profileImage = Image(uiImage: image)
        }
    }
}

// MARK: - API

extension SignupViewModel {
    @MainActor
    func validate() -> Bool {
        if let msg = Validator.validateFullname(fullname) {
            toast = Toast(message: msg)
            return false
        } else if let msg = Validator.validateEmail(email) {
            toast = Toast(message: msg)
            return false
        } else if let msg = Validator.validatePassword(password) {
            toast = Toast(message: msg)
            return false
        } else if let msg = Validator.validateConfirmPassword(
            confirmPassword, password: password) {
            toast = Toast(message: msg)
            return false
        }

        return true
    }

    @MainActor
    func signup() async -> Bool {
        do {
            isLoading = true
            let user = try await appWrite.account.create(
                userId: ID.unique(), email: email, password: password)
            var model = MDLUser(
                userId: user.id,
                fullname: fullname,
                phone: phone,
                email: user.email,
                createdAt: user.createdAt,
                updatedAt: user.updatedAt
            )

            if profileImage != Image(.icUser) {
                let uploadStatus = await uploadProfile()
                if uploadStatus.0 {
                    model.profileImage = uploadStatus.1
                    guard let dict = model.dictionary else {
                        return false
                    }
                    return await createUserInDB(data: dict)
                } else {
                    return false
                }

            } else {
                guard let dict = model.dictionary else {
                    return false
                }
                return await createUserInDB(data: dict)
            }

        } catch {
            isLoading = false
            toast = Toast(message: error.localizedDescription)
            return false
        }
    }

    @MainActor
    private func uploadProfile() async -> (Bool, String?) {
        guard let data = ImageRenderer(content: profileImage).uiImage?.pngData()
        else {
            return (false, nil)
        }

        do {
            let file = try await appWrite.storage.createFile(
                bucketId: storageId,
                fileId: ID.unique(),
                file: InputFile.fromData(
                    data, filename: "profile_\(Date().millisecondsSince1970)",
                    mimeType: MimeType.png.type
                )
            ) { progress in
                AppPrint.debugPrint("progress: \(progress.progress)")
            }
            let url = appWrite.getFileURL(fileId: file.id)

            return (true, url)
        } catch {
            isLoading = false
            toast = Toast(message: error.localizedDescription)
            return (false, nil)
        }
    }

    @MainActor
    private func createUserInDB(data: [String: Any]) async -> Bool {
        do {
            _ = try await appWrite.databases.createDocument(
                databaseId: databaseId,
                collectionId: CollectionName.users,
                documentId: ID.unique(), data: data
            )
            isLoading = false
            let mdl: MDLUser? = data.castToObject()
            try UserDefaults.standard.set<MDLUser>(
                object: mdl, forKey: StorageKey.userInfo)
            return true
        } catch {
            isLoading = false
            toast = Toast(message: error.localizedDescription)
            return false
        }
    }
}
