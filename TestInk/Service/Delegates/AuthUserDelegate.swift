//
//  AuthUserDelegate.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthUserDelegate: class {
    //create user delegate protocols
    func didFailCreatingUser(_ userService: AuthUserManager, error: Error)
    func didCreateUser(_ userService: AuthUserManager, user: UserProfile)
    
    //sign out delegate protocols
    func didFailSigningOut(_ userService: AuthUserManager, error: Error)
    func didSignOut(_ userService: AuthUserManager)
    
    //sign in delegate protocols
    func didFailToSignIn(_ userService: AuthUserManager, error: Error)
    func didSignIn(_ userService: AuthUserManager, user: String)
    
    //verifying email protocols
    func didFailToVerifyEmail(_ userService: AuthUserManager, error: Error)
    func didSendEmailVerification(user: String, message: String)
    
    //password reset protocols
    func didFailToSendPasswordReset(_ userService: AuthUserManager, error: Error)
    func didSendPasswordReset(_userService: AuthUserManager)
}
