//
//  MediaManager.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import Photos
import UIKit

private var topMostViewController: UIViewController? {
    UIApplication.shared.topMostVC()
}

final class MediaManager: NSObject, ObservableObject {
    private(set) lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        return imagePickerController
    }()

    private(set) var commpletion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey: Any]?) -> Void)?
}

extension MediaManager {
    var allowsEditing: Bool {
        get {
            imagePickerController.allowsEditing
        } set {
            imagePickerController.allowsEditing = newValue
        }
    }

    enum MediaSourceType: Equatable {
        case photoLibrary(String)
        case camera(String)
        case savedPhotosAlbum(String)

        fileprivate var strValue: String {
            switch self {
            case let .photoLibrary(strPhotoLibrary):
                strPhotoLibrary

            case let .camera(strCamera):
                strCamera

            case let .savedPhotosAlbum(strSavedPhotosAlbum):
                strSavedPhotosAlbum
            }
        }

        fileprivate func takeAppropriateAction(mediaManager: MediaManager) {
            switch self {
            case .camera:
                mediaManager.takeAPhoto()

            case .photoLibrary:
                mediaManager.chooseFromPhotoLibrary()

            case .savedPhotosAlbum:
                mediaManager.chooseFromSavedPhotosAlbum()
            }
        }
    }
}

extension MediaManager {
    func openCamera(commpletion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey: Any]?) -> Void)?) {
        takeAPhoto()
        self.commpletion = commpletion
    }

    func openGallery(commpletion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey: Any]?) -> Void)?) {
        takeAPhotoGallery()
        self.commpletion = commpletion
    }

    /// A private method used to select an image from camera.
    private func takeAPhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let msg = "Your device doesn't support camera."
            topMostViewController?.alertView(message: msg, actions: [.Ok])
            return
        }

        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                CGCDMainThread.async {
                    self.imagePickerController.sourceType = .camera
                    self.imagePickerController.allowsEditing = self.allowsEditing
                    topMostViewController?.present(self.imagePickerController, animated: true, completion: nil)
                    topMostViewController?.present(self.imagePickerController, animated: true, completion: nil)
                }
            } else {
                CGCDMainThread.async {
                    topMostViewController?.alertView(title: "", message: "Camera permission is denied. Please allow permission to camera for capturing photos using camera.", style: .alert, actions: [.Cancel, .Setting], handler: { [weak self] sender in

                        guard let `_` = self else {
                            return
                        }

                        if sender == .Setting {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    })
                }
            }
        }
    }

    /// A private method used to select an image from camera.
    private func takeAPhotoGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let msg = "Your device doesn't support camera."
            topMostViewController?.alertView(message: msg, actions: [.Ok])
            return
        }

        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = allowsEditing
        topMostViewController?.present(imagePickerController, animated: true, completion: nil)
    }

    /// A private method used to select an image from photoLibrary.
    private func chooseFromPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let msg = "Your device doesn't support photo library."
            topMostViewController?.alertView(message: msg, actions: [.Ok])
            return
        }

        // Request permission to access photo library
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] status in

                CGCDMainThread.async { [unowned self] in
                    showUI(for: status)
                }
            }
        } else {
            // Fallback on earlier versions
            PHPhotoLibrary.requestAuthorization { status in

                switch status {
                case .restricted, .denied:
                    self.showRestrictedAccessUI()

                case .authorized:
                    CGCDMainThread.async {
                        self.imagePickerController.sourceType = .photoLibrary
                        self.imagePickerController.allowsEditing = self.allowsEditing
                        topMostViewController?.present(self.imagePickerController, animated: true, completion: nil)
                    }

                default:
                    break
                }
            }
        }
    }

    /// A private method used to select an image from savedPhotosAlbum.
    private func chooseFromSavedPhotosAlbum() {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            let msg = "Your device doesn't support photo library."
            topMostViewController?.alertView(message: msg, actions: [.Ok])
            return
        }

        // Request permission to access photo library
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] status in

                CGCDMainThread.async { [unowned self] in
                    showUI(for: status)
                }
            }
        } else {
            // Fallback on earlier versions
            PHPhotoLibrary.requestAuthorization { status in

                switch status {
                case .restricted, .denied:
                    self.showRestrictedAccessUI()

                case .authorized:
                    CGCDMainThread.async {
                        self.imagePickerController.sourceType = .savedPhotosAlbum
                        self.imagePickerController.allowsEditing = self.allowsEditing
                        topMostViewController?.present(self.imagePickerController, animated: true, completion: nil)
                    }

                default:
                    break
                }
            }
        }
    }

    func showUI(for status: PHAuthorizationStatus) {
        switch status {
        case .authorized:
            showFullAccessUI()

        case .limited:
            // showLimittedAccessUI()
            showFullAccessUI()

        case .restricted:
            showRestrictedAccessUI()

        case .denied:
            showAccessDeniedUI()

        case .notDetermined:
            break

        @unknown default:
            break
        }
    }

    func showFullAccessUI() {
        CGCDMainThread.async {
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.allowsEditing = self.allowsEditing
            topMostViewController?.present(self.imagePickerController, animated: true, completion: nil)
        }
    }

    func showRestrictedAccessUI() {
        CGCDMainThread.async {
            topMostViewController?.alertView(title: "", message: "Photos permission is denied. Please allow permission to gallery photos for selecting photos from gallery.", style: .alert, actions: [.Cancel, .Setting], handler: { sender in

                if sender == .Setting {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })
        }
    }

    func showAccessDeniedUI() {
        CGCDMainThread.async {
            topMostViewController?.alertView(title: "", message: "Photos permission is denied. Please allow permission to gallery photos for selecting photos from gallery.", style: .alert, actions: [.Cancel, .Setting], handler: { sender in

                if sender == .Setting {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })
        }
    }
}

extension MediaManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) { [weak self] in

            guard let self, let commpletion else {
                return
            }

            var image: UIImage? = if allowsEditing {
                info[.editedImage] as? UIImage
            } else {
                info[.originalImage] as? UIImage
            }

            commpletion(image, info)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in

            guard let self, let commpletion else {
                return
            }
            commpletion(nil, nil)
        }
    }
}
