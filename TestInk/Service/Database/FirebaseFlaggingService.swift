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

enum PostType: String {
    case design = "design posts"
    case preview = "preview posts"
}

enum FlagStatus: Error {
    case errorParsingFlagData
    case errorGettingFlagData
}

class FirebaseFlaggingService{
    
    private init(){
        //reference to root
        dbRef = Database.database().reference()
        //child of the root
        flagRef = dbRef.child("flags")
        usersRef = dbRef.child("users")
    }
    
    private var dbRef: DatabaseReference!
    private var flagRef: DatabaseReference!
    private var usersRef: DatabaseReference!
    
    static let service = FirebaseFlaggingService()
    weak var delegate: FlagDelegate?

    //MARK: Adding a flag under the flag node in firebase
    func addFlagToFirebase(flaggedBy: String, userFlagged: String, postID: String, flagMessage: String){
        //create unique identifier
        let childByAutoID = Database.database().reference(withPath: "flags").childByAutoId()
        let childKey = childByAutoID.key
        //initialize the flag
        var flags: Flags
        flags = Flags(flagID: childKey, flaggedBy: flaggedBy, userFlagged: userFlagged, postID: postID, flagMessage: flagMessage)
        //set that value of the data converted by json
        childByAutoID.setValue(flags.flagsToJSON()) { (error, dbRef) in
            if let error = error {
                self.delegate?.failedToAddFlagToFirebase(self, error: error.localizedDescription)
                print("Error adding flag to firebase: \(error.localizedDescription)")
                print("Flag not added to fb")
            } else {
                self.delegate?.didAddFlagToFirebase(self)
                print("Flag added to firebase with flagID: \(childKey)")
            }
        }
    }
    
  
    ////TODO: Refactor below functions to model after codable data

    //MARK: Flagging a post and preventing the user from flagging the post more than once
    public func flagPost(withPostType postType: PostType, flaggedPostID: String,
                         flaggedByUserID userID: String,
                         flaggedCompletion: @escaping (Bool) -> Void) {
        let ref = dbRef.child(postType.rawValue).child(flaggedPostID)
        
        ref.runTransactionBlock({ (currentData) -> TransactionResult in
            if var designPost = currentData.value as? [String : Any] {
                var flaggedByDict = designPost["flaggedBy"] as? [String : Any] ?? [:]
                var flags = designPost["flags"] as? Int ?? 0
                //if user has flagged before
                if let _ = flaggedByDict[userID] {
                    self.delegate?.didFlagPostAlready(self, error: "You have flagged this post already.")
                } else { //user has not flagged before
                    // flag the post and add flag to self for tracking
                    flaggedByDict[userID] = true
                    flags += 1
                    DispatchQueue.main.async {
                        self.delegate?.didFlagPost(self)
                        flaggedCompletion(true)
                    }
                }
                designPost["flaggedBy"] = flaggedByDict
                designPost["flags"] = flags
                
                // Set value and report transaction success
                currentData.value = designPost
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: { (error, bool, _) in
            if let error = error {
                self.delegate?.didFailToFlagPost(self, error: error.localizedDescription)
                print("error flagging post: \(error.localizedDescription)")
            }
        })
    }
    
    public func getAllFlags(completionHandler: @escaping ([Flags]?, Error?) -> Void) {
        flagRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                print("couldn't get flags")
                completionHandler(nil, FlagStatus.errorGettingFlagData)
                return
            }
            var flags: [Flags] = []
            
            for snapshot in snapshots {
                guard let rawJSON = snapshot.value else {
                    print("couldn't get json from snapshot")
                    return
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let flag = try JSONDecoder().decode(Flags.self, from: data)
                    flags.append(flag)
                    //print("Added flag to array of flags")
                } catch let error {
                    print("Failed to parse flag data: \(error)")
                    completionHandler(nil, FlagStatus.errorParsingFlagData)
                    //print("failed to get all flags")
                    return
                }   
            }
            completionHandler(flags, nil)
            //print("got all flags successfully!")
        }
    }
    
    public func checkIfPostIsFlagged(post: DesignPost, byUserID userID: String, completionHandler: @escaping (Bool) -> Void) {
        
        getAllFlags { (flags, error) in
            if let flags = flags {
                if flags.contains(where: { (flag) -> Bool in
                    return flag.postID == post.uid && flag.flaggedBy == userID && flag.userFlagged == post.userID
                }) {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            } else if let error = error {
                print(error)
                completionHandler(false)
            }
        }
    }
    
    public func checkIfPostIsFlagged(post: PreviewPost, byUserID userID: String, completionHandler: @escaping (Bool) -> Void) {
        
        getAllFlags { (flags, error) in
            if let flags = flags {
                if flags.contains(where: { (flag) -> Bool in
                    return flag.postID == post.uid && flag.flaggedBy == userID && flag.userFlagged == post.userID
                }) {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            } else if let error = error {
                print(error)
                completionHandler(false)
            }
        }
    }
    
    ///////// VERSION 2 of app: flag users

    //MARK: Flagging a user
    public func flagUser(withUserID flaggedUserID: String,
                         flaggedByUserID userID: String,
                         flaggedCompletion: @escaping (Bool) -> Void) {
        
        let ref = usersRef.child(flaggedUserID)
        
        ref.runTransactionBlock({ (currentData) -> TransactionResult in
            if var user = currentData.value as? [String : Any] {
                var flaggedByDict = user["flaggedBy"] as? [String : Any] ?? [:]
                var flags = user["flags"] as? Int ?? 0
                //if the user has flagged before
                if let _ = flaggedByDict[userID] {
                    //self.delegate?.didFlagUserAlready?(self, error: "You have flagged this user already.")
                } else { //user has not flagged before
                    // favorite the post and add self to favorites
                    flaggedByDict[userID] = true
                    flags += 1
                    DispatchQueue.main.async {
                        // self.delegate?.didFlagUser?(self)
                        flaggedCompletion(true)
                    }
                }
                user["flaggedBy"] = flaggedByDict as Any
                user["flags"] = flags as Any
                
                currentData.value = user
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: { (error, bool, _) in
            if let error = error {
                //fail to flag
                //self.delegate?.didFailFlagging?(self, error: error.localizedDescription)
                print("error flagging user: \(error.localizedDescription)")
            }
        })
    }
}
