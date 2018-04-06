//
//  ARView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import ARKit

class ARView: UIView {

//    lazy var saveButton: UIButton = {
//        let button = UIButton()
//        button.layer.borderWidth = 0.6
//        button.layer.borderColor = UIColor.black.cgColor
//        button.setTitleColor(.black, for: .normal)
//        button.setTitle("Save", for: .normal)
//        let font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
//        button.titleLabel?.font = font
//        button.setImage(UIImage(named:"icons8-save-24"), for: .normal)
//        return button
//    }()
//    lazy var dismissButton: UIButton = {
//      let button = UIButton()
//      button.setImage(UIImage(named: "dismissButtonIcon"), for: .normal)
//      return button
//    }()

    lazy var ARView: ARSCNView = {
        let view = ARSCNView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cameraIcon"), for: .normal)
        button.tintColor = Stylesheet.Colors.WhiteSmoke
        return button
    }()
    
//    lazy var segmentedControl: UISegmentedControl = {
//        let items = ["AR ON", "AR OFF"]
//        let sc = UISegmentedControl(items: items)
//        sc.selectedSegmentIndex = 0
//        return sc
//    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        captureButton.layer.masksToBounds = true
        captureButton.layer.cornerRadius = captureButton.frame.width/2
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Stylesheet.Colors.LightBlue
        setupViews()
    }
    
    private func setupViews() {
//        setupSaveButton()
//        setupDismissButton()
        setupARView()
//        setupSegmentedControl()
        setupCaptureButton()
    }
    
//    private func setupSaveButton() {
//        self.addSubview(saveButton)
//        saveButton.snp.makeConstraints { (make) in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(15)
//            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8)
//            make.width.equalTo(safeAreaLayoutGuide.snp.width).multipliedBy(0.3)
//            make.height.equalTo(saveButton.snp.width).multipliedBy(0.35)
//
//        }
//    }
//
//    private func setupDismissButton() {
//        addSubview(dismissButton)
//        dismissButton.snp.makeConstraints { (make) in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(15)
//            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(8)
//            make.width.equalTo(saveButton.snp.width).multipliedBy(0.7)
//            make.height.equalTo(saveButton.snp.height)
//        }
//    }
    
    private func setupARView() {
        self.addSubview(ARView)
        ARView.snp.makeConstraints { (make) in
//            make.top.equalTo(saveButton.snp.bottom).offset(4)
            make.top.equalTo(self)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(self).multipliedBy(0.80)
        }
    }
    
    private func setupCaptureButton() {
        self.addSubview(captureButton)
        captureButton.snp.makeConstraints { (make) in
            make.top.equalTo(ARView.snp.bottom).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
//            make.width.equalTo(ARView.snp.width).multipliedBy(0.13)
            make.width.equalTo(captureButton.snp.height)
//            make.height.equalTo(captureButton.snp.width)
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
            
        }
    }
    
//    private func setupSegmentedControl() {
//        self.addSubview(segmentedControl)
//        segmentedControl.snp.makeConstraints { (make) in
//            //make.top.equalTo(captureButton.snp.bottom).offset(25)
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-15)
//            make.width.equalTo(safeAreaLayoutGuide.snp.width)
//            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.054)
//        }
//    }

}
