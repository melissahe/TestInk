//
//  FirebasePreviewPostService.swift
//  TestInk
//
//  Created by C4Q on 3/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebasePreviewPostService {
    
    private init(){
        //root reference
        let dbRef = Database.database().reference()
        //child of the root
        previewPostRef = dbRef.child("preview posts")
    }
    
    private var previewPostRef: DatabaseReference!
    static let service = FirebasePreviewPostService()
    weak var delegate: PreviewPostDelegate?
    
    
    //MARK: Adding a design post to database
    public func addPreviewPostToDatabase(with userID: String, imageURL: String, likes: Int, likedBy: Bool, timeStamp: Double, comments: String){
        //creating a unique key identifier
        let childByAutoID = Database.database().reference(withPath: "flashCard").childByAutoId()
        let childKey = childByAutoID.key
        var designPost: DesignPost
        designPost = DesignPost(userID: userID, likes: likes, likedBy: likedBy, timestamp: timeStamp, comments: comments)
        //setting the value of the design posts
        childByAutoID.setValue(designPost.designPostToJSON()) { (error, dbRef) in
            if let error = error {
                //self.delegate?.failedToAddPreviewPost(self, error: FirebaseCardStatus.flashCardNotAdded)
                print("failed to add flashcard error: \(error)")
            } else {
                //self.delegate?.didAddPreviewPost(self, post: designPost) // in extension call addFlashCardToCategory func
                print("flashcard saved to dbRef: \(dbRef)")
            }
        }
    }
    
    
    
    //MARK: Getting a design post from database
    func getAllPreviewPosts(completionHandler: @escaping ([PreviewPost]?, Error?) -> Void){
        // getting the reference for the node that is Posts
        let dbReference = Database.database().reference().child("preview posts")
        dbReference.observe(.value){(snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {print("preview posts node has no children");return}
            var allPreviewPosts = [PreviewPost]()
            for snap in snapshots {
                //convert to json
                guard let rawJSON = snap.value else {continue}
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let previewPost = try JSONDecoder().decode(PreviewPost.self, from: jsonData)
                    allPreviewPosts.append(previewPost)
                    //self.delegate?.didGetPreviewPost()
                    print("preview post added to PreviewPost array")
                }catch{
                    //self.delegate?.failedToGetPreviewPost()
                    print(error)
                }
            }
            completionHandler(allPreviewPosts, nil)
            if allPreviewPosts.isEmpty {
                print("There are no preview posts in the database")
                
            } else {
                print("preview posts loaded successfully!")
            }
        }
    }
    
    //delete
    //edit
    
}

