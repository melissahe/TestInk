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
    func didFailCreatingUser(_ userService: AuthUserService, error: Error)
    func didCreateUser(_ userService: AuthUserService, user: User)
    
    //sign out delegate protocols
    func didFailSigningOut(_ userService: AuthUserService, error: Error)
    func didSignOut(_ userService: AuthUserService)
    
    //sign in delegate protocols
    func didFailToSignIn(_ userService: AuthUserService, error: Error)
    func didSignIn(_ userService: AuthUserService, user: User)

    //password reset protocols
    func didFailToSendPasswordReset(_ userService: AuthUserService, error: Error)
    func didSendPasswordReset(_userService: AuthUserService)
}
