//
//  Validator.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import Foundation

struct Validator {
    static func validateFullname(_ fullname: String) -> String? {
        if fullname.isEmpty {
            return "Fullname cannot be empty"
        }
        return nil
    }
    
    static func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return "Email cannot be empty"
        } else if !email.isValidEmail {
            return "Email is not valid"
        }
        return nil
    }
    
    static func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return "Password cannot be empty"
        } else if password.count < 6 {
            return "Password must be at least 6 characters"
        }
        return nil
    }
    
    static func validateConfirmPassword(_ confirmPassword: String, password: String) -> String? {
        if confirmPassword.isEmpty {
            return "Confirm Password cannot be empty"
        } else if confirmPassword.count < 6 {
            return "Confirm Password must be at least 6 characters"
        } else if password != confirmPassword {
            return "Confirm password does not match with password"
        }
        return nil
    }
}
