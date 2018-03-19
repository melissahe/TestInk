//
//  EditView.swift
//  TestInk
//
//  Created by C4Q on 3/16/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class EditView: UIView {

    lazy var compressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "compressIcon")
        return imageView
    }()
    
    lazy var expandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "enlargeIcon")
        return imageView
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
        backgroundColor = UIColor.Custom.lapisLazuli
        setUpViews()
    }
    
    private func setUpViews() {
        
    }

}
