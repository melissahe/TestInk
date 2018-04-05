//
//  FeedCell.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

protocol FeedCellDelegate: class {
    func didTapFlag(onPost post: DesignPost, cell: FeedCell)
    func didTapShare(image: UIImage, forPost post: DesignPost)
    func didTapLike(onPost post: DesignPost, cell: FeedCell)
}

class FeedCell: UITableViewCell {
    public var delegate: FeedCellDelegate?
    private var designPost: DesignPost?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    //lazy vars
    lazy var userImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = #imageLiteral(resourceName: "placeholder") //placeholder
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //Meseret
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
//        label.text = "Billy"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        label.textColor = Stylesheet.Colors.Lapislazuli
        return label
    }()
    
    lazy var feedImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.white
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "placeholder") //placeholder
        return iv
    }()
    
    lazy var flagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "flagUnfilled"), for: .normal)
        button.tintColor = Stylesheet.Colors.Lapislazuli
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        button.addTarget(self, action: #selector(flagButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "heartUnfilled"), for: .normal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var numberOfLikes: UILabel = {
        let label = UILabel()
        label.text = "23" // to do
        label.textColor = .black
        label.textColor = Stylesheet.Colors.Lapislazuli
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
         button.tintColor = Stylesheet.Colors.Lapislazuli
         button.setImage(#imageLiteral(resourceName: "actionIcon"), for: .normal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var canvasView: UIView = {
        let view = UIView()
        view.backgroundColor = Stylesheet.Colors.LightBlue
        return view
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
        backgroundColor = .white //UIColor(red:0.95, green:0.98, blue:0.96, alpha:1.0)
        addSubviews()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.bounds.width / 2.0
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.Custom.lapisLazuli.cgColor
        canvasView.setNeedsLayout()
    }
    
    public func configureCell(withPost post: DesignPost) {
        self.designPost = post
//        numberOfLikes.text = post.likes.description
        configureFeedImage(withPost: post)
        configureUserNameAndImage(withPost: post)
        configureFlag(withPost: post)
        configureLike(withPost: post)
    }
    
    private func configureFeedImage(withPost post: DesignPost) {
        self.feedImage.image = nil
        self.feedImage.image = #imageLiteral(resourceName: "placeholder")
        guard let imageURLString = post.image else {
            self.activityIndicator.isHidden = true
            print("could not get image URL")
            return
        }
        //get image from cache, if non existent then run this
        if let image = NSCacheHelper.manager.getImage(with: post.uid) {
            feedImage.image = image
            self.activityIndicator.isHidden = true
            self.setNeedsLayout()
            self.layoutIfNeeded()
        } else {
            ImageHelper.manager.getImage(from: imageURLString, completionHandler: { (image) in
                //cache image for post id
                NSCacheHelper.manager.addImage(with: post.uid, and: image)
                self.feedImage.image = image
                self.activityIndicator.isHidden = true
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }, errorHandler: { (error) in
                self.activityIndicator.isHidden = true
                print("Error: Could not get image:\n\(error)")
            })
        }
    }
    
    private func configureUserNameAndImage(withPost post: DesignPost) {
        self.userNameLabel.text = nil
        UserProfileService.manager.getName(from: post.userID) { (username) in
            self.userNameLabel.text = username
        }
        self.userImage.image = nil
        if let cachedUserImage = NSCacheHelper.manager.getImage(with: post.userID) {
            self.userImage.image = cachedUserImage
            self.userImage.layoutIfNeeded()
        } else {
            UserProfileService.manager.getUser(fromUserUID: post.userID) { (userProfile) in
                guard let imageURL = userProfile.image else {
                    self.userImage.image = #imageLiteral(resourceName: "placeholder")
                    self.layoutIfNeeded()
                    return
                }
                ImageHelper.manager.getImage(from: imageURL, completionHandler: { (profileImage) in
                    self.userImage.image = profileImage
                    self.layoutIfNeeded()
                    NSCacheHelper.manager.addImage(with: post.userID, and: profileImage)
                }, errorHandler: { (error) in
                    print("Couldn't get profile Image \(error)")
                    self.userImage.image = #imageLiteral(resourceName: "placeholder")
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    private func configureFlag(withPost post: DesignPost) {
        FirebaseFlaggingService.service.checkIfPostIsFlagged(post: post, byUserID: AuthUserService.manager.getCurrentUser()!.uid) { (postHasBeenFlaggedByUser) in
            if postHasBeenFlaggedByUser {
//                for subview in self.subviews {
//                    subview.snp.removeConstraints()
//                    subview.snp.makeConstraints({ (make) in
//                        make.height.equalTo(0)
//                    })
//                    subview.isHidden = true
//                }
//                self.isHidden = true
//                self.contentView.snp.makeConstraints({ (make) in
//                    make.top.equalTo(self.contentView.snp.bottom)
//                })
//                self.setNeedsLayout()
//                self.layoutIfNeeded()
                self.flagButton.setImage(#imageLiteral(resourceName: "flagFilled"), for: .normal)
            } else {
                self.flagButton.setImage(#imageLiteral(resourceName: "flagUnfilled"), for: .normal)
            }
        }
    }
    
    public func configureLike(withPost post: DesignPost) {
        FirebaseLikingService.service.getAllLikes(forUserID: AuthUserService.manager.getCurrentUser()!.uid) { (userLikesArray) in
            //this isn't updated in time keeps updating too late
            if userLikesArray.contains(post.uid) {
                self.likeButton.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
            } else {
                self.likeButton.setImage(#imageLiteral(resourceName: "heartUnfilled"), for: .normal)
            }
        }
        FirebaseLikingService.service.getAllLikes(forPostID: post.uid) { (likesArray) in
            self.numberOfLikes.text = likesArray.count.description
        }
    }
    private func addSubviews(){
        contentView.addSubview(userImage)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(flagButton)
        contentView.addSubview(feedImage)
        contentView.addSubview(canvasView)
        addSubview(likeButton)
        contentView.addSubview(numberOfLikes)
        addSubview(shareButton)
        contentView.addSubview(activityIndicator)
    }
    private func setupViews() {
        setupCanvasView()
        setupUserImage()
        setupUserNameLabel()
        setupFlagButton()
        setupCanvasView()
        setupFeedImage()
        setupLikeButton()
        setupNumberOfLikes()
        setupShareButton()
        setupActivityIndicator()
    }
    
    //constraints
    private func setupUserImage() {
        userImage.snp.makeConstraints { (make) -> Void in
            make.leading.top.equalTo(contentView).offset(8)
            make.height.equalTo(40)
            make.width.equalTo(userImage.snp.height)
//            make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
    }

    private func setupUserNameLabel() {
        userNameLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(userImage.snp.trailing).offset(8)
//            make.trailing.equalTo(contentView).inset(8)
            make.centerY.equalTo(userImage)
//            make.height.equalTo(contentView.snp.height)
//            favoriteImageView.clipsToBounds = true
        }
    }
    
    private func setupFlagButton() {
        flagButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(userImage)
            make.leading.equalTo(userNameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }

    private func setupFeedImage() {
        feedImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userImage.snp.bottom).offset(8).priority(999)
            make.bottom.equalTo(contentView.snp.bottom).priority(999)
            make.leading.trailing.equalTo(contentView)
            //to do - fix later
            make.height.lessThanOrEqualTo(feedImage.snp.width).priority(999)
        }
        feedImage.clipsToBounds = true
    }
    
    private func setupCanvasView() {
        
        canvasView.snp.makeConstraints { (make) in
           make.top.equalTo(feedImage.snp.bottom)
            //make.height.equalTo(self.snp.height).multipliedBy(0.33)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
        }
    }

    private func setupLikeButton() {
        
        likeButton.snp.makeConstraints { (make) -> Void in
           // make.top.equalTo(feedImage.snp.bottom).offset(8)
            make.top.equalTo(feedImage.snp.bottom).offset(8)
            make.height.equalTo(userImage)
            make.leading.bottom.equalTo(contentView).inset(8)
        }
    }

    private func setupNumberOfLikes() {
        
        numberOfLikes.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(likeButton.snp.trailing).offset(8)
            make.centerY.equalTo(likeButton)
//            make.trailing.equalTo(contentView.snp.trailing)
//            make.height.equalTo(contentView.snp.height)
        }
    }

    private func setupShareButton() {
        shareButton.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(numberOfLikes.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(feedImage.snp.bottom).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
            make.height.equalTo(likeButton)
        }
    }
    
    private func setupActivityIndicator() {
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(feedImage)
        }
    }
    
    @objc private func flagButtonTapped() {
        if let designPost = designPost {
            delegate?.didTapFlag(onPost: designPost, cell: self)
        }
    }
    
    @objc private func shareButtonTapped() {
        if let designPost = designPost, let image = feedImage.image {
            delegate?.didTapShare(image: image, forPost: designPost)
        }
    }
    
    @objc private func likeButtonTapped() {
        if let designPost = designPost {
            delegate?.didTapLike(onPost: designPost, cell: self)
        }
    }
}
