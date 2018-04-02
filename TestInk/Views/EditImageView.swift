//
//  EditImageView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class EditImageView: UIView {

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.Custom.gainsboro
        return imageView
    }()
    
    lazy var photoOptionsView: PhotoOptionsView = {
        let view = PhotoOptionsView(frame: self.frame)
        return view
    }()
    
//    lazy var editView: EditView = {
//        let view = EditView(frame: self.frame)
//        return view
//    }()
    
    lazy var filterView: FilterView = {
        let view = FilterView(frame: self.frame)
        return view
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
        backgroundColor = UIColor.Custom.taupeGrey
//        editView.isHidden = true
        filterView.isHidden = true
        setUpViews()
    }
    
    private func setUpViews() {
        setUpPhotoImageView()
        setUpPhotoOptionsView()
//        setUpEditView()
        setUpFilterView()
    }
    
    private func setUpPhotoImageView() {
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.80)
        }
    }
    
    private func setUpPhotoOptionsView() {
        addSubview(photoOptionsView)

        photoOptionsView.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self)
        }
    }

//    private func setUpEditView() {
//        addSubview(editView)
//
//        editView.snp.makeConstraints { (make) in
//            make.edges.equalTo(photoOptionsView.snp.edges)
//        }
//    }
    
    private func setUpFilterView() {
        addSubview(filterView)
        
        filterView.snp.makeConstraints { (make) in
            make.edges.equalTo(photoOptionsView.snp.edges)
        }
    }

}
