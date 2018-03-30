//
//  ProfileView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    var spacing = 16 //Use this for even spacing
    
    lazy var profileImageView: UIImageView = {
        var pImageView = UIImageView()
        pImageView.image = #imageLiteral(resourceName: "placeholder-image") //place holder image
        //pImageView.isUserInteractionEnabled = true
        pImageView.contentMode = .scaleAspectFill
        pImageView.backgroundColor = .clear
        return pImageView
    }()
    
    lazy var changeProfileImageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "addIcon"), for: .normal)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor(red:0.14, green:0.48, blue:0.63, alpha:1.0).cgColor
        //btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var displayName: UILabel = {
        let dn = UILabel()
        dn.text = "Name Label" //should be changed in table view
        dn.textAlignment = .center
        return dn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red:0.95, green:0.98, blue:0.96, alpha:1.0)
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // we get the frame of the UI elements here
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 0.5
        profileImageView.layer.borderColor = UIColor.Custom.lapisLazuli.cgColor
        changeProfileImageButton.layer.cornerRadius = changeProfileImageButton.bounds.height/2
        changeProfileImageButton.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
       self.backgroundColor = UIColor(red:0.14, green:0.48, blue:0.63, alpha:1.0)
        setUpViews()
    }
    
    private func setUpViews() {
        setupNameLabel()
        setUpProfileImageView()
        
        setupChangeProfileButton()
        setupCollectionView()
    }
    
    private func setUpProfileImageView() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(displayName.snp.bottom).offset(spacing)
//            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(150)
            make.centerX.equalTo(self)
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.25)
            make.width.equalTo(profileImageView.snp.height)
        }
    }
    
    private func setupChangeProfileButton() {
        addSubview(changeProfileImageButton)
        changeProfileImageButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
            make.width.equalTo(changeProfileImageButton.snp.height)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.right.equalTo(profileImageView.snp.right)
        }
    }
    
    private func setupNameLabel() {
        addSubview(displayName)
        displayName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(spacing)
            make.centerX.equalTo(self)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(spacing)
            // make.bottom.equalTo(collectionView.snp.top).offset(spacing)
            make.trailing.equalTo(self.snp.trailing).offset(-spacing)
        }
    }
    
        private func setupCollectionView() {
            self.addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(profileImageView.snp.bottom).offset(spacing)
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
                make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            }
        }
   

}
