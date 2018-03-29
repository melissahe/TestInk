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

enum DesignPostStatus: Error {
    case designPostNotAdded
    case errorParsingDesignPostData
    case designPostDidNotUpdate
    case designPostNotDeleted
}


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
    public func addDesignPostToDatabase(userID: String, image: UIImage, likes: Int, timeStamp: Double, comments: String, flags: Int){
        //creating a unique key identifier
        let childByAutoID = Database.database().reference(withPath: "design posts").childByAutoId()
        let childKey = childByAutoID.key
        var designPost: DesignPost
        designPost = DesignPost(uid: childKey, userID: userID, image: nil, likes: likes, timestamp: timeStamp, comments: comments, flags: flags)
        //setting the value of the design posts
        childByAutoID.setValue(designPost.designPostToJSON()) { (error, dbRef) in
            if let error = error {
                self.delegate?.failedToAddDesignPostToFirebase(self, error: DesignPostStatus.designPostNotAdded)
                print("failed to add flashcard error: \(error)")
            } else {
                //storing image into design posts bucket in firebase
                FirebaseStorageService.service.storeImage(with: .designImgRef, imageType: .designPost, imageID: childKey, image: image)
                self.delegate?.didAddDesignPostToFirebase(self, post: designPost, designID: childKey)
                print("flashcard saved to dbRef: \(dbRef)")
                //should do storage here
            }
        }
    }
    
    //MARK: Getting a design post from database
    func getAllDesignPosts(completionHandler: @escaping ([DesignPost]?, Error?) -> Void){
        // getting the reference for the node that is Posts
        let dbReference = Database.database().reference().child("design posts")
        dbReference.observe(.value){(snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {print("design posts node has no children");return}
            var allDesignPosts = [DesignPost]()
            for snap in snapshots {
                guard let rawJSON = snap.value else {continue}
                do{//convert to json
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let designPost = try JSONDecoder().decode(DesignPost.self, from: jsonData)
                    allDesignPosts.append(designPost)
                    self.delegate?.didGetAllDesignPosts(self, post: designPost) // might be allDesignPosts
                    print("design post added to DesignPost array")
                }catch{
                    self.delegate?.failedToGetAllDesignPosts(self, error: DesignPostStatus.errorParsingDesignPostData)
                    print(error)
                }
            }
            completionHandler(allDesignPosts, nil)
            //For testing purposes
            if allDesignPosts.isEmpty {
                print("There are no design posts in the database")
            } else {
                print("design posts loaded successfully!")
            }
        }
    }
    //delete
    //edit
}
