//
//  FlagServiceDelegate.swift
//  TestInk
//
//  Created by C4Q on 3/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

protocol FlagDelegate: class {
    //didFlag : add flag to firebase under flag node, user who flagged and post that was flagged
    func didAddFlagToFirebase()
    func failedToAddFlagToFirebase()

}
