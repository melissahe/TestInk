//
//  FirebaseFlaggingService.swift
//  TestInk
//
//  Created by C4Q on 3/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



class FirebaseFlaggingService{
    
    private init(){
        //reference to root
        let dbRef = Database.database().reference()
        //child of the root
        flagRef = dbRef.child("flags")
    }
    
    private var flagRef: DatabaseReference!
    
    static let service = FirebaseFlaggingService()
    weak var delegate: FlagDelegate?
    
    
    //TODO: complete add function
    
    /*MARK:
     -Add flag to database
     -Add flag to user who is flagged
     -Add flag to user who flagged the post
     */
    
    //adds flag under the flag node in firebase
    func addFlagToFirebase(){}
    
    
    //user who flagged the post
    func addFlagToFlagger(){}
    
    
    //user who is being flagged
    func addFlagToFlagee(){}
    
    
    //get
    //delete
    //edit
    
}
