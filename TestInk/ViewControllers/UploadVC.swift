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
    
    // Stock images populating collection view
    private let cellSpacing: CGFloat = UIScreen.main.bounds.width * 0.025
    private var selectedCellIndex = 0
    
    
    let stockImages = [UIImage(named:"swiftbird"),
                       UIImage(named:"tattoo1")!,
                       UIImage(named:"tattoo2")!,
                       UIImage(named:"tattoo3")!,
                       UIImage(named:"tattoo4")!,
                       UIImage(named:"tattoo5")!,
                       UIImage(named:"pheonix")!,
                       UIImage(named: "rose-tattoo")!,
                       UIImage(named: "butterfly-tattoo")!,
                       UIImage(named:"bear")!,
                       UIImage(named:"chicago")!,
                       UIImage(named:"crown")!,
                       UIImage(named:"eyeball")!,
                       UIImage(named:"feather")!,
                       UIImage(named:"flowertat")!,
                       UIImage(named:"music")!,
                      // UIImage(named:"nodetree")!,
                       UIImage(named:"owl")!,
                       UIImage(named:"car")!,
                       UIImage(named:"star")!,
                       UIImage(named:"sun")!,
                       
    ]
    
    //
    private let imagePickerController = UIImagePickerController()
    private var currentSelectedImage: UIImage!
    private var uploadView = UploadView()
    //used if user triggers AR from tattoo image in feed or if user uploads tattoo image to feed
    private var designID: String?
    private var designPost: DesignPost?
    
    private var tapRecognizer: UITapGestureRecognizer!
    
    init(image: UIImage? = nil, designID: String? = nil) {
        self.uploadView.imageView.image = (image != nil) ? image : #imageLiteral(resourceName: "addphoto")
        self.designID = designID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Upload"
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        imagePickerController.delegate = self
        FirebaseStorageService.service.delegate = self
        uploadView.stockImageCollectionView.dataSource = self
        uploadView.stockImageCollectionView.delegate = self
        //uploadView.frame = view.bounds
        setupSubView()
        uploadView.imageView.addGestureRecognizer(tapRecognizer)
        uploadView.ARTestButton.addTarget(self, action: #selector(ARTestButtonPressed), for: .touchUpInside)
        uploadView.postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //uploadView.imageView.image = #imageLiteral(resourceName: "addphoto")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
   
    
    private func setupSubView() {
        view.backgroundColor = UIColor.Custom.lapisLazuli
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
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePickerController.sourceType = .camera
            self.checkAVAuthorizationStatus()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func ARTestButtonPressed() {
        if let image = uploadView.imageView.image {
            let arVC = ARVC(tattooImage: image, designID: self.designID)
//            let navVC = UINavigationController(rootViewController: arVC)
            navigationController?.pushViewController(arVC, animated: true)
        }
    }
    
    @objc private func postButtonPressed() {
        let currentUser = AuthUserService.manager.getCurrentUser()!
        FirebaseDesignPostService.service.delegate = self
        if let image = currentSelectedImage {
            FirebaseDesignPostService.service.addDesignPostToDatabase(userID: currentUser.uid, image: image, likes: 0, timeStamp: Date.timeIntervalSinceReferenceDate, comments: "", flags: 0)
            
            if let designID = designPost?.uid {
                FirebaseStorageService.service.storeImage(withImageType: .designPost, imageUID: designID, image: image)
            }
        } else {
            let errorAlert = Alert.createErrorAlert(withMessage: "Please select an image to upload.")
            self.present(errorAlert, animated: true, completion: nil)
        }
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
        currentSelectedImage = image
        let cropFilterVC = CropFilterViewController(image: image)
        cropFilterVC.delegate = self
        let navController = UINavigationController(rootViewController: cropFilterVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overFullScreen
        dismiss(animated: false, completion: nil)
        self.present(navController, animated: false, completion: nil)
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

extension UploadVC: StorageServiceDelegate{
    func didStoreImage(_ storageService: FirebaseStorageService) {
        print("Image stored to Firebase")
    }
    
    func didFailStoreImage(_ storageService: FirebaseStorageService, error: String) {
        
    }
    
    func didRetrieveImage(_ storageService: FirebaseStorageService) {
        
    }
    
    func failedToRetrieveImage(_ storageService: FirebaseStorageService, error: String) {
        
    }
    
}
    //Collection view delegates
extension UploadVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stockImages.count
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.selectedCellIndex = indexPath.row
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StockImageCell", for: indexPath) as! StockImagesCollectionViewCell
        let currentCollection = stockImages[indexPath.row]
        cell.stockImage.image = currentCollection
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentStockImage = stockImages[indexPath.row] {
            let arVC = ARVC(tattooImage: currentStockImage, designID: nil)
            self.navigationController?.pushViewController(arVC, animated: true)
        }
    }
    
}
extension UploadVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 4.5
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.bounds.width - (numberOfSpaces * cellSpacing)) / numberOfCells
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
}
    
}

extension UploadVC: CropFilterVCDelegate {
    func didUpdateImage(image: UIImage) {
        uploadView.imageView.image = image
        currentSelectedImage = image
    }
    
    
}
