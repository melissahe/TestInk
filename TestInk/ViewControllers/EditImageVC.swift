//
//  EditImageVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class EditImageVC: UIViewController {
    
    private lazy var cellSpacing = self.view.frame.width * 0.05
    private var pastSliderValue: Float = 0
    private var pastImage: UIImage!
    private var originalImage: UIImage!
    private var designID: String?
    private var feedView = FeedView()
    private var filters: [(displayName: String, filterName: Filter)] = FilterModel.getFilters()
    
    lazy private var editImageView = EditImageView(frame: view.safeAreaLayoutGuide.layoutFrame)
    
    init(image: UIImage, designID: String?) {
        self.designID = designID
        self.pastImage = image
        self.originalImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpNavigation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.editImageView.filterView.filterCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setUpViews() {
        view.backgroundColor = UIColor.Custom.lapisLazuli
        view.addSubview(editImageView)
        editImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        editImageView.photoImageView.image = pastImage
        
        //        editImageView.photoOptionsView.resizeButton.addTarget(self, action: #selector(resizeButtonPressed), for: .touchUpInside)
        
        editImageView.photoOptionsView.shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        
        editImageView.photoOptionsView.filtersButton.addTarget(self, action: #selector(filtersButtonPressed), for: .touchUpInside)
        
        editImageView.filterView.filterCollectionView.delegate = self
        editImageView.filterView.filterCollectionView.dataSource = self
    }
    
    private func setUpNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post Tattoo", style: .done, target: self, action: #selector(postButtonPressed))
    }
    
    private func addEditView() {
        navigationItem.rightBarButtonItem = nil
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "deleteIcon"), style: .done, target: self, action: #selector(deleteButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkIcon"), style: .done, target: self, action: #selector(saveButtonPressed))
    }
    
    private func removeEditView() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        setUpNavigation()
        //        editImageView.editView.isHidden = true
        editImageView.filterView.isHidden = true
    }
    
    @objc private func postButtonPressed() {
        //should post to feed?
        let currentUser = AuthUserService.manager.getCurrentUser()!
        //DesignID won't work if the user doesn't upload the design they're trying - maybe we should scrap this
        FirebasePreviewPostService.service.delegate = self  
        if let userSavedImage = editImageView.photoImageView.image {
            FirebasePreviewPostService.service.addPreviewPostToDatabase(userID: currentUser.uid, image: userSavedImage, likes: 0, timeStamp: Date.timeIntervalSinceReferenceDate, comments: "", designID: self.designID, flags: 0)
        }
    }
    
    //    @objc private func resizeButtonPressed() {
    //        editImageView.editView.isHidden = false
    //
    //        pastSliderValue = editImageView.editView.sizeSlider.value
    //        addEditView()
    //    }
    
    @objc private func deleteButtonPressed() {
        //do something to track which one you're no longer using
        //reset slider
        //        editImageView.editView.sliderValueLabel.text = pastSliderValue.truncatingRemainder(dividingBy: 10).description
        //        editImageView.editView.sizeSlider.value = pastSliderValue
        editImageView.photoImageView.image = pastImage
        removeEditView()
    }
    
    @objc private func saveButtonPressed() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        removeEditView()
    }
    
    @objc private func shareButtonPressed() {
        let text = "Check out this tattoo preview!!"
        if let imageToBeShared: UIImage = editImageView.photoImageView.image {
            let activityVC = UIActivityViewController(activityItems: [text, imageToBeShared], applicationActivities: [])
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc private func filtersButtonPressed() {
        editImageView.filterView.isHidden = false
        pastImage = editImageView.photoImageView.image
        addEditView()
    }
}

extension EditImageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 3
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.frame.width - (numberOfSpaces * cellSpacing)) / numberOfCells
        let height = collectionView.frame.height - (2 * cellSpacing)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
}

extension EditImageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //to do - should change filter
        print("selected filter: \(filters[indexPath.row].displayName)!!!")
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCell {
            editImageView.photoImageView.image = cell.filterImageView.image
        }
    }
}

extension EditImageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
        let currentFilter = filters[indexPath.row]
        cell.configureCell(withImage: originalImage, andFilter: currentFilter)
        return cell
    }
}

extension EditImageVC: PreviewPostDelegate {
    func didAddPreviewPostToFirebase(_ postService: FirebasePreviewPostService, post: PreviewPost) {
        //success
        let successAlert = Alert.create(withTitle: "Success", andMessage: "Tattoo posted to feed.", withPreferredStyle: .alert)
        Alert.addAction(withTitle: "OK", style: .default, andHandler: nil, to: successAlert)
        self.present(successAlert, animated: true, completion: nil)
    }
    
    func failedToAddPreviewPostToFirebase(_ postService: FirebasePreviewPostService, error: Error) {
        //error
        let errorAlert = Alert.createErrorAlert(withMessage: "Could not add tattoo preview to feed.")
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func didGetAllPreviewPosts(_ postService: FirebasePreviewPostService, post: PreviewPost) {
    }
    
    func failedToGetAllPreviewPosts(_ postService: FirebasePreviewPostService, error: Error) {
    }
}
