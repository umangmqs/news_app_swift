//
//  Device+Extension.swift
//  swiftui_master
//
//  Created by MultiQoS on 05/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import UIKit

// Device size

// MARK: - Device Dimensions -

extension UIDevice {
    // This can be change according to design (Here we are considering design in Iphone-6)

    static var width: CGFloat {
        390
    }

    static var tabbarHeight: CGFloat {
        80
    }

    static var mainScreen: UIScreen {
        UIScreen.main
    }

    static var screenSize: CGSize {
        UIDevice.mainScreen.bounds.size
    }

    static var screenOrigin: CGPoint {
        UIDevice.mainScreen.bounds.origin
    }

    static var screenX: CGFloat {
        UIDevice.screenOrigin.x
    }

    static var screenY: CGFloat {
        UIDevice.screenOrigin.y
    }

    static var screenCenter: CGPoint {
        CGPoint(
            x: UIDevice.screenWidth / 2.0,
            y: UIDevice.screenHeight / 2.0
        )
    }

    static var screenCenterX: CGFloat {
        UIDevice.screenCenter.x
    }

    static var screenCenterY: CGFloat {
        UIDevice.screenCenter.y
    }

    static var screenWidth: CGFloat {
        UIDevice.screenSize.width
    }

    static var screenHeight: CGFloat {
        UIDevice.screenSize.height
    }

    static var safeAreaHeight: CGFloat {
        guard let window: UIWindow = (UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.first
        else {
            return 0
        }

        if #available(iOS 11.0, *),
           UIWindow.instancesRespond(to: #selector(getter: window.safeAreaInsets))
        {
            return UIDevice.screenHeight - window.safeAreaInsets.bottom - window.safeAreaInsets.top
        } else {
            return UIDevice.screenHeight - ((UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.statusBarManager?.statusBarFrame.height ?? 0)
        }
    }

    static var safeAreaWidth: CGFloat {
        guard let window: UIWindow = (UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.first
        else {
            return 0
        }

        if #available(iOS 11.0, *),
           UIWindow.instancesRespond(to: #selector(getter: window.safeAreaInsets))
        {
            return UIDevice.screenWidth - window.safeAreaInsets.left - window.safeAreaInsets.right
        } else {
            return UIDevice.screenWidth
        }
    }

    static var safeAreaBottom: CGFloat {
        guard let window: UIWindow = (UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.first
        else {
            return 0
        }

        if #available(iOS 11.0, *),
           UIWindow.instancesRespond(to: #selector(getter: window.safeAreaInsets))
        {
            return UIDevice.safeAreaInsets.bottom
        } else {
            return 0
        }
    }

    static var safeAreaInsets: UIEdgeInsets {
        guard let window: UIWindow = (UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.first
        else {
            return .zero
        }

        if #available(iOS 11.0, *),
           UIWindow.instancesRespond(to: #selector(getter: window.safeAreaInsets))
        {
            return window.safeAreaInsets
        }

        return .zero
    }

    static var safeAreaLayoutGuide: UILayoutGuide {
        guard let window: UIWindow = (UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.first
        else {
            return UILayoutGuide()
        }

        if #available(iOS 11.0, *) {
            return window.safeAreaLayoutGuide
        }

        return UILayoutGuide()
    }

    static var navigationBarHeight: CGFloat {
        if #available(iOS 11.0, *) {
            44 + UIWindow().safeAreaInsets.top
        } else {
            44 + UIApplication.shared.statusBarFrame.height
        }
    }
}

// MARK: - Device Details -

extension UIDevice {
    static var CUUId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    static var deviceName: String {
        UIDevice.current.name
    }

    static var version: String {
        UIDevice.current.systemVersion
    }
}

// MARK: - Device Placement -

extension UIDevice {
    static var deviceOrientation: UIDeviceOrientation {
        UIDevice.current.orientation
    }

    static var isPortrait: Bool {
        UIDevice.deviceOrientation.isPortrait
    }

    static var isLandscape: Bool {
        UIDevice.deviceOrientation.isLandscape
    }
}

// MARK: - Device type -

extension UIDevice {
    static var isSimulator: Bool {
        TARGET_OS_SIMULATOR != 0
    }

    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isTV: Bool {
        UIDevice.current.userInterfaceIdiom == .tv
    }

    static var isIOS9: Bool {
        ((UIDevice.version.convert() as Double).convert() as Int) == 9
    }

    static var isIOS10: Bool {
        ((UIDevice.version.convert() as Double).convert() as Int) == 10
    }

    static var isIOS11: Bool {
        ((UIDevice.version.convert() as Double).convert() as Int) == 11
    }

    static var isIPhone5: Bool {
        UIDevice.screenHeight == 568
    }

    static var isIPhone6: Bool {
        UIDevice.screenHeight == 667
    }

    static var isIPhone6Plus: Bool {
        UIDevice.screenHeight == 736
    }

    static var isIPhoneX: Bool {
        UIDevice.screenHeight == 812
    }

    static var isIPhoneXR: Bool {
        UIDevice.screenHeight == 896
    }

    static var isIPhoneXSeries: Bool {
        UIDevice.screenHeight >= 812 && UIDevice.isIPhone
    }

    static var hasNotch: Bool {
        var bottom: CGFloat = 0
        if #available(iOS 13.0, *) {
            let keyWindow = (UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow })
            bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return bottom > 0
    }
}
