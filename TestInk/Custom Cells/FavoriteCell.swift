//
//  FavoriteCell.swift
//  TestInk
//
//  Created by C4Q on 3/15/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
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
       
    }
    


    
}
