//
//  FirebaseUserService.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


enum UserProfileStatus: Error {
    case failedToAddToDatabase
    case didAddToDatabase
    case failedToLoadUSer
    case didLoadUser

}

//This API client is responsible for handling any changes, updatesin regards to the User Profile Object.
class UserProfileService {
    
    init(){ //not private because class is needed to add user profile object to firbase when the user is created
        //root reference
        let dbRef = Database.database().reference()
        //child reference
        usersRef = dbRef.child("users")
    }
    
    weak public var delegate: AuthUserDelegate!
    static let manager = UserProfileService()
    private var usersRef: DatabaseReference!
    
    
    //MARK: Adds user to database
    func addUserToFirebaseDatabase(userUID: String, displayName: String, likes: Int, profileImageURL: String, favorites: String, flags: Int, isBanned: Bool){
        let userNameDatabaseReference = usersRef.child(userUID)
        let user: UserProfile
        user = UserProfile(userID: userUID, displayName: displayName, likes: likes, favorites: [favorites], flags: flags, isBanned: isBanned)
        userNameDatabaseReference.setValue(user.convertToJSON()) { (error, _) in
            if let error = error {
                print("User not added with error: \(error)")
            } else {
                print("User added to firebase with userUID: \(userUID)")
            }
        }
    }
    
    
    //MARK: get user for injection into public and private user profiles
    private func getUser(fromUserUID userUID: String, completion: @escaping (_ currentUser: UserProfile) -> Void){
        usersRef.child(userUID)
        usersRef.observe(.value) { (dataSnapshot) in
            if let json = dataSnapshot.value {
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let currentUser = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                    completion(currentUser)
                }catch{
                    print("Unable to parse currentUser")
                }
            }
        }
    }
    
    //TODO: change user profile image
    //TODO: get favorites from user: user -> favorites -> GET

    
    /////////////Functions to use in version 2
    
    
    //MARK: Gets display name from userID
    public func getName(from userUID: String, completion: @escaping (String) -> Void){
        let child = usersRef.child(userUID)
        child.observeSingleEvent(of: .value) { (dataSnapshot) in
            if let json = dataSnapshot.value {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let user = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                    completion(user.displayName)
                } catch {
                    print("Failed to parse user profile data with error: \(error)")
                }
            }
        }
    }
    
    
    //MARK: Changes users current user name to a new user name
    public func switchUserName(using userUID: String, to newUserName: String ){
        let child = usersRef.child(userUID)
        child.child("userName").setValue(newUserName)
    }
    

    //TODO: delete user account and sign them out
}


