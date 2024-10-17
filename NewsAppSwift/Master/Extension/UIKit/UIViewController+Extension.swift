//
//  UIViewController+Extension.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import UIKit

enum AAction: Equatable {
    case Okay
    case Ok
    case Yes
    case No
    case Cancel
    case Edit
    case Delete
    case Setting
    case Remove
    case Logout
    case Custom(title: String)

    var title: String {
        switch self {
        case .Okay:
            "Okay"
        case .Ok:
            "Ok"
        case .Yes:
            "Yes"
        case .No:
            "No"
        case .Cancel:
            "Cancel"
        case .Edit:
            "Edit"
        case .Delete:
            "Delete"
        case .Remove:
            "Remove"
        case .Logout:
            "Logout"
        case .Setting:
            "Settings"
        case let .Custom(title):
            title
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .Cancel:
            .cancel
        case .Delete, .Remove, .Logout, .No:
            .destructive
        default:
            .default
        }
    }
}

// MARK: - Extension of UIViewController For AlertView with Different Numbers of Buttons -

extension UIViewController {
    func alertView(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actions: [AAction] = [], handler: ((AAction) -> Void)? = nil) {
        var _actions = actions
        if actions.isEmpty {
            _actions.append(AAction.Okay)
        }
        var arrAction: [UIAlertAction] = []
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let onSelect: ((UIAlertAction) -> Void)? = { alert in
            guard let index = arrAction.firstIndex(of: alert) else {
                return
            }
            handler?(_actions[index])
        }
        for action in _actions {
            arrAction.append(UIAlertAction(title: action.title, style: action.style, handler: onSelect))
        }
        _ = arrAction.map { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }
}
