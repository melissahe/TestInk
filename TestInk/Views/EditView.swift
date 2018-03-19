//
//  EditView.swift
//  TestInk
//
//  Created by C4Q on 3/16/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class EditView: UIView {

    lazy var sizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -0.25
        slider.maximumValue = 2.0
        slider.value = 0.0
        slider.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        slider.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.text = sizeSlider.value.truncatingRemainder(dividingBy: 10).description
        label.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        return label
    }()
    
    lazy var compressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "compressIcon")
        return imageView
    }()
    
    lazy var expandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "enlargeIcon")
        return imageView
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
        setUpViews()
    }
    
    @objc private func sliderValueChanged(slider: UISlider) {
        sliderValueLabel.text = slider.value.truncatingRemainder(dividingBy: 10).description
    }
    
    private func setUpViews() {
        setUpSizeSlider()
        setUpCompressImageView()
        setUpExpandImageView()
        setUpSliderValueLabel()
    }
    
    private func setUpSizeSlider() {
        addSubview(sizeSlider)
        
        sizeSlider.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.height.equalTo(self.snp.height).multipliedBy(0.40)
        }
    }
    
    private func setUpCompressImageView() {
        addSubview(compressImageView)
        
        compressImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(sizeSlider.snp.centerY)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(sizeSlider.snp.leading).offset(-5)
        }
    }
    
    private func setUpExpandImageView() {
        addSubview(expandImageView)
        
        expandImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(sizeSlider.snp.centerY)
            make.leading.equalTo(sizeSlider.snp.trailing).offset(5)
            make.trailing.equalTo(self).offset(-20)
        }
    }
    
    private func setUpSliderValueLabel() {
        addSubview(sliderValueLabel)
        
        sliderValueLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(sizeSlider.snp.centerX)
            make.bottom.equalTo(sizeSlider.snp.top)
            make.top.equalTo(self.snp.top).offset(5)
        }
    }

}
