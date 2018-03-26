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
    
    //MARK: Adding a flag under the flag node in firebase
    func addFlagToFirebase(flagID: String, flaggedBy: String, userFlagged: String, postID: String, flagMessage: String ){
        //create unique identifier
        let childByAutoID = Database.database().reference(withPath: "flags").childByAutoId()
        //initialize the flag
        var flags: Flags
        flags = Flags(flagID: flagID, flaggedBy: flaggedBy, userFlagged: userFlagged, postID: postID, flagMessage: flagMessage)
        //set that value of the data converted by json
        childByAutoID.setValue(flags.flagsToJSON()) { (error, dbRef) in
            if let error = error {
                self.delegate?.failedToAddFlagToFirebase()
                print("Error adding flag to firebase: \(error.localizedDescription)")
            } else {
                self.delegate?.didAddFlagToFirebase()
                print("Flag added to firebase with flagID: \(flagID)")
            }
        }
    }
    
    
    //MARK: Adding a flag under the user who flagged the post
    func addFlagToFlagger(userID: String, postID: String){
        
    }
    
    
    //MARK: Adding a flag under the user who is being flagged
    func addFlagToFlagee(flagedUser: String){
        
    }
    
    
    //get
    //delete
    //edit
}
