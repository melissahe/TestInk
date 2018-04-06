//
//  ProfileView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    var spacing = 5 //Use this for even spacing
    
    lazy var profileBarView: UIView = {
        let view = UIView()
        view.backgroundColor = Stylesheet.Colors.LightBlue
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: -0.2, height: -0.2)
        view.layer.shadowRadius = 5
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        var pImageView = UIImageView()
        pImageView.image = #imageLiteral(resourceName: "placeholder") //place holder image
        //pImageView.isUserInteractionEnabled = true
        pImageView.contentMode = .scaleAspectFill
        pImageView.backgroundColor = .white
        return pImageView
    }()
    
    lazy var changeProfileImageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "addIcon"), for: .normal)
        //btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var displayName: UILabel = {
        let dn = UILabel()
        dn.text = "" //should be changed in table view
        dn.textAlignment = .center
        dn.textColor = UIColor.Custom.lapisLazuli
        dn.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        dn.adjustsFontSizeToFitWidth = true
        dn.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return dn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white //UIColor(red:0.95, green:0.98, blue:0.96, alpha:1.0)
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        cv.setContentCompressionResistancePriority(UILayoutPriority(249), for: .vertical)
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
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = Stylesheet.Colors.Lapislazuli.cgColor
        changeProfileImageButton.layer.cornerRadius = changeProfileImageButton.bounds.height/2
        changeProfileImageButton.layer.masksToBounds = true
        changeProfileImageButton.layer.borderWidth = 2
        changeProfileImageButton.layer.borderColor = Stylesheet.Colors.LightBlue.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
       self.backgroundColor = Stylesheet.Colors.LightBlue
        setUpViews()
    }
    
    private func setUpViews() {
        setupCollectionView()
        setUpProfileBarView()
        setUpProfileImageView()
        setupChangeProfileButton()
        setupNameLabel()
        
    }
    
    private func setUpProfileBarView() {
        addSubview(profileBarView)
        
        profileBarView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(collectionView.snp.top)
        }

    }
    
    private func setUpProfileImageView() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
//            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(150)
            make.centerX.equalTo(self)
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.25)
            make.width.equalTo(profileImageView.snp.height)
        }
    }
    
    private func setupChangeProfileButton() {
        addSubview(changeProfileImageButton)
        changeProfileImageButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.06)
            make.width.equalTo(changeProfileImageButton.snp.height)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.right.equalTo(profileImageView.snp.right)
        }
    }
    
    private func setupNameLabel() {
        addSubview(displayName)
        displayName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.centerX.equalTo(self)
            make.bottom.equalTo(collectionView.snp.top).offset(-10)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(spacing)
            make.trailing.equalTo(self.snp.trailing).offset(-spacing)
        }
    }
    
        private func setupCollectionView() {
            self.addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
//                make.top.equalTo(displayName.snp.bottom).offset(spacing)
                make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8).priority(999)
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
                make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            }

        }
   

}
