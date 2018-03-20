//
//  AuthUserService.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase


enum AuthUserStatus: Error {
    case failedToSignIn
    case didFailToVerifyEmail
    case failedToSignOut
    case failedToSendNewPassword
    case failedToCreateUser
}


//This API client is responsible for logging the user in and creating accounts in the Firebase database.
class AuthUserManager {
    
    private init(){
        //root reference
        let dbRef = Database.database().reference()
        //child reference
        usersRef = dbRef.child("users")
        self.auth = Auth.auth()
    }
    
    weak public var delegate: AuthUserDelegate!
    static let manager = AuthUserManager()
    private var usersRef: DatabaseReference!
    private var auth: Auth!
    
    // Gets and returns the current user logged into Firebase as a User object.
    //The User object contains info about the user, like phone number, display name, email, etc.
    //Methods can also be called on this User object to do things like send email verification,reset password etc.
    public func getCurrentUser() -> User? {
        return auth.currentUser
    }
    
    //Creates an account for the user with their email and password.WORKS!
    public func createAccount(withEmail email: String, password: String, AndUserName userName: String){
        self.auth.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failure creating user with error: \(error)")
                self.delegate?.didFailCreatingUser(self, error: AuthUserStatus.failedToCreateUser)
            } else if let user = user {
                print(user.displayName ?? "No name set")
                //checking if username already exists
                let child = self.usersRef.child(userName)
                child.observeSingleEvent(of: .value, with: {(dataSnapshot) in
                    //check to see if the username is already taken
                    guard !dataSnapshot.exists() else {print("\(userName) is already taken");return}
                })
                //send verification email
                user.sendEmailVerification(completion: {(error) in
                    if let error = error {
                        print("failed to send email verification with error : \(error)")
                        self.delegate?.didFailToVerifyEmail(self, error: AuthUserStatus.didFailToVerifyEmail)
                    } else {
                        self.delegate?.didSendEmailVerification(user: user.uid, message: "A verification email has been sent. Please check your email and verify your account before logging in.")
                    }
                })
                //add user to Firebase
                self.addUserToFirebaseDatabase(userUID: user.uid, name: userName, likes: 0, favorites: "")
            }
        }
    }
    
    private func addUserToFirebaseDatabase(userUID: String, name: String, likes: Int, favorites: String){
        let userNameDatabaseReference = usersRef.child(userUID)
        let childKey = userNameDatabaseReference.key
        let user: UserProfile
        user = UserProfile(userID: userUID, name: name, likes: likes, favorites: favorites)
        userNameDatabaseReference.setValue(user.toJSON()) { (error, _) in
            if let error = error {
                print("User not added with error: \(error)")
                self.delegate?.didFailCreatingUser(self, error: AuthUserStatus.failedToCreateUser)
            } else {
                print("User added to firebase with userUID: \(userUID)")
                self.delegate?.didCreateUser(self, user: user)
            }
        }
    }
    
    //Logs the user in with their email and password.WORKS!
    public func login(withEmail email: String, andPassword password: String){
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("failed to sign in with error: \(error)")
                self.delegate?.didFailToSignIn(self, error: AuthUserStatus.failedToSignIn)
            } else if let user = user {
                if !user.isEmailVerified{
                    self.delegate?.didFailToVerifyEmail(self, error: AuthUserStatus.didFailToVerifyEmail)
                    self.logout()
                }
                self.delegate?.didSignIn(self, user: user.uid)
                print("\(user.email, user.uid) logged in")
                print(self.auth.currentUser?.uid ?? "No ID login")
            }
        }
    }
    
    //Signs the current user out of the app and Firebase.WORKS!
    public func logout(){
        do{
            try auth.signOut()
            self.delegate?.didSignOut(self)
        } catch {
            print("failed to sign out with error: \(error)")
            self.delegate?.didFailSigningOut(self, error: AuthUserStatus.failedToSignOut)
        }
    }
    
    //WORKS!
    public func forgotPassword(withEmail email: String){
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("failed to send password with eror : \(error)")
                self.delegate?.didFailToSendPasswordReset(self, error: AuthUserStatus.failedToSendNewPassword)
            } else {
                self.delegate?.didSendPasswordReset(_userService: self)
                print("sent new password to \(email)")
                print("no password sent")
            }
        }
    }
    
    //gets userName from userID
    //    public func convertUIDToUserName(usingUID userUID: String, completion: @escaping (String) -> Void){
    //        let child = usersRef.child(userUID)
    //        child.observeSingleEvent(of: .value) { (dataSnapshot) in
    //            if let json = dataSnapshot.value {
    //                do {
    //                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
    //                    let user = try JSONDecoder().decode(UserProfile.self, from: jsonData)
    //                    completion(user.userName)
    //                } catch {
    //                    print("Failed to parse user profile data with error: \(error)")
    //                }
    //            }
    //        }
    //    }
    
    //changes users current user name to a new user name..WORKS!
    public func changeUserName(usingUserUID userUID: String, to newUserName: String ){
        let child = usersRef.child(userUID)
        child.child("userName").setValue(newUserName)
    }
    
    //load user for injection into user Profiles..
    //    private func getUser(fromUserUID userUID: String, completion: @escaping (_ currentUser: UserProfile) -> Void){
    //        usersRef.child(userUID)
    //        usersRef.observe(.value) { (dataSnapshot) in
    //            if let json = dataSnapshot.value {
    //                do{
    //                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
    //                    let currentUser = try JSONDecoder().decode(UserProfile.self, from: jsonData)
    //                    completion(currentUser)
    //                }catch{
    //                    print("Unable to parse currentUser")
    //                }
    //            }
    //        }
    //    }
}

