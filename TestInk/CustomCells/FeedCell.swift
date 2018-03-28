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
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }()
    
    lazy var feedImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var flagButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "flagUnfilled"), for: .normal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "heartUnfilled"), for: .normal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return button
    }()
    
    lazy var numberOfLikes: UILabel = {
        let label = UILabel()
        label.text = "23" // to do
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "actionIcon"), for: .normal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
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
        backgroundColor = .white
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.bounds.width / 2.0
        userImage.layer.masksToBounds = true
    }

    private func setupViews() {
        setupUserImage()
        setupUserNameLabel()
        setupFlagButton()
        setupFeedImage()
        setupFavoriteButton()
        setupNumberOfLikes()
        setupShareButton()
    }
    
    //constraints
    private func setupUserImage() {
        contentView.addSubview(userImage)
        userImage.snp.makeConstraints { (make) -> Void in
            make.leading.top.equalTo(contentView).offset(8)
            make.height.equalTo(40)
            make.width.equalTo(userImage.snp.height)
//            make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
    }

    private func setupUserNameLabel() {
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(userImage.snp.trailing).offset(8)
//            make.trailing.equalTo(contentView).inset(8)
            make.centerY.equalTo(userImage)
//            make.height.equalTo(contentView.snp.height)
//            favoriteImageView.clipsToBounds = true
        }
    }
    
    private func setupFlagButton() {
        contentView.addSubview(flagButton)
        
        flagButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(userImage)
            make.leading.equalTo(userNameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }

    private func setupFeedImage() {
        contentView.addSubview(feedImage)
        feedImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userImage.snp.bottom).offset(8).priority(999)
            make.bottom.equalTo(contentView.snp.bottom).priority(999)
            make.leading.trailing.equalTo(contentView)
            make.height.lessThanOrEqualTo(feedImage.snp.width).priority(999)
        }
        feedImage.clipsToBounds = true
    }

    private func setupFavoriteButton() {
        addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(feedImage.snp.bottom).offset(8)
            make.height.equalTo(userImage)
            make.leading.bottom.equalTo(contentView).inset(8)
        }
    }

    private func setupNumberOfLikes() {
        contentView.addSubview(numberOfLikes)
        numberOfLikes.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(favoriteButton.snp.trailing).offset(8)
            make.centerY.equalTo(favoriteButton)
//            make.trailing.equalTo(contentView.snp.trailing)
//            make.height.equalTo(contentView.snp.height)
        }
    }

    private func setupShareButton() {
        addSubview(shareButton)
        shareButton.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(numberOfLikes.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(feedImage.snp.bottom).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
            make.height.equalTo(favoriteButton)
        }
    }
}
