//
//  REFACTOREDSS...DO NOT COMMIT.swift
//  TestInk
//
//  Created by C4Q on 3/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Firebase
import Toucan
import Foundation
import FirebaseStorage
import FirebaseDatabase

enum ImageTypes: String {
    case userProfileImg = "a"
    case designPost = "b"
    case previewPost = "c"
}

class StorageService{
    private init(){
        // Get a reference to the storage service using the default Firebase App
        storage = Storage.storage()
        // Create a storage reference from our storage service
        storageRef = storage.reference()
        // Create a child reference: folder that shows up in Firebase
        designImgRef = storageRef.child("design images")
        previewImgRef = storageRef.child("preview images")
        userProfileImgRef = storageRef.child("user profile images")
    }
    
    weak var delegate: StorageServiceDelegate?
    static let service = StorageService()
    //storage references
    private var storage: Storage!
    private var storageRef: StorageReference!
    private var designImgRef: StorageReference!
    private var previewImgRef: StorageReference!
    private var userProfileImgRef: StorageReference!
    
    func storeImage(with type: String, uid: String, image: UIImage){
        //convert data to PNG
        guard let data = UIImagePNGRepresentation(image) else {return}
        //resize the image
        guard Toucan(image: image).resize(CGSize(width: 400, height: 400)).image != nil else {return}
        
        //initialize storage meta data and set the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        //set upload task
        let uploadTask = StorageService.service.designImgRef.child(uid).putData(data, metadata: metadata) { (storageMetaData, error) in
            if let error = error{
                print("uploadTask error: \(error)")
            }else if let storageMetaData = storageMetaData{
                print("storageMetadata: \(storageMetaData)")
                //there are alot of properties on storageMetaData!!
            }
        }
        //observe success
        uploadTask.observe(.success) { (snapshot) in
            
        }
        //observe failure
        uploadTask.observe(.failure) { (snapshot) in
            
        }
    }
    
    //    func storeImage(type: String, uid: String, image: UIImage){
    //        //convert to PNG
    //        guard let data = UIImagePNGRepresentation(image) else {print("Image is not PNG");return}
    //
    //        //let resizedImage =
    //        //var toucanImage = Toucan(image: image).resize(400)
    //
    //        let metadata = StorageMetadata()
    //        metadata.contentType = "image/png" //need ths to store images
    //    }
    
    //    //Design Image Bucket
    //    func storeDesignImage(type: String, uid: String, image: UIImage){
    //        guard let data = UIImagePNGRepresentation(image) else {print("Image is not PNG");return}
    //
    //        let metadata = StorageMetadata()
    //        metadata.contentType = "image/png" //need ths to store images
    //
    //        let uploadTask = StorageService.service.designImgRef.child(uid).putData(data, metadata: metadata) { (storageMetaData, error) in
    //            if let error = error{
    //                print("uploadTask error: \(error)")
    //            }else if let storageMetaData = storageMetaData{
    //                print("storageMetadata: \(storageMetaData)")
    //                //there are alot of properties on storageMetaData!!
    //            }
    //        }
    //        //if upload is a success
    //        uploadTask.observe(.success) { (snapshot) in
    //            // Upload completed successfully: set the design post, preview post and user profile imageURL
    //            guard let imageURL = snapshot.metadata!.downloadURL() else {print("could not get image download url");return}
    //            print("uploaded image")
    //            //convert to String
    //            let imageURLString = imageURL.absoluteString
    //            //setting the image url in the database under the design images node
    //            Database.database().reference(withPath: "design images").child(uid).child("image").setValue(imageURLString)
    //        }
    //        //if upload fails
    //        uploadTask.observe(.failure) { (snapshot) in
    //            if let error = snapshot.error as? NSError{
    //                self.delegate?.didFailStoreImage(self, error: error.localizedDescription)
    //            }
    //        }
    //    }
    
}
