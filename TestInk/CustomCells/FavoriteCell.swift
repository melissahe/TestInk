//
//  FavoriteCell.swift
//  TestInk
//
//  Created by C4Q on 3/15/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    var spacing = 16 //Use this for even spacing
    
    lazy var favoriteImageView: UIImageView = {
        var pImageView = UIImageView()
        pImageView.image = #imageLiteral(resourceName: "placeholder") //place holder image
        //pImageView.isUserInteractionEnabled = true
        pImageView.contentMode = .scaleAspectFill
        pImageView.backgroundColor = .clear
        return pImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func configureCell(withPostID postID: String) {
        favoriteImageView.image = nil
        favoriteImageView.image = #imageLiteral(resourceName: "placeholder")
        if let cachedImage = NSCacheHelper.manager.getImage(with: postID) {
            favoriteImageView.image = cachedImage
            self.layoutIfNeeded()
        } else {
            FirebaseDesignPostService.service.getPost(withPostID: postID) { (post, error) in
                if let post = post {
                    guard let imageURLString = post.image else {
                        print("couldn't get image url!!!")
                        return
                    }
                    ImageHelper.manager.getImage(from: imageURLString, completionHandler: { (image) in
                        self.favoriteImageView.image = image
                        NSCacheHelper.manager.addImage(with: postID, and: image)
                        self.layoutIfNeeded()
                    }, errorHandler: { (error) in
                        print(error)
                    })
                } else if let error = error {
                    print("could not get single post, \(error)")
                }
            }
        }
    }
    
    private func commonInit() {
        backgroundColor = .gray
        setupViews()
    }
    
    private func setupViews() {
       setupFavoriteImageView()
    }
    
    private func setupFavoriteImageView() {
        contentView.addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
            favoriteImageView.clipsToBounds = true
           
//            make.height.width.equalTo(self.snp.width).multipliedBy(0.09).priority(999)
//            make.top.equalTo(self.snp.top).offset(5)
//            make.leading.equalTo(self.snp.leading).offset(5)
        }
    }
    
}
