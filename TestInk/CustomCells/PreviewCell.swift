//
//  PreviewCell.swift
//  TestInk
//
//  Created by C4Q on 3/27/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

protocol PreviewCellDelegate: class {
    func didTapFlag(onPost post: PreviewPost, cell: PreviewCell)
    func didTapShare(image: UIImage, forPost post: PreviewPost)
}

class PreviewCell: UITableViewCell {
    
    public weak var delegate: PreviewCellDelegate?
    private var previewPost: PreviewPost?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "placeholder")
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }()
    
    lazy var flagButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "flagUnfilled"), for: .normal)
//        button.tintColor = UIColor.Custom.taupeGrey
        button.addTarget(self, action: #selector(flagButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "placeholder")
        imageView.setContentHuggingPriority(UILayoutPriority(255), for: .vertical)
//        imageView.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return imageView
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "actionIcon"), for: .normal)
        button.tintColor = UIColor.Custom.taupeGrey
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var arBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    lazy var arLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.text = "AR Ready"
        //should be transparent!!
        label.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return label
    }()
    
    @objc private func flagButtonTapped() {
        if let post = previewPost {
            delegate?.didTapFlag(onPost: post, cell: self)
        }
    }
    
    @objc private func shareButtonTapped() {
        if let image = previewImageView.image, let post = previewPost {
            delegate?.didTapShare(image: image, forPost: post)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderWidth = 0.5
        userImageView.layer.borderColor = UIColor.Custom.lapisLazuli.cgColor
    }
    
    private func commonInit() {
        backgroundColor = .white
        arLabel.isHidden = true
        arBlurView.isHidden = true
        setUpViews()
    }
    
    public func configureCell(withPost post: PreviewPost) {
        //to do
        self.previewPost = post
        
        if post.designID != nil {
            arLabel.isHidden = false
            arBlurView.isHidden = false
        }
        
        configurePreviewImage(withPost: post)
        configureUserNameAndImage(withPost: post)
        configureFlag(withPost: post)
    }
    
    private func configurePreviewImage(withPost post: PreviewPost) {
        self.previewImageView.image = nil
        self.previewImageView.image = #imageLiteral(resourceName: "placeholder")
        guard let imageURLString = post.image else {
            self.activityIndicator.isHidden = true
            print("could not get image URL")
            return
        }
        //get image from cache, if non existent then run this
        if let image = NSCacheHelper.manager.getImage(with: post.uid) {
            previewImageView.image = image
            self.activityIndicator.isHidden = true
//            self.setNeedsLayout()
            self.layoutIfNeeded()
        } else {
            ImageHelper.manager.getImage(from: imageURLString, completionHandler: { (image) in
                //cache image for post id
                NSCacheHelper.manager.addImage(with: post.uid, and: image)
                self.previewImageView.image = image
                self.activityIndicator.isHidden = true
//                self.setNeedsLayout()
                self.layoutIfNeeded()
            }, errorHandler: { (error) in
                self.activityIndicator.isHidden = true
                print("Error: Could not get image:\n\(error)")
            })
        }
    }
    
    private func configureUserNameAndImage(withPost post: PreviewPost) {
        self.usernameLabel.text = nil
        UserProfileService.manager.getName(from: post.userID) { (username) in
            self.usernameLabel.text = username
        }
        self.userImageView.image = nil
        if let cachedUserImage = NSCacheHelper.manager.getImage(with: post.userID) {
            self.userImageView.image = cachedUserImage
            self.layoutIfNeeded()
        } else {
            UserProfileService.manager.getUser(fromUserUID: post.userID) { (userProfile) in
                guard let imageURL = userProfile.image else {
                    self.userImageView.image = #imageLiteral(resourceName: "placeholder")
                    self.layoutIfNeeded()
                    return
                }
                ImageHelper.manager.getImage(from: imageURL, completionHandler: { (profileImage) in
                    self.userImageView.image = profileImage
                    self.layoutIfNeeded()
                    NSCacheHelper.manager.addImage(with: post.userID, and: profileImage)
                }, errorHandler: { (error) in
                    print("Couldn't get profile Image \(error)")
                    self.userImageView.image = #imageLiteral(resourceName: "placeholder")
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    private func configureFlag(withPost post: PreviewPost) {
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
    
    private func setUpViews() {
        setupUserImageView()
        setupUsernameLabel()
        setupFlagButton()
        setupPreviewImageView()
        setupShareButton()
        setupARBlurView()
        setupARLabel()
        setupActivityIndicator()
    }
    
    private func setupUserImageView() {
        contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) -> Void in
            make.leading.top.equalTo(contentView).offset(8)
            make.height.equalTo(40)
            make.width.equalTo(userImageView.snp.height)
        }
    }
    
    private func setupUsernameLabel() {
        contentView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.centerY.equalTo(userImageView)
        }
    }
    
    private func setupFlagButton() {
        contentView.addSubview(flagButton)
        flagButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(userImageView)
            make.leading.equalTo(usernameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    private func setupPreviewImageView() {
        contentView.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(8).priority(999)
//            make.bottom.equalTo(contentView.snp.bottom).priority(999)
            make.leading.trailing.equalTo(contentView)
            //to do - fix later
            make.height.lessThanOrEqualTo(previewImageView.snp.width).priority(999)
        }
        previewImageView.clipsToBounds = true
    }
    
    private func setupShareButton() {
        contentView.addSubview(shareButton)
        
        shareButton.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(previewImageView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
            make.height.equalTo(userImageView)
        }
    }
    
    private func setupARBlurView() {
        contentView.addSubview(arBlurView)
        
        arBlurView.snp.makeConstraints { (make) in
            make.trailing.bottom.equalTo(previewImageView).offset(-8)
            make.height.equalTo(contentView).multipliedBy(0.10)
            make.width.equalTo(contentView).multipliedBy(0.25)
        }
        
        arBlurView.layer.masksToBounds = true
        arBlurView.layer.cornerRadius = 10
    }
    
    private func setupARLabel() {
        contentView.addSubview(arLabel)
        
        arLabel.snp.makeConstraints { (make) in
            make.center.equalTo(arBlurView)
        }
    }
    
    private func setupActivityIndicator() {
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(previewImageView)
        }
    }
}
