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


enum ImageType: String {
    case userProfileImg = "users"
    case designPost = "design posts"
    case previewPost = "preview posts"
}


enum ImageReference {
    case designImgRef
    case previewImgRef
    case userProfileImgRef
}


class FirebaseStorageService {
    private init(){
        // Get a reference to the storage service using the default Firebase App
        storage = Storage.storage()
        // Create a storage reference from our storage service
        storageRef = storage.reference()
        
        //Create a child reference
        designImgRef = storageRef.child("design posts")
        previewImgRef = storageRef.child("preview posts")
        userProfileImgRef = storageRef.child("users")
    }
    
    static let service = FirebaseStorageService()
    weak var delegate: StorageServiceDelegate?
    
    //storage references
    private var storage: Storage!
    private var storageRef: StorageReference!
    private var designImgRef: StorageReference!
    private var previewImgRef: StorageReference!
    private var userProfileImgRef: StorageReference!
    
    
    //MARK: storing images to Firebase
    func storeImage(with imageRef: ImageReference, imageType: ImageType, imageID: String, image: UIImage){
        //resize the image
        guard let resizedImage = Toucan(image: image).resize(CGSize(width: 400, height: 400)).image else {return}
        //convert data to PNG representation
        guard let data = UIImagePNGRepresentation(resizedImage) else {return}
        
        //initialize storage meta data and set the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        //Nicole's
//        //switching on different references for more dynamic functionality
//        let ref: StorageReference
//        switch imageRef {
//        case .designImgRef:
//            ref = FirebaseStorageService.service.designImgRef
//        case .previewImgRef:
//            ref = FirebaseStorageService.service.previewImgRef
//        case .userProfileImgRef:
//            ref = FirebaseStorageService.service.userProfileImgRef
//        }
//
//        //set upload task: Updates the sub-node under the specific type bucket...imageID == designPost uid
//        //upload the file to the path
//        let uploadTask = ref.child(imageID).putData(data, metadata: metadata) { (storageMetaData, error) in
        
        //set upload task: Updates the sub-node under the specific type bucket
        let uploadTask = FirebaseStorageService.service.storageRef.child(imageType.rawValue).child(imageID).putData(data, metadata: metadata) { (storageMetaData, error) in
            if let error = error {
                print("uploadTask error: \(error)")
            } else if let storageMetaData = storageMetaData{
                print("storageMetadata: \(storageMetaData)")
                //there are alot of properties on storageMetaData!!
            }
        }
        
        //when upload is successful call the delegate and do things in the delegate method
        uploadTask.observe(.success) { (snapshot) in
            self.delegate?.didStoreImage(self)
            if let downloadedURL = snapshot.metadata?.downloadURL(){
                let imageURL = String(describing: downloadedURL)
                //set that url string at the correct reference: EX) whatever bucket/uid/image = pic
                Database.database().reference(withPath: imageType.rawValue).child(imageID).child("image").setValue(imageURL)
            }
        }
        
        //if upload is unsucessful call the delegate and do things in the delegate method
        uploadTask.observe(.failure) { (snapshot) in
            self.delegate?.didFailStoreImage(self, error: "Error with notifying user when upload fails")
        }
    }
    
    //MARK: Getting the image from Firebase
    func retrieveImage(imageURL: String,
                       completionHandler: @escaping (UIImage) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        ImageHelper.manager.getImage(from: imageURL,
                                     completionHandler: { completionHandler($0)},
                                     errorHandler: { errorHandler($0) })
    }
}

