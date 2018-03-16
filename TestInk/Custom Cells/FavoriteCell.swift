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
        pImageView.image = #imageLiteral(resourceName: "catplaceholder") //place holder image
        //pImageView.isUserInteractionEnabled = true
        pImageView.contentMode = .scaleAspectFill
        pImageView.backgroundColor = UIColor.red
        return pImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        backgroundColor = .gray
        setupViews()
    }
    private func setupViews() {
       setupFavoriteImageView()
    }
    
   
    
    private func setupFavoriteImageView() {
        addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(contentView.snp.height)
           
//            make.height.width.equalTo(self.snp.width).multipliedBy(0.09).priority(999)
//            make.top.equalTo(self.snp.top).offset(5)
//            make.leading.equalTo(self.snp.leading).offset(5)
        }
    }
    
}
