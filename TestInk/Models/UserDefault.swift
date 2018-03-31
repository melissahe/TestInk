//
//  UserDefault.swift
//  TestInk
//
//  Created by C4Q on 3/30/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
class UserDefaultsHelper {
    private init() {}
    static let manager = UserDefaultsHelper()
    let emailKey = "Email"
    
    func saveEmail(email: String) {
        UserDefaults.standard.set(email, forKey: emailKey)
    }
    
    func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: emailKey)
    }
}
