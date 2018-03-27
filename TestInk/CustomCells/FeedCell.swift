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
        return iv
    }()
    
    
    //Meseret
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Billy"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var feedImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        return iv
    }()
    
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "favorite-unfilled-32"), for: .normal)
        return button
    }()
    
    lazy var numberOfLikes: UILabel = {
        let label = UILabel()
        label.text = "23"
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "actionIcon"), for: .normal)
        return button
    }()

    
    //initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "FeedCell")
        setUpGUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpGUI() {
        backgroundColor = .yellow
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.bounds.width / 2.0
        userImage.layer.masksToBounds = true
    }

    private func setupViews() {
        setupUserImage()
//        setupUserNameLabel()
//        setupFeedImage()
//        setupFavoriteButton()
//        setupNumberOfLikes()
//        setupShareButton()
    }
    
    //constraints
    private func setupUserImage() {
        addSubview(userImage)
        userImage.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.10)
            make.width.equalTo(userImage.snp.height)
            make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
    }
//    private func setupUserNameLabel() {
//        addSubview(userNameLabel)
//        favoriteImageView.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(contentView.snp.leading)
//            make.trailing.equalTo(contentView.snp.trailing)
//            make.height.equalTo(contentView.snp.height)
//            favoriteImageView.clipsToBounds = true
//        }
//    }
//
//    private func setupFeedImage() {
//        addSubview(feedImage)
//        favoriteImageView.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(contentView.snp.leading)
//            make.trailing.equalTo(contentView.snp.trailing)
//            make.height.equalTo(contentView.snp.height)
//            favoriteImageView.clipsToBounds = true
//        }
//    }
//
//    private func setupFavoriteButton() {
//        addSubview(favoriteButton)
//        favoriteImageView.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(contentView.snp.leading)
//            make.trailing.equalTo(contentView.snp.trailing)
//            make.height.equalTo(contentView.snp.height)
//            favoriteImageView.clipsToBounds = true
//        }
//    }
//
//    private func setupNumberOfLikes() {
//        addSubview(numberOfLikes)
//        favoriteImageView.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(contentView.snp.leading)
//            make.trailing.equalTo(contentView.snp.trailing)
//            make.height.equalTo(contentView.snp.height)
//            favoriteImageView.clipsToBounds = true
//        }
//    }
//
//    private func setupShareButton() {
//        addSubview(shareButton)
//        favoriteImageView.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(contentView.snp.leading)
//            make.trailing.equalTo(contentView.snp.trailing)
//            make.height.equalTo(contentView.snp.height)
//            favoriteImageView.clipsToBounds = true
//        }
//    }
}
