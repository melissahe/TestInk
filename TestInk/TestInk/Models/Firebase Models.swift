//
//  Firebase Models.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import UIKit


struct userProfile: Codable{
    let userID: String
    let name: String //from email
    let likes: Int
    let profileImageURL: String? = nil
    let favorites: String //favorite image urls
    
    //trying to convert the parrot object into json data and add to database
    func toJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}



struct Post: Codable {
    let userID: String
    let imageURL: String? = nil
    let likes: Int
    var userLiked: Bool = false //should keep track of whether user liked post
    let timestamp: Double
    
    func toJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}
