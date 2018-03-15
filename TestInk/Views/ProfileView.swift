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
        pImageView.isUserInteractionEnabled = true
        pImageView.backgroundColor = UIColor.red
        return pImageView
    }()
    
    lazy var changeProfileImageButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Change Image", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var displayName: UILabel = {
        let dn = UILabel()
        dn.text = "Name Label"
        return dn
    }()
    
    lazy var logoutButton: UIButton = {
        let cdn = UIButton()
        cdn.setTitle(" Logout ", for: .normal)
        cdn.backgroundColor = UIColor.blue
        return cdn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // we get the frame of the UI elements here
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .white
        setUpViews()
    }
    
    private func setUpViews() {
        addSubview(logoutButton)
        setupNameLabel()
        setUpProfileImageView()
        //setupCollectionView()
        setUpChangeProfileButton()
    }
    
    private func setUpProfileImageView() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(displayName.snp.bottom).offset(spacing)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(130)
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.25)
            make.width.equalTo(profileImageView.snp.height)
        }
    }
    
    private func setUpChangeProfileButton() {
        addSubview(changeProfileImageButton)
        changeProfileImageButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(profileImageView.snp.bottom).offset(spacing)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(150)
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.01)
        }
    }
    
    private func setupNameLabel() {
        addSubview(displayName)
        displayName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(spacing)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(150)
            // make.bottom.equalTo(collectionView.snp.top).offset(spacing)
            make.trailing.equalTo(self.snp.trailing).offset(-spacing)
        }
    }
    
    //    private func setupChangeImageButton() {
    //        addSubview(changeProfileImageButton)
    //        changeProfileImageButton.snp.makeConstraints { (make) -> Void in
    //            make.top.equalTo(changeDisplayName.snp.bottom)
    //            make.leading.equalTo(displayName.snp.leading)
    //        }
    //    }
    
    //    private func setupCollectionView() {
    //        self.addSubview(collectionView)
    //        collectionView.snp.makeConstraints { (make) in
    //            make.top.equalTo(displayName.snp.bottom).offset(10)
    //            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-spacing)
    //            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(spacing)
    //            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-spacing)
    //
    //        }
    //    }
   

}
