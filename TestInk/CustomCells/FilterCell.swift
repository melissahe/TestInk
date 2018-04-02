//
//  FilterCell.swift
//  TestInk
//
//  Created by C4Q on 3/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class FilterCell: UICollectionViewCell {

    lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
//        imageView.image = #imageLiteral(resourceName: "catplaceholder")
        return imageView
    }()
    
     lazy var filterNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(withImage image: UIImage, andFilter filter: (displayName: String, filterName: Filter)) {
        filterNameLabel.text = filter.displayName
        
        let image = FilterModel.filterImage(image, withFilter: filter.filterName)
        filterImageView.image = image
        self.layoutIfNeeded()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setUpViews()
    }
    
    private func setUpViews() {
        setUpFilterImageView()
        setUpFilterNameLabel()
    }
    
    private func setUpFilterImageView() {
        contentView.addSubview(filterImageView)
        
        filterImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    private func setUpFilterNameLabel() {
        contentView.addSubview(filterNameLabel)
        
        filterNameLabel.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(filterImageView)
            make.height.equalTo(filterImageView).multipliedBy(0.30)
        }
    }
}
