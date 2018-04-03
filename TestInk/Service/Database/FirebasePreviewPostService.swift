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

enum PreviewPostStatus: Error {
    case previewPostNotAdded
    case errorParsingPreviewPostData
    case previewPostDidNotUpdate
    case previewPostNotDeleted
}


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
    public func addPreviewPostToDatabase(userID: String, image: UIImage, likes: Int, timeStamp: Double, comments: String, designID: String?, flags: Int){
        //creating a unique key identifier
        let childByAutoID = Database.database().reference(withPath: "preview posts").childByAutoId()
        let childKey = childByAutoID.key
        var previewPost: PreviewPost
        previewPost = PreviewPost(uid: childKey, userID: userID, image: nil, likes: likes, timestamp: timeStamp, flags: flags, designID: designID)
        //setting the value of the design posts
        childByAutoID.setValue(previewPost.previewPosToJSON()) { (error, dbRef) in
            if let error = error {
                self.delegate?.failedToAddPreviewPostToFirebase(self, error: PreviewPostStatus.previewPostNotAdded)
                print("failed to add flashcard error: \(error)")
            } else {
                //storing image into preview posts bucket in firebase
                FirebaseStorageService.service.storeImage(withImageType: .previewPost, imageUID: childKey, image: image)
                self.delegate?.didAddPreviewPostToFirebase(self, post: previewPost)
                print("flashcard saved to dbRef: \(dbRef)")
            }
        }
    }
    
    
    //MARK: Getting a design post from database
    func getAllPreviewPosts(completionHandler: @escaping ([PreviewPost]?, Error?) -> Void){
        // Get reference for the node that is preview posts
        let dbReference = Database.database().reference().child("preview posts")
        dbReference.observeSingleEvent(of: .value){(snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {print("preview posts node has no children");return}
            var allPreviewPosts = [PreviewPost]()
            for snap in snapshots {
                guard let rawJSON = snap.value else {continue}
                do{ //convert to json
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let previewPost = try JSONDecoder().decode(PreviewPost.self, from: jsonData)
                    allPreviewPosts.append(previewPost)
                    self.delegate?.didGetAllPreviewPosts(self, post: previewPost)
                    print("preview post added to PreviewPost array")
                }catch{
                    self.delegate?.failedToGetAllPreviewPosts(self, error: PreviewPostStatus.errorParsingPreviewPostData)
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

