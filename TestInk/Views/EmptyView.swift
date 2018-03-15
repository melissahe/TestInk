//
//  EmptyView.swift
//  TestInk
//
//  Created by C4Q on 3/15/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class EmptyView: UIView {

    lazy var textLabel: UILabel = {
        let label = UILabel()
        //no need for stylesheet for color because this is the only label that will be formatted this way
        label.textColor = UIColor.Custom.taupeGrey
        label.textAlignment = .center
        label.numberOfLines = 0
        //Meseret
        //need stylesheet for font and size
        //delete these lines for font and size once stylesheet is done
        label.font = UIFont(name: "HelveticaNeue", size: 28)
        return label
    }()
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        self.textLabel.text = text
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
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self).inset(20)
            make.leading.trailing.equalTo(self).inset(20)
        }
    }
}
