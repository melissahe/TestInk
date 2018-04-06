//
//  StockImagesCollectionViewCell.swift
//  TestInk
//
//  Created by C4Q on 3/29/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class StockImagesCollectionViewCell: UICollectionViewCell {
    lazy var stockImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "placeholder")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .clear
        setupViews()
    }
    
    func setupViews(){
        contentView.addSubview(stockImage)
        stockImage.snp.makeConstraints { (image) in
            image.edges.equalTo(contentView)
        }
    }
}
