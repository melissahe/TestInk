//
//  FirebaseDesignPostService.swift
//  TestInk
//
//  Created by C4Q on 3/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseDesignPostService {
    
    private init(){
        //root reference
        let dbRef = Database.database().reference()
        //child of the root
        designPostRef = dbRef.child("design posts")
    }
    
    private var designPostRef: DatabaseReference!
    static let service = FirebaseDesignPostService()
    weak var delegate: DesignPostDelegate?
    
    
    //MARK: Adding a design post to database
    public func addDesignPostToDatabase(with userID: String, imageURL: String, likes: Int, likedBy: Bool, timeStamp: Double, comments: String){
        //creating a unique key identifier
        let childByAutoID = Database.database().reference(withPath: "flashCard").childByAutoId()
        let childKey = childByAutoID.key
        var designPost: DesignPost
        designPost = DesignPost(userID: userID, likes: likes, likedBy: likedBy, timestamp: timeStamp, comments: comments)
        //setting the value of the design posts
        childByAutoID.setValue(designPost.designPostToJSON()) { (error, dbRef) in
            if let error = error {
                //self.delegate?.failedToAddDesignPost(self, error: FirebaseCardStatus.flashCardNotAdded)
                print("failed to add flashcard error: \(error)")
            } else {
                //self.delegate?.didAddDesignPost(self, post: designPost) // in extension call addFlashCardToCategory func
                print("flashcard saved to dbRef: \(dbRef)")
            }
        }
    }
    
    
    
    //MARK: Getting a design post from database
    func getAllDesignPosts(completionHandler: @escaping ([DesignPost]?, Error?) -> Void){
        // getting the reference for the node that is Posts
        let dbReference = Database.database().reference().child("design posts")
        dbReference.observe(.value){(snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {print("design posts node has no children");return}
            var allPosts = [DesignPost]()
            for snap in snapshots {
                //convert to json
                guard let rawJSON = snap.value else {continue}
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let designPost = try JSONDecoder().decode(DesignPost.self, from: jsonData)
                    allPosts.append(designPost)
                    //self.delegate?.didGetDesignPost()
                    print("design post added to DesignPost array")
                }catch{
                    //self.delegate?.failedToGetDesignPost()
                    print(error)
                }
            }
            completionHandler(allPosts, nil)
            //refactor with custom delegate methods
            if allPosts.isEmpty {
                print("There are no design posts in the database")
                
            } else {
                print("design posts loaded successfully!")
                
            }
        }
    }
    
    //delete
    //edit
    
}
