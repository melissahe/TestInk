//
//  FlagServiceDelegate.swift
//  TestInk
//
//  Created by C4Q on 3/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

protocol FlagDelegate: class {
    
    //Methods to handle adding flags to Firebase
    func didAddFlagToFirebase(_ service: FirebaseFlaggingService)
    func failedToAddFlagToFirebase(_ service: FirebaseFlaggingService, error: String)
    
    
    //Methods to handle post flagging functionality
    func didFlagPostAlready(_ service: FirebaseFlaggingService, error: String)
    func didFlagPost(_ service: FirebaseFlaggingService)
    func didFailToFlagPost(_ service: FirebaseFlaggingService, error: String)
    
}
