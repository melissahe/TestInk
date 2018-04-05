//
//  EmptyView.swift
//  TestInk
//
//  Created by C4Q on 3/15/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

enum EmptyState {
    case favorites
    case designs
    case previews
    case noInternet
}

class EmptyView: UIView {

    lazy var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.Custom.taupeGrey
        return imageView
    }()
    
    lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        //no need for stylesheet for color because this is the only label that will be formatted this way
        label.textColor = UIColor.Custom.taupeGrey
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return label
    }()
    
    lazy var detailedTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.Custom.taupeGrey
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        return label
    }()
    
    init(frame: CGRect, emptyStateType: EmptyState) {
        super.init(frame: frame)
        switch emptyStateType {
        case .designs:
            self.emptyStateImageView.image = #imageLiteral(resourceName: "coloredPreviewIcon")
            self.titleTextLabel.text = "No tattoo designs in the feed. :("
            self.detailedTextLabel.text = "Tap the \"+\" tab in the bottom bar and add a design!"
        case .previews:
            self.emptyStateImageView.image = #imageLiteral(resourceName: "coloredPreviewIcon")
            self.titleTextLabel.text = "There are no tattoo previews in the feed."
            self.detailedTextLabel.text = "Try on a tattoo, take a picture, and share it to the feed!"
        case.favorites:
            self.emptyStateImageView.image = #imageLiteral(resourceName: "heartIcon")
            self.titleTextLabel.text = "You have no favorites saved."
            self.detailedTextLabel.text = "Start by checking out the cool tattoo designs in the feed! :)"
        case .noInternet:
            return //to fix
        }
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.Custom.gainsboro
        setUpViews()
    }
    
    private func setUpViews() {
        setUpEmptyStateImageView()
        setUpTitleTextLabel()
        setUpDetailedTextLabel()
    }
    
    private func setUpEmptyStateImageView() {
        addSubview(emptyStateImageView)
        emptyStateImageView.snp.makeConstraints { (make) in
            make.height.equalTo(self).multipliedBy(0.33)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).multipliedBy(0.80)
        }
        emptyStateImageView.layer.opacity = 0.7
    }
    
    private func setUpTitleTextLabel() {
        addSubview(titleTextLabel)
        titleTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(8)
            make.width.equalTo(self).multipliedBy(0.85)
            make.centerX.equalTo(self)
        }
    }
    
    private func setUpDetailedTextLabel() {
        addSubview(detailedTextLabel)
        
        detailedTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextLabel.snp.bottom).offset(8)
            make.width.equalTo(self).multipliedBy(0.9)
//            make.bottom.equalTo(self).offset(-8)
            make.centerX.equalTo(self)
            
        }
    }
}
