//
//  UploadVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class UploadVC: UIViewController {

    private let imagePickerController = UIImagePickerController()
    private var currentSelectedImage: UIImage!
    private var uploadView = UploadView()
    //used if user triggers AR from tattoo image in feed or if user uploads tattoo image to feed
    private var designID: String?
    
    private var tapRecognizer: UITapGestureRecognizer!
    
    init(designID: String? = nil) {
        self.designID = designID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        imagePickerController.delegate = self
        view.addSubview(uploadView)
        //uploadView.frame = view.bounds
        setupSubView()
        uploadView.imageView.addGestureRecognizer(tapRecognizer)
        uploadView.ARTestButton.addTarget(self, action: #selector(ARTestButtonPressed), for: .touchUpInside)
        uploadView.postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        uploadView.imageView.image = #imageLiteral(resourceName: "addphoto")
    }
    
    private func setupSubView() {
        view.addSubview(uploadView)
        uploadView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    @objc private func showActionSheet() {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePickerController.sourceType
                = .photoLibrary
            self.checkAVAuthorizationStatus()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func ARTestButtonPressed() {
        if let image = uploadView.imageView.image {
            let arVC = ARVC(tattooImage: image, designID: self.designID)
            let navVC = UINavigationController(rootViewController: arVC)
            navigationController?.present(navVC, animated: true)
        }
    }
    
    @objc private func postButtonPressed() {
        let currentUser = AuthUserService.manager.getCurrentUser()!
       FirebaseDesignPostService.service.delegate = self
        FirebaseDesignPostService.service.addDesignPostToDatabase(userID: currentUser.uid, image: currentSelectedImage, likes: 0, timeStamp: Date.timeIntervalSinceReferenceDate, comments: "", flags: 0)
    }
    
    private func showPickerController() {
        present(imagePickerController, animated: true, completion: nil)
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
}

//TODO add actions for post and AR Test buttons

extension UploadVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        uploadView.imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UploadVC: UINavigationControllerDelegate {
    
}

extension UploadVC: DesignPostDelegate {
    func didAddDesignPostToFirebase(_ postService: FirebaseDesignPostService, post: DesignPost, designID: String) {
        //success
        let successAlert = Alert.create(withTitle: "Success", andMessage: "Posted design to feed.", withPreferredStyle: .alert)
        Alert.addAction(withTitle: "OK", style: .default, andHandler: nil, to: successAlert)
        self.present(successAlert, animated: true, completion: nil)
        
        self.designID = designID
    }
    
    func failedToAddDesignPostToFirebase(_ postService: FirebaseDesignPostService, error: Error) {
        //error
        let errorAlert = Alert.createErrorAlert(withMessage: "Could not add tattoo design to feed.")
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func didGetAllDesignPosts(_ postService: FirebaseDesignPostService, post: DesignPost) {
    }
    
    func failedToGetAllDesignPosts(_ postService: FirebaseDesignPostService, error: Error) {
    }
}
