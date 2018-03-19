//
//  FilterView.swift
//  TestInk
//
//  Created by C4Q on 3/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FilterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.Custom.mediumSkyBlue
        setUpViews()
    }
    
    private func setUpViews() {
        
    }
}
