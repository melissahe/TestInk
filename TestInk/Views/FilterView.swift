//
//  FilterView.swift
//  TestInk
//
//  Created by C4Q on 3/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "filterCell")
        collectionView.backgroundColor = UIColor.Custom.taupeGrey
        return collectionView
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
        setUpFilterCollectionView()
    }
    
    private func setUpFilterCollectionView() {
        addSubview(filterCollectionView)
        
        filterCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
