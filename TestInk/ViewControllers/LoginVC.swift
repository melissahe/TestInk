//
//  LoginVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Firebase


@objc protocol LoginDelegate: class {
    @objc optional func didSignInButtonPressed(_ email: String, _ password: String)
    @objc optional func didSignUpButtonPressed(_ userName: String, _ email: String, _ password: String)
}

class LoginVC: UIViewController {
    weak var delegate: LoginDelegate?
    var activeTextField: UITextField = UITextField()
    
    let userLoginView = LoginView()
    let forgotPassView = ForgotPasswordView()
    let feedVC = FeedVC()
    
    private var authUserService = AuthUserService.manager
    //var verificationTimer: Timer = Timer() //For email verification
    
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "TestInkLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = Stylesheet.Colors.Lapislazuli
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.barTintColor = Stylesheet.Contexts.NavigationController.BarColor
        
    
        if let emailExist = UserDefaultsHelper.manager.getEmail() {
            userLoginView.emailTextField.text = emailExist
        }
        //TO:DO change title color...
        
        //textfield  and Auth delegate
        userLoginView.emailTextField.delegate = self
        userLoginView.passwordTextField.delegate = self
        loginViewConstraints()
        
        //To check if user is already logged in.
            if Auth.auth().currentUser != nil {
                let tbc = TabBarController()
                present(tbc, animated: true, completion: nil)
                
         //self.present(feedVC, animated: true, completion: nil)
         }
        //For buttons clicked
        userLoginView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        userLoginView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        userLoginView.forgotPassButton.addTarget(self, action: #selector(resetpassword), for: .touchUpInside)
        //self.verificationTimer = Timer.scheduledTimer(timeInterval: 200, target: self, selector: #selector(LoginVC.signUp) , userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Stylesheet.Colors.Lapislazuli
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func loginViewConstraints(){
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(userLoginView)
        userLoginView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.bottom.equalTo(view.snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    @objc private func login() {
        guard let email = userLoginView.emailTextField.text else { self.alertForErrors(with: "Please enter an email."); return }
        guard !email.isEmpty else { self.alertForErrors(with: "Please enter an email."); return }
        guard let password = userLoginView.passwordTextField.text else { self.alertForErrors(with: "Please enter a password."); return }
        guard !password.isEmpty else { self.alertForErrors(with: "Please enter a password."); return }
        
        authUserService.delegate = self
        authUserService.login(withEmail: email, password: password)
    }
    
    
    @objc private func signUp() {
        let createAccountVC = CreateAccountVC()
        createAccountVC.modalTransitionStyle = .coverVertical
        createAccountVC.modalPresentationStyle = .pageSheet
        navigationController?.pushViewController(createAccountVC, animated: true)
        
    }
    
    @objc private func resetpassword() {
        forgotPassView.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        //            let resetVC = ForgotPasswordVC()
        //            resetVC.modalTransitionStyle = .coverVertical
        //            resetVC.modalPresentationStyle = .pageSheet
        forgotPassViewConstraints()
        forgotPassView.resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        forgotPassView.dismissButton.addTarget(self, action: #selector(disMissSelfButton), for: .touchUpInside)
        
        //self.present(ForgotPasswordVC(), animated: true, completion: nil)
    }
    
    func forgotPassViewConstraints(){
        //signUpView.isHidden = true
        view.addSubview(forgotPassView)
        forgotPassView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom)
            make.leading.trailing.equalTo(self.view).inset(30)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
    
    // Reset Password
    @objc private func resetPassword() {
        guard let email = forgotPassView.emailTextField.text else { print("Invalid email"); return}
        guard !email.isEmpty else { print("Enter email please"); return}
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                //Present Alert
                let ac = UIAlertController(title: "Email Sent", message: "An email with reset instructions has been sent.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in self.dimissSelf() })
                ac.addAction(okAction)
                print("Password reset email sent")
                self.present(ac, animated: true)
            }
            else {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    var message = ""
                    switch errorCode{
                    case .missingEmail:
                        message = "Please enter an email."
                    case .invalidEmail:
                        message = "Please enter a valid email."
                    case .userNotFound:
                        message = "There is no record of an account with this email. Please check that your email is correct."
                    default:
                        break
                    }
                    let ac = UIAlertController(title: "Problem Resetting Password", message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    ac.addAction(okAction)
                    self.present(ac, animated: true, completion: nil)
                }
                print("Error in trying to reset passsword: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    //DismissView
    
    @objc func disMissSelfButton() {
        forgotPassView.isHidden = true
        //self.navigationController?.isNavigationBarHidden = false
        //self.forgotPassView.dismiss(animated: true, completion: nil)
    }
    
    func dimissSelf() {
        forgotPassView.isHidden = true
//       self.navigationController?.isNavigationBarHidden = false
        //self.forgotPassView.dismiss(animated: true, completion: nil)
    }
    
    public func alertForErrors(with message: String) {
        let ac = UIAlertController(title: "Problem Logging In", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    
    func customErrorMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension LoginVC: LoginDelegate {
    func didSignUpButtonPressed(_ userName: String, _ email: String, _ password: String) {
        self.authUserService.createAccount(withEmail: email, password: password, displayName: userName)
    }
    
    func didSignInButtonPressed(_ email: String, _ password: String) {
        self.authUserService.login(withEmail: email, password: password)
    }
}
//AuthUserDelegate
extension LoginVC: AuthUserDelegate {

    func didFailSigningOut(_ userService: AuthUserService, error: Error){
        
    }
    
    //password reset protocols
    func didFailToSendPasswordReset(_ userService: AuthUserService, error: Error){
        
    }
    func didSendPasswordReset(_userService: AuthUserService){
        
    }

    func didSignIn(_ userService: AuthUserService, user: User) {
        userLoginView.passwordTextField.text = nil
        
        let tbc = TabBarController()
        present(tbc, animated: true, completion: nil)
    }
    
    func didSignOut(_ userService: AuthUserService) {
        let loginVC = LoginVC()
        self.dismiss(animated: true, completion: nil)
        present(loginVC, animated: true, completion: nil)
    }
    
    func didCreateUser(_ userService: AuthUserService, user: User) {
        guard let userName = user.displayName else {return}
        guard let email = user.email else {return}
        customErrorMessage(title: "Welcome \(userName)", message: "the user was created with \(email), please verify your email.")
    }
    
    func didFailToSignIn(_ userService: AuthUserService, error: Error) {
        customErrorMessage(title: "SignIn failed", message: error.localizedDescription)
    }
    
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        customErrorMessage(title: "Create user failed", message: error.localizedDescription)
    }
    
    func didFailToEmailVerify(_ userService: AuthUserService, user: User, error: Error?) {
        if let error = error {
            customErrorMessage(title: "Email veryfication failed", message: error.localizedDescription)
        } else {
            customErrorMessage(title: "Email veryfication failed", message: "Unknown error")
        }
    }
}
