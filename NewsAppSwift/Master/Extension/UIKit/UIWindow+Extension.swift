//
//  UIWindow+Extension.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import UIKit

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc: UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            if let navigationController = vc as? UINavigationController {
                return UIWindow.getVisibleViewControllerFrom(vc: navigationController.visibleViewController ?? UIViewController())
            }
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            if let tabBarController = vc as? UITabBarController {
                return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController ?? UIViewController())
            }
            
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
        return UIViewController()
    }
}
