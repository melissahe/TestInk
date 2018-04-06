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

//This service is responsible for handling any changes in regards to the User Profile Object.
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
        user = UserProfile(userID: userUID, displayName: displayName, likes: likes, image: nil, flags: flags, isBanned: isBanned)
        userNameDatabaseReference.setValue(user.convertToJSON()) { (error, _) in
            if let error = error {
                print("User not added with error: \(error)")
            } else {
                print("User added to firebase with userUID: \(userUID)")
            }
        }
    }
    
    
    //MARK: get user for injection into public and private user profiles
    public func getUser(fromUserUID userUID: String, completion: @escaping (_ currentUser: UserProfile) -> Void){
        usersRef.child(userUID)
        usersRef.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let snapshots = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                print("couldn't get user snapshots")
                return
            }
            var currentUsers: [UserProfile] = []
            for snapshot in snapshots {
                if let json = snapshot.value {
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                        let currentUser = try JSONDecoder().decode(UserProfile.self, from: jsonData)
                        currentUsers.append(currentUser)
                    }catch{
                        print("Unable to parse currentUser")
                    }
                }
            }
            if let index = currentUsers.index(where: { (userProfile) -> Bool in
                return userProfile.userID == userUID
            }) {
                let currentUser = currentUsers[index]
                completion(currentUser)
            }
        }
    }

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


