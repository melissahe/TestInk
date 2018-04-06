//
//  CropFilterView.swift
//  TestInk
//
//  Created by C4Q on 4/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class CropFilterView: UIView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.isOpaque = true
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    lazy var cropButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 0.6
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Crop", for: .normal)
        let font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor.Custom.mandarin
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 0.6
        button.layer.borderColor = UIColor.Custom.lapisLazuli.cgColor
        button.setTitleColor(UIColor.Custom.mandarin, for: .normal)
        button.setTitle("Cancel", for: .normal)
        let font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        button.titleLabel?.font = font
        
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let collectionViewHeight: CGFloat = UIScreen.main.bounds.height * 0.28
        let itemWidth: CGFloat = UIScreen.main.bounds.width * 0.40
        let cellSpacing: CGFloat = 10.0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: collectionViewHeight - (cellSpacing * 2.0))
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsetsMake(cellSpacing, cellSpacing, cellSpacing, cellSpacing)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupViews()
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.8)
        }
    }
    private func setupCropButton() {
        self.addSubview(cropButton)
        cropButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView.snp.centerX)
            make.top.equalTo(imageView.snp.bottom).offset(25)
            make.width.equalTo(imageView.snp.width).multipliedBy(0.4)
            make.height.equalTo(imageView.snp.height).multipliedBy(0.15)
        }
    }
    
    
    
  
    private func setupCancelButton() {
        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(cropButton.snp.bottom).offset(9)
            make.centerX.equalTo(cropButton.snp.centerX)
            make.height.equalTo(cropButton.snp.height)
            make.width.equalTo(cropButton.snp.width)
            
        }
    }
    
    private func setupViews() {
        setupImageView()
        setupCropButton()
        setupCancelButton()
        self.addSubview(collectionView)
    }

}
