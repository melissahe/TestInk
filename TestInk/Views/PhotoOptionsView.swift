//
//  PhotoOptionsView.swift
//  TestInk
//
//  Created by C4Q on 3/16/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class PhotoOptionsView: UIView {

//    lazy var resizeButton: UIButton = {
//        let button = UIButton(type: UIButtonType.system)
//        button.setImage(#imageLiteral(resourceName: "resizeIcon"), for: .normal)
//        //Meseret
//        button.backgroundColor = UIColor.Custom.lapisLazuli
//        button.tintColor = UIColor.Custom.whiteSmoke
//        return button
//    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "actionIcon"), for: .normal)
        //Meseret
        button.backgroundColor = UIColor.Custom.lapisLazuli
        button.tintColor = UIColor.Custom.whiteSmoke
        return button
    }()
    
    lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "filterIcon"), for: .normal)
//        button.setTitle("FILTERS", for: .normal)
        //Meseret
        button.backgroundColor = UIColor.Custom.lapisLazuli
        button.tintColor = UIColor.Custom.whiteSmoke
        return button
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
        backgroundColor = UIColor.Custom.mediumSkyBlue
        setUpViews()
    }
    
    private func setUpViews() {
//        setUpResizeButton()
        setUpFiltersButton()
        setUpShareButton()
    }
    
//    private func setUpResizeButton() {
//        addSubview(resizeButton)
//
//        resizeButton.snp.makeConstraints { (make) in
//            make.top.leading.equalTo(self)
//            make.width.height.equalTo(self).multipliedBy(0.5)
//        }
//
//        resizeButton.layer.masksToBounds = true
//        resizeButton.layer.borderWidth = 0.75
//        resizeButton.layer.borderColor = UIColor.Custom.whiteSmoke.cgColor
//    }
    
    private func setUpShareButton() {
        addSubview(shareButton)
        
        shareButton.snp.makeConstraints { (make) in
            make.leading.equalTo(filtersButton.snp.trailing)
//            make.height.equalTo(self).multipliedBy(0.5)
            make.top.trailing.bottom.equalTo(self)
        }
        
        shareButton.layer.masksToBounds = true
        shareButton.layer.borderWidth = 0.75
        shareButton.layer.borderColor = UIColor.Custom.whiteSmoke.cgColor
    }
    
    private func setUpFiltersButton() {
        addSubview(filtersButton)
        
        filtersButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.5)
        }

//        filtersButton.snp.makeConstraints { (make) in
//            make.top.equalTo(resizeButton.snp.bottom)
//            make.leading.trailing.bottom.equalTo(self)
//        }
        
        filtersButton.layer.masksToBounds = true
        filtersButton.layer.borderWidth = 0.75
        filtersButton.layer.borderColor = UIColor.Custom.whiteSmoke.cgColor
    }

}
