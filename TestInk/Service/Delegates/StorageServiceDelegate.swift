//
//  StorageServiceDelegate.swift
//  TestInk
//
//  Created by C4Q on 3/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage



protocol StorageServiceDelegate: class {
    
    func didStoreImage(_ storageService: FirebaseStorageService) //might need to try with UIImage
    func didFailStoreImage(_ storageService: FirebaseStorageService, error: String)
    
    func didRetrieveImage(_ storageService: FirebaseStorageService)
    func failedToRetrieveImage(_ storageService: FirebaseStorageService, error: String)
}
