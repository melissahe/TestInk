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


//MARK: This service is responsible for logging the user in and creating accounts in the Firebase database.
class AuthUserService {
    
    private init(){
        self.auth = Auth.auth()
    }
    
    weak public var delegate: AuthUserDelegate!
    static let manager = AuthUserService()
    var userService = UserProfileService()
    private var auth: Auth!
    
    /*MARK
     -Gets and returns the current user logged into Firebase as a User object.
     -The User object contains info about the user, like phone number, display name, email, etc.
     -Methods can also be called on this User object to do things like send email verification,reset password etc.
     */
    public func getCurrentUser() -> User? {
        print(Auth.auth().currentUser?.uid ?? "No current user")
        return auth.currentUser
    }
    
    //    func getCurrentUser() -> User? {
    //        if Auth.auth().currentUser != nil {
    //            print(Auth.auth().currentUser?.uid ?? "No current user")
    //            return Auth.auth().currentUser
    //        }
    //        return nil
    //    }
    
    //MARK: Creates an account for the user with their email and password.
    public func createAccount(withEmail email: String, password: String, displayName: String){
        self.auth.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failure creating user with error: \(error)")
                self.delegate?.didFailCreatingUser(self, error: error)
            } else if let user = user {
                UserDefaultsHelper.manager.saveEmail(email: email)
                print(user.uid)
                // update and authenticate user display name with their email
                let changeRequest = user.createProfileChangeRequest()
                let stringArray = user.email!.components(separatedBy: "@") //["ncsouvenir", "@", "gmail.com"]
                let userName = stringArray[0] //["ncsouvenir"]
                changeRequest.displayName = userName
                changeRequest.commitChanges(completion: {(error) in
                    if let error = error{
                        print("change request error: \(error)")
                    } else{
                        print("changeRequest was successful for userName: \(userName)")
                        self.delegate?.didCreateUser(self, user: user) //creating user with UserProfile Object and adding to database
                        self.userService.addUserToFirebaseDatabase(userUID: user.uid, displayName: displayName, likes: 0, profileImageURL: "", favorites: "", flags: 0, isBanned: false)
                        print("\(userName) was added to database)")
                    }
                })
            }
        }
    }
    
    
    //MARK: Logs the user in with their email and password
    public func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("failed to sign in with error: \(error)")
                self.delegate?.didFailToSignIn(self, error: AuthUserStatus.failedToSignIn)
            } else if let user = user {
                UserDefaultsHelper.manager.saveEmail(email: email)
                self.delegate?.didSignIn(self, user: user)
                print("\(user.email, user.uid) logged in")
                print(Auth.auth().currentUser?.uid ?? "No ID login")
            }
        }
    }
    
    
    //MARK: Signs the current user out of the app
    public func logout(){
        do{
            try auth.signOut()
            self.delegate?.didSignOut(self)
        } catch {
            print("failed to sign out with error: \(error)")
            self.delegate?.didFailSigningOut(self, error: AuthUserStatus.failedToSignOut)
        }
    }
    
    //MARK: Sends the user an email to reset password
    public func forgotPassword(withEmail email: String){
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("failed to send password with eror : \(error)")
                self.delegate?.didFailToSendPasswordReset(self, error: AuthUserStatus.failedToSendNewPassword)
            } else {
                self.delegate?.didSendPasswordReset(_userService: self)
                print("sent new password to \(email)")
            }
        }
    }
}

