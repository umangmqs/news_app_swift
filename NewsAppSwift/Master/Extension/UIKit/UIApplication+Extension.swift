//
//  UIApplication+Extension.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import UIKit

extension UIApplication {
    func topMostVC(viewController: UIViewController? = (UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?.windows.first?.visibleViewController()) -> UIViewController?
    {
        if let navigationViewController = viewController as? UINavigationController {
            return UIApplication.shared.topMostVC(viewController: navigationViewController.visibleViewController)
        }
        if let tabBarViewController = viewController as? UITabBarController {
            if let selectedViewController = tabBarViewController.selectedViewController {
                return UIApplication.shared.topMostVC(viewController: selectedViewController)
            }
        }
        if let presentedViewController = viewController?.presentedViewController {
            return UIApplication.shared.topMostVC(viewController: presentedViewController)
        }
        return viewController
    }
}
