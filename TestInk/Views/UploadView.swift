//
//  UploadView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class UploadView: UIView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = Stylesheet.Colors.LightBlue
        iv.isUserInteractionEnabled = true
        let image = UIImage(named: "addphoto")?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        iv.tintColor = Stylesheet.Colors.DarkSlateGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var ARTestButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 0.6
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("AR Test", for: .normal)
        let font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor.Custom.mandarin
        return button
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 0.6
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Post Design", for: .normal)
        let font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor.Custom.lapisLazuli
        return button
    }()
    
    //Collection view to populate stored tattoo images
    lazy var stockImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(StockImagesCollectionViewCell.self, forCellWithReuseIdentifier: "StockImageCell")
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
        backgroundColor = UIColor.white//UIColor(red:0.95, green:0.98, blue:0.96, alpha:1.0)
        setupViews()
    }
    
    private func setupViews() {
        setupImageView()
        setupARTestButton()
        setupPostButton()
        setupStockImageCollectionView()
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.8)
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.Custom.lapisLazuli.cgColor
        imageView.layer.borderWidth = 0.5
    }
    
    private func setupARTestButton() {
        self.addSubview(ARTestButton)
        ARTestButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView.snp.centerX)
            make.top.equalTo(imageView.snp.bottom).offset(25)
            make.width.equalTo(imageView.snp.width).multipliedBy(0.4)
            make.height.equalTo(imageView.snp.height).multipliedBy(0.15)
        }
    }
    
    private func setupPostButton() {
        self.addSubview(postButton)
        postButton.snp.makeConstraints { (make) in
            make.top.equalTo(ARTestButton.snp.bottom).offset(9)
            make.centerX.equalTo(ARTestButton.snp.centerX)
            make.height.equalTo(ARTestButton.snp.height)
            make.width.equalTo(ARTestButton.snp.width)
        }
    }
    
    private func setupStockImageCollectionView(){
        addSubview(stockImageCollectionView)
        stockImageCollectionView.snp.makeConstraints { (collection) in
            collection.bottom.equalTo(self)
            collection.trailing.leading.centerX.equalTo(self)
            collection.top.equalTo(postButton.snp.bottom).offset(25)
        }
        stockImageCollectionView.layer.cornerRadius = 15
        stockImageCollectionView.layer.masksToBounds = true
    }
    
    
}
