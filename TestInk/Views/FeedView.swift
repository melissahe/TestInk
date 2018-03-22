//
//  FeedView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FeedView: UIView {

    //tableview - register cell using FeedTableViewCell
    lazy var tableView: UITableView = {
        let tv = UITableView()
        //create and register a cell
        tv.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        tv.backgroundColor = UIColor(red:0.92, green:0.47, blue:0.25, alpha:1.0)
        tv.isHidden = false
        return tv
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
        backgroundColor = .clear
        setupViews()
    }

    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(self.safeAreaLayoutGuide.snp.width)
        }
    }
}
