//
//  Firebase Models.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import UIKit

struct objectConversion: Codable{
    

}


struct UserProfile: Codable{
    let userID: String
    let displayName: String //from email
    let likes: Int
    let profileImageURL: String? = nil
    let favorites: String //favorite image urls
    var flags: Int
    var isBanned: Bool
    
    //trying to convert the parrot object into json data and add to database
    func convertToJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}



struct DesignPost: Codable {
    let uid: String
    let userID: String
    let imageURL: String? = nil
    let likes: Int
    var likedBy: Bool = false //should keep track of whether user liked post
    let timestamp: Double
    let comments: String //version 2
    let flags: Int
    
    func designPostToJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}

struct PreviewPost: Codable {
    let uid: String
    let userID: String
    let imageURL: String? = nil
    let likes: Int
    var likedBy: Bool = false
    let timestamp: Double
    let flags: Int
    let designID: String //used in the preview tab, when the user wants to try on a specific design, it will segue to the AR tab with that specific design by grabbing that posts autoID and passing it in

    func previewPosToJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}


struct Flags: Codable {
    let flagID: String
    let flaggedBY: String //userID of poster
    let userFlagged: String //userID of person being flagged
    let postID: String
    let flagMessage: String //users reasoning for flagging
    
    func flagsToJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}
