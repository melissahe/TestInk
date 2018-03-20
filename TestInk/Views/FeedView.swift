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

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
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
        backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }

}
