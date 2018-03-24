//
//  FirebaseStorageService.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Firebase
import Toucan
import Foundation
import FirebaseStorage
import FirebaseDatabase


enum ImageType {
    case user
    case designPost
    case previewPost
}

//TODO: Add Toucan resizing
//TODO: how to add 3 folders into firebase storage. Right now It only has one: design post
class FirebaseStorageService{
    
    private init(){
        // Get a reference to the storage service using the default Firebase App
        storage = Storage.storage()
        // Create a storage reference from our storage service
        storageRef = storage.reference()
        // Create a child reference: folder that shows up in Firebase
        //imagesRef = storageRef.child("images")
        designImgRef = storageRef.child("design images")
        previewImgRef = storageRef.child("preview images")
        userProfileImgRef = storageRef.child("user profile images")
    }
    static let service = FirebaseStorageService()
    private var storage: Storage!
    private var storageRef: StorageReference!
    // private var imagesRef: StorageReference!
    private var designImgRef: StorageReference!
    private var previewImgRef: StorageReference!
    private var userProfileImgRef: StorageReference!
    
    weak var delegate: StorageServiceDelegate?
    
    
    //Add File Metadata
    func storeImage(type: ImageType, uid: String, image: UIImage) {
        //convert image to png: best practices
        guard let data = UIImagePNGRepresentation(image) else { print("image is nil"); return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png" //MUST HAVE THIS TO STORE
        
        //Initializing a NSData object and returns an FIRStorageUploadTask, which you can use to manage your upload and monitor its status.
        let designImgUploadTask = FirebaseStorageService.service.designImgRef.child(uid).putData(data, metadata: metadata) { (storageMetadata, error) in
            if let error = error {
                print("uploadTask error: \(error)")
            } else if let storageMetadata = storageMetadata {
                print("storageMetadata: \(storageMetadata)")
                //there are alot of properties on storageMetaData!!
            }
        }
//        let previewImgUploadTask = FirebaseStorageService.service.previewImgRef.child(uid).putData(data, metadata: metadata) { (storageMetadata, error) in
//            if let error = error {
//                print("uploadTask error: \(error)")
//            } else if let storageMetadata = storageMetadata {
//                print("storageMetadata: \(storageMetadata)")
//                //there are alot of properties on storageMetaData!!
//            }
//        }
//        let userProfileImgUploadTask = FirebaseStorageService.service.userProfileImgRef.child(uid).putData(data, metadata: metadata) { (storageMetadata, error) in
//            if let error = error {
//                print("uploadTask error: \(error)")
//            } else if let storageMetadata = storageMetadata {
//                print("storageMetadata: \(storageMetadata)")
//                //there are alot of properties on storageMetaData!!
//            }
//        }
        
     
        
        //PROGRESS -- observes the percentage / 100 that the image is uploading
        designImgUploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentProgress = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentProgress)
        }
        
        //SUCCESS: when the image is successully stored and it matches a specific case, set its filePath in the storage database
        designImgUploadTask.observe(.success) { snapshot in
            // Upload completed successfully: set the design post, preview post and user profile imageURL
            let imageURL = String(describing: snapshot.metadata!.downloadURL()!)
            switch type {
            case .user:
                Database.database().reference(withPath: "users").child(uid).child("image").setValue(imageURL) //users/uid/image = pic
            case .designPost:
                Database.database().reference(withPath: "posts").child(uid).child("image").setValue(imageURL)
            case .previewPost:
                Database.database().reference(withPath: "posts").child(uid).child("image").setValue(imageURL)
            }
        }
        
        //FAILURE: If image failes to load return error reasoning
        designImgUploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    /* ... */
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
    
    //MARK: Getting the image from firebase
    func retrieveImage(imageURL: String,
                       completionHandler: @escaping (UIImage) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        ImageHelper.manager.getImage(from: imageURL,
                                     completionHandler: { completionHandler($0)},
                                     errorHandler: { errorHandler($0) })
    }
}





