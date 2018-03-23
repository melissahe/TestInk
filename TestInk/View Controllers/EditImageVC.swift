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
    
    private var filters: [(displayName: String, filterName: Filter)] = FilterModel.getFilters()
    
    lazy private var editImageView = EditImageView(frame: view.safeAreaLayoutGuide.layoutFrame)
    
    init(image: UIImage) {
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

    private func setUpViews() {
        view.addSubview(editImageView)
        editImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        editImageView.photoImageView.image = pastImage
        
        editImageView.photoOptionsView.resizeButton.addTarget(self, action: #selector(resizeButtonPressed), for: .touchUpInside)
        
        editImageView.photoOptionsView.shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        
        editImageView.photoOptionsView.filtersButton.addTarget(self, action: #selector(filtersButtonPressed), for: .touchUpInside)
        
        editImageView.filterView.filterCollectionView.delegate = self
        editImageView.filterView.filterCollectionView.dataSource = self
    }
    
    private func setUpNavigation() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(postButtonPressed))
    }
    
    private func addEditView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "deleteIcon"), style: .done, target: self, action: #selector(deleteButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkIcon"), style: .done, target: self, action: #selector(saveButtonPressed))
    }
    
    private func removeEditView() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        editImageView.editView.isHidden = true
        editImageView.filterView.isHidden = true
    }
    
    @objc private func postButtonPressed() {
        //should post to feed?
    }
    
    @objc private func resizeButtonPressed() {
        editImageView.editView.isHidden = false
        
        pastSliderValue = editImageView.editView.sizeSlider.value
        addEditView()
    }
    
    @objc private func deleteButtonPressed() {
        //do something to track which one you're no longer using
        //reset slider
        editImageView.editView.sliderValueLabel.text = pastSliderValue.truncatingRemainder(dividingBy: 10).description
        editImageView.editView.sizeSlider.value = pastSliderValue
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
        let numberOfCells: CGFloat = 5
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
