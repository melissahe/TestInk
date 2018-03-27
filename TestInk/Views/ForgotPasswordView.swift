//
//  ForgotPasswordView.swift
//  TestInk
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit
class ForgotPasswordView: UIView {
 
        lazy var dismissButton: UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "icons8-Close"), for: .normal)
            button.tintColor = .orange
            return button
        }()
        
        lazy var resetLabel: UILabel = {
            let label = UILabel()
            label.text = "Forgot password?"
            Stylesheet.Objects.Labels.Regular.style(label: label)
            return label
        }()
        lazy var emailTextField: UITextField = {
            let emailTF = UITextField()
            Stylesheet.Objects.Textfields.LoginEmail.style(textfield: emailTF)
            return emailTF
        }()
        
        
        lazy var resetPasswordButton: UIButton = {
            let resetButton = UIButton()
            resetButton.setTitle("Reset Password", for: .normal)
            Stylesheet.Objects.Buttons.ResetButton.style(button: resetButton)
            return resetButton
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
            backgroundColor = Stylesheet.Colors.LightBlue//.LightGrey
            self.layer.cornerRadius = 15
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: -0.2, height: 0)
            self.layer.shadowRadius = 15
            self.layoutIfNeeded()
            setupViews()
        }
        
        //Setup viwes
        private func setupViews() {
            let views = [dismissButton,emailTextField, resetLabel, resetPasswordButton] as [UIView]
            views.forEach{ addSubview($0) }
            setUpConstraints()
        }
        
        private func setUpConstraints() {
            //dismiss button
            dismissButton.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.size.equalTo(self.snp.size).multipliedBy(0.15)
                
            }
            
            //email text field
            emailTextField.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo(self.snp.centerY)
                make.width.equalTo(self.snp.width).multipliedBy(0.8)
                make.height.equalTo(self.snp.height).multipliedBy(0.1)
            }
            
            // reset label
            resetLabel.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo(self.snp.centerY).offset(-70)
                make.width.equalTo(self.snp.width).multipliedBy(0.8)
                make.height.equalTo(self.snp.height).multipliedBy(0.1)
            }
            
            
            // Submit Button
            resetPasswordButton.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(self.snp.centerY).offset(90)
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(self.snp.width).multipliedBy(0.8)
                make.height.equalTo(self.snp.height).multipliedBy(0.1)
                
                resetPasswordButton.layer.cornerRadius = 15
                resetPasswordButton.layer.masksToBounds = true
            }
        }
}

