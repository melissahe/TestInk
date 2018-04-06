//
//  FirebaseLikingService.swift
//  TestInk
//
//  Created by C4Q on 3/29/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum LikeStatus: Error {
    
}

class FirebaseLikingService {
    
    private init() {
        self.dbRef = Database.database().reference()
        self.likesRef = self.dbRef.child("likes")
        self.designPostsRef = self.dbRef.child("design posts")
    }
    
    public static var service = FirebaseLikingService()
    public var delegate: LikeServiceDelegate?
    
    private var dbRef: DatabaseReference!
    private var likesRef: DatabaseReference!
    private var designPostsRef: DatabaseReference!
    
    //MARK: Functionaly to favorite posts...there should be separate functions!!
    public func favoritePost(withDesignPostID designPostID: String,
                             favoritedByUserID userID: String,
                             favoriteCompletion: @escaping (Int) -> Void) {
        let designPostref = designPostsRef.child(designPostID)
        let likeRef = likesRef.child(userID)
        
        designPostref.runTransactionBlock({ (currentData) -> TransactionResult in
            if var designPost = currentData.value as? [String : Any] {
                var favoritesDict = designPost["favoritedBy"] as? [String : Any] ?? [:]
                var favorites = designPost["likes"] as? Int ?? 0
                
                //if user has liked already
                if let _ = favoritesDict[userID] {
                    // Unfavorite the post and remove self from favorites
                    favorites -= 1
                    favoritesDict.removeValue(forKey: userID)
                    DispatchQueue.main.async {
                        //should unlike
                        self.delegate?.didUnfavoritePost(self, withPostID: designPostID)
                        
                        favoriteCompletion(favorites)
                    }
                } else { //if user has not liked yet
                    //favorite the post and add self to favorites
                    favorites += 1
                    favoritesDict[userID] = ["timestamp" : Date.timeIntervalSinceReferenceDate]
                    DispatchQueue.main.async {
                        //should like
                        self.delegate?.didFavoritePost(self, withPostID: designPostID)
                        favoriteCompletion(favorites)
                    }
                }
                designPost["favoritedBy"] = favoritesDict
                designPost["likes"] = favorites
                
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
            } else {
                self.addOrRemoveLikeToFirebase(forUserID: userID, toPostID: designPostID)
            }
        })
    }

    public func addOrRemoveLikeToFirebase(forUserID userID: String, toPostID postID: String) {
        let likeRef = likesRef.child(userID)
        
        likeRef.runTransactionBlock { (currentData) -> TransactionResult in
            
            var likeDict = currentData.value as? [String : Any] ?? [:]
            //if user has liked post before
            if let _ = likeDict[postID] {
                //remove like
                likeDict.removeValue(forKey: postID)
            } else { //if user has not liked post before
                //add like
                likeDict[postID] = ["timestamp" : Date.timeIntervalSinceReferenceDate]
            }
            currentData.value = likeDict
            return TransactionResult.success(withValue: currentData)
        }
    }
    
    public func getAllLikes(forUserID userID: String, completionHandler: @escaping ([String]) -> Void) {
        let likeRef = likesRef.child(userID)
        likeRef.observe(.value) { (dataSnapshot) in
            let snapshots = dataSnapshot.value as? [String : Any] ?? [:]
            var likesArray: [(postID: String, timestamp: Double)] = []
            for snapshot in snapshots {
                guard let timestampDict = snapshot.value as? [String: Any] else {
                    print("couldn't get timestamp dict")
                    continue
                }
                guard let timestamp = timestampDict["timestamp"] as? Double else {
                    print("couldn't get timestamp")
                    continue
                }
                let postID = snapshot.key
                likesArray.append((postID, timestamp))
            }
            let timeSortedLikes = likesArray.sorted(by: { (likeOne, likeTwo) -> Bool in
                return likeOne.timestamp > likeTwo.timestamp
            }).map({ (like) -> String in
                return like.postID
            })
            completionHandler(timeSortedLikes)
        }
    }
    
    public func getAllLikes(forPostID postID: String, completionHandler: @escaping ([String]) -> Void) {
        let ref = designPostsRef.child(postID)
        
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let postDict = dataSnapshot.value as? [String : Any] else {
                print("couldn't get design post dict")
                return
            }
            var likesArray: [String] = []
            if let likesDict = postDict["favoritedBy"] as? [String : Any] {
                for key in likesDict.keys {
                    likesArray.append(key)
                }
            }
            completionHandler(likesArray)
        }
    }
    
//    public func checkIfPostIsLiked(post: DesignPost, byUserID userID: String, completionHandler: @escaping (Bool) -> )
}
