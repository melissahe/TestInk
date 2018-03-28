//
//  LoginView.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
    //email
    lazy var emailTextField: UITextField = {
        let emailTF = UITextField()
        Stylesheet.Objects.Textfields.LoginEmail.style(textfield: emailTF)
        return emailTF
    }()
    //password
    lazy var passwordTextField: UITextField = {
        let passTF = UITextField()
        Stylesheet.Objects.Textfields.LoginPassword.style(textfield: passTF)
        return passTF
    }()
    // Login
    lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        Stylesheet.Objects.Buttons.Login.style(button: loginButton)
        return loginButton
    }()
    
    // Forgot Password
    lazy var forgotPassButton: UIButton = {
        let forgotButton = UIButton ()
        forgotButton.setTitle("Forgot Password?", for: .normal)
        Stylesheet.Objects.Buttons.ForgotPassword.style(button: forgotButton)
        return forgotButton
    }()
    
    // Sign up Button -
    lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        Stylesheet.Objects.Buttons.SignUpButton.style(button: signUpButton)
        return signUpButton
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
        backgroundColor = Stylesheet.Colors.Lapislazuli
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        let views = [emailTextField, passwordTextField, loginButton, signUpButton, forgotPassButton] as [UIView]
        views.forEach { addSubview($0); ($0).translatesAutoresizingMaskIntoConstraints = false}
        
    }
    
    private func setupConstraints () {
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self).multipliedBy(0.9)
            make.height.equalTo(self).multipliedBy(0.1)
            make.top.equalTo(self).offset(50)
            make.centerX.equalTo(self)
        }
        
        
        // setUp PasswordTF
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self).multipliedBy(0.9)
            make.height.equalTo(self).multipliedBy(0.1)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        }
        //setUp LoginButton
        loginButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self).multipliedBy(0.3)
            make.height.equalTo(self).multipliedBy(0.1)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            
            loginButton.layer.cornerRadius = 15
            loginButton.layer.masksToBounds = true
        }
        
        //SetUp SignUpButton
        signUpButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self).multipliedBy(0.3)
            make.height.equalTo(self).multipliedBy(0.1)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            
        }
        
        //setUp ForgotPassword
        forgotPassButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self).multipliedBy(0.45)
            make.height.equalTo(self).multipliedBy(0.1)
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        }
    }
}

