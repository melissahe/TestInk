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
    var uploadView = UploadView()
    
    
    var tapRecognizer: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        imagePickerController.delegate = self
        view.addSubview(uploadView)
        //uploadView.frame = view.bounds
        setupSubView()
        uploadView.imageView.addGestureRecognizer(tapRecognizer)
        uploadView.ARTestButton.addTarget(self, action: #selector(ARTestButtonPressed), for: .touchUpInside)
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
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePickerController.sourceType
                = .photoLibrary
            self.checkAVAuthorizationStatus()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func ARTestButtonPressed() {
        let aRVC = ARVC()
        navigationController?.present(aRVC, animated: true)
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
