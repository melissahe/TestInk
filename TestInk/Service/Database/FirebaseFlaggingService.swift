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
        usersRef = dbRef.child("users")
        designPostRef = dbRef.child("design posts")
    }
    
    private var flagRef: DatabaseReference!
    private var usersRef: DatabaseReference!
    private var designPostRef: DatabaseReference!
    
    static let service = FirebaseFlaggingService()
    weak var delegate: FlagDelegate?

    //MARK: Adding a flag under the flag node in firebase
    func addFlagToFirebase(flagID: String, userID: String, flaggedBy: String, userFlagged: String, postID: String, flagMessage: String ){
        //create unique identifier
        let childByAutoID = Database.database().reference(withPath: "flags").childByAutoId()
        let childKey = childByAutoID.key
        //initialize the flag
        var flags: Flags
        flags = Flags(flagID: childKey, userID: userID, flaggedBy: flaggedBy, userFlagged: userFlagged, postID: postID, flagMessage: flagMessage)
        //set that value of the data converted by json
        childByAutoID.setValue(flags.flagsToJSON()) { (error, dbRef) in
            if let error = error {
                self.delegate?.failedToAddFlagToFirebase(self, error: error.localizedDescription)
                print("Error adding flag to firebase: \(error.localizedDescription)")
                print("Flag not added to fb")
            } else {
                self.delegate?.didAddFlagToFirebase(self)
                print("Flag added to firebase with flagID: \(flagID)")
            }
        }
    }
    
  
    ////TODO: Refactor below functions to model after codable data
    
    
    //MARK: Flagging a post and preventing the user from flagging the post more than once
    public func flagPost(withDesignPostID flaggedDesignPostID: String,
                         flaggedByUserID userID: String,
                         flaggedCompletion: @escaping (Bool) -> Void) {
        let ref = designPostRef.child(flaggedDesignPostID)
        
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
    
    
    
    //MARK: Functionaly to favorite posts...there should be separate functions!!
    public func favoritePost(withDesignPostID designPostID: String,
                             favoritedByUserID userID: String,
                             favoriteCompletion: @escaping (Int) -> Void) {
        let ref = designPostRef.child(designPostID)
        
        ref.runTransactionBlock({ (currentData) -> TransactionResult in
            if var designPost = currentData.value as? [String : Any] {
                var favoritesDict = designPost["favoritedBy"] as? [String : Any] ?? [:]
                var favorites = designPost["numberOfFavorites"] as? Int ?? 0
                
                //if user has liked already
                if let _ = favoritesDict[userID] {
                    // Unfavorite the post and remove self from favorites
                    favorites -= 1
                    favoritesDict.removeValue(forKey: userID)
                    DispatchQueue.main.async {
                        self.delegate?.didUnfavoritePost(self, withPostID: designPostID)
                        favoriteCompletion(favorites)
                    }
                } else { //if user has not liked yet
                    //favorite the post and add self to favorites
                    favorites += 1
                    favoritesDict[userID] = true
                    DispatchQueue.main.async {
                        self.delegate?.didFavoritePost(self, withPostID: designPostID)
                        favoriteCompletion(favorites)
                    }
                }
                designPost["favoritedBy"] = favoritesDict
                designPost["numberOfFavorites"] = favorites
                
                // Set value and report transaction success
                currentData.value = designPost
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: { (error, _, _) in
            if let error = error {
                //delegate with fail to like post
                self.delegate?.didFailFavoritingPost(self, error: error.localizedDescription)
                print("error favoriting post: \(error.localizedDescription)")
            }
        })
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
