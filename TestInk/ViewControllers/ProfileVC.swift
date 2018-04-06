//
//  ProfileVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class ProfileVC: UIViewController {
    
    private lazy var profileView = ProfileView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
    private lazy var emptyView = EmptyView(frame: self.view.safeAreaLayoutGuide.layoutFrame, emptyStateType: .favorites)

    lazy var currentUserID = AuthUserService.manager.getCurrentUser()!.uid
    
    let cellSpacing: CGFloat = 5.0
    
    private var favoritePostIDs: [String] = []
    
    private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Favorites"
        setupViews()
        setupNavigation()
        profileView.collectionView.dataSource = self
        profileView.collectionView.delegate = self
        imagePickerController.delegate = self
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        profileView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cachedUserImage = NSCacheHelper.manager.getImage(with: currentUserID) {
           profileView.profileImageView.image = cachedUserImage
        } else {
            UserProfileService.manager.getUser(fromUserUID: currentUserID) { (userProfile) in
                self.profileView.displayName.text = userProfile.displayName
                
                guard let imageURL = userProfile.image else {return}
                ImageHelper.manager.getImage(from: imageURL, completionHandler: { (profileImage) in
                    self.profileView.profileImageView.image = profileImage
                    FirebaseStorageService.service.storeImage(withImageType: .userProfileImg, imageUID: self.currentUserID, image: profileImage)
                    //NSCacheHelper.manager.addImage(with: self.currentUserID, and: profileImage)
                }, errorHandler: { (error) in
                    print("Couldn't get profile Image \(error)")
                })
            }
        }
    }
    
    private func loadData() {
        UserProfileService.manager.getName(from: currentUserID) { (displayName) in
            self.profileView.displayName.text = displayName
        }
        FirebaseLikingService.service.getAllLikes(forUserID: currentUserID) { (likedPosts) in
            //likedPosts.forEach{print("User likes:",self.currentUserID,$0)}
            self.favoritePostIDs = likedPosts
            self.profileView.collectionView.reloadData()
            
            if likedPosts.isEmpty {
                self.view.addSubview(self.emptyView)
                self.emptyView.snp.makeConstraints({ (make) in
                    make.edges.equalTo(self.profileView.collectionView.snp.edges)
                })
            } else {
                self.emptyView.removeFromSuperview()
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(profileView)
        view.backgroundColor = UIColor.Custom.lapisLazuli
        
        profileView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func setupNavigation() {
        //right bar button
        let addLogoutItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settingIcon"), style: .done, target: self, action: #selector(settingsButtonPressed))
            
//            UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutPressed))
        
        navigationItem.rightBarButtonItem = addLogoutItem
        profileView.changeProfileImageButton.addTarget(self, action: #selector(changeProfileButtonPressed), for: .touchUpInside)
    }
    
    @objc private func settingsButtonPressed() {
        let settingsAlert = Alert.create(withTitle: nil, andMessage: nil, withPreferredStyle: .actionSheet)
        Alert.addAction(withTitle: "Logout", style: .destructive, andHandler: { (_) in
            AuthUserService.manager.delegate = self
            AuthUserService.manager.logout()
        }, to: settingsAlert)
        Alert.addAction(withTitle: "Cancel", style: .cancel, andHandler: nil, to: settingsAlert)
        self.present(settingsAlert, animated: true, completion: nil)
    }
    
    @objc private func changeProfileButtonPressed() {
        //checkAVAuthorizationStatus()
        //imagePickerController.sourceType = .photoLibrary
        let actionSheet = UIAlertController(title: "Choose source", message: "Choose Camera or Photo", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (Action) in
            self.imagePickerController.sourceType = .camera
            self.checkAVAuthorizationStatus()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (Action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.checkAVAuthorizationStatus()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension ProfileVC {
    private func setupImagePickerController() {
        imagePickerController.delegate = self
    }
    
    private func checkAVAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            print("authorized")
            showPickerController()
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        case .notDetermined:
            print("nonDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.showPickerController()
                }
            })
        }
    }
    
    private func showPickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profileView.profileImageView.image = image
        FirebaseStorageService.service.storeImage(withImageType: .userProfileImg, imageUID: currentUserID, image: image)
        NSCacheHelper.manager.addImage(with: currentUserID, and: image)
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePostIDs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let postID = favoritePostIDs[indexPath.row]
        cell.configureCell(withPostID: postID)
//        cell.backgroundColor = UIColor(red:0.92, green:0.47, blue:0.25, alpha:1.0)
        
        return cell
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let cellWidth = (screenWidth - (cellSpacing * numSpaces)) / numCells

        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension ProfileVC: AuthUserDelegate {
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
    }
    
    func didCreateUser(_ userService: AuthUserService, user: User) {
    }
    
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        //todo
    }
    
    func didSignOut(_ userService: AuthUserService) {
        print("user signed out!!")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didFailToSignIn(_ userService: AuthUserService, error: Error) {
    }
    
    func didSignIn(_ userService: AuthUserService, user: User) {
    }
    
    func didFailToSendPasswordReset(_ userService: AuthUserService, error: Error) {
    }
    
    func didSendPasswordReset(_userService: AuthUserService) {
    }
}



