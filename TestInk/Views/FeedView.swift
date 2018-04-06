//
//  FeedView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class FeedView: UIView {
    
    //segmented control to tab between design and preview table views
    lazy var segmentedControl: UISegmentedControl = {
       let seg = UISegmentedControl(items: ["Designs", "Body Previews"])
        seg.selectedSegmentIndex = 0
        seg.accessibilityNavigationStyle = .separate
        seg.layer.borderWidth = 0
        let font = UIFont(name: "HelveticaNeue", size: 13)
        seg.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        seg.backgroundColor = Stylesheet.Colors.Lapislazuli
        seg.tintColor = Stylesheet.Colors.LightBlue
        return seg
    }()
    
    //tableview - register cell using FeedTableViewCell
    lazy var designTableView: UITableView = {
        let tv = UITableView()
        //create and register a cell
        tv.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        tv.backgroundColor = Stylesheet.Colors.LightBlue
        tv.isHidden = false
        return tv
    }()
    
    //to do when FeedCell is finished
    lazy var previewTableView: UITableView = {
        let tv = UITableView()
        //create and register a cell
        tv.register(PreviewCell.self, forCellReuseIdentifier: "PreviewCell")
        tv.backgroundColor = Stylesheet.Colors.LightBlue
        tv.isHidden = true
        return tv
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
        setupViews()
    }
    
    private func setupViews() {
        setupSegmentedControl()
        setupDesignTableView()
        setupPreviewTableView()
    }
    
    private func setupDesignTableView() {
        setupTableView()
    }
    
    
    private func setupSegmentedControl(){
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.07)
        }
    }
    
    
    private func setupTableView() {
        addSubview(designTableView)
        designTableView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            
        }
    }
    
    private func setupPreviewTableView() {
        addSubview(previewTableView)
        previewTableView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            
        }

    }
}
