//
//  FeedCell.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    //lazy vars
    lazy var userImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .purple
    }()
    
    
    //Meseret
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Billy"
        label.font = UIFont.boldSystemFont(ofSize: 17)
    }()
    
    lazy var feedImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
    }()
    
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "dismissButtonIcon"), for: .normal)
    }()
    
    lazy var numberOfLikes: UILabel = {
        let label = UILabel()
        label.text = "23"
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "dismissButtonIcon"), for: .normal)
    }()
    
    
    
    //initialization
    override init(frame: CGRect) {//overriding the parent class's functions
        super.init(frame: UIScreen.main.bounds)
        setUpGUI()
    }
    
    required init?(coder aDecoder: NSCoder) { //now the new initializer required for this uiView
        super.init(coder: aDecoder)
        //setUpGUI()
    }
    
    private func setUpGUI() {
        backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        setupUserImage()
        setupUserNameLabel()
        setupFeedImage()
        setupFavoriteButton()
        setupNumberOfLikes()
        setupShareButton()
    }
    
    //constraints
    private func setupUserImage() {
        addSubview(userImage)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.height)
            favoriteImageView.clipsToBounds = true
        }
    }
    private func setupUserNameLabel() {
        addSubview(userNameLabel)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.height)
            favoriteImageView.clipsToBounds = true
        }
    }

    private func setupFeedImage() {
        addSubview(feedImage)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.height)
            favoriteImageView.clipsToBounds = true
        }
    }
    
    private func setupFavoriteButton() {
        addSubview(favoriteButton)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.height)
            favoriteImageView.clipsToBounds = true
        }
    }

    private func setupNumberOfLikes() {
        addSubview(numberOfLikes)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.height)
            favoriteImageView.clipsToBounds = true
        }
    }

    private func setupShareButton() {
        addSubview(shareButton)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.height)
            favoriteImageView.clipsToBounds = true
        }
    }
}
