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
    //tableview - register cell using FeedTableViewCell
    lazy var designTableView: UITableView = {
        let tv = UITableView()
        //create and register a cell
        tv.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        tv.backgroundColor = UIColor.Custom.lapisLazuli
        tv.isHidden = false
        return tv
    }()
    
    //to do when FeedCell is finished
    lazy var previewTableView: UITableView = {
        let tv = UITableView()
        //create and register a cell
        tv.register(PreviewCell.self, forCellReuseIdentifier: "PreviewCell")
        tv.backgroundColor = UIColor.Custom.lapisLazuli
        tv.isHidden = false
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
        setupDesignTableView()
        setupPreviewTableView()
    }
    
    private func setupDesignTableView() {
        addSubview(designTableView)
        designTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
    
    private func setupPreviewTableView() {
        addSubview(previewTableView)
        previewTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
}
