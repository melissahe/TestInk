//
//  UserServiceDelegate.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

protocol UserProfileDelegate: class {

    //adding user
    func didAddUserToFirebase(_ userService: UserProfileService, user: UserProfile)
    func failedToAddUserToFirebase(_ userService: UserProfileService, error: Error)
    
    //loading user for injection
    func didLoadUser(_ userService: AuthUserService, user: UserProfile)
    func failedToLoadUser(_ userService: AuthUserService, error: Error)
}
