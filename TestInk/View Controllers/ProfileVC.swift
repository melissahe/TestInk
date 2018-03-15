//
//  ProfileVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        view.addSubview(profileView)
        view.backgroundColor = .green
        setupViews()
    }
    
    private func setupViews() {
        //right bar button
        let addLogoutItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: profileView.logoutButton, action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = addLogoutItem
        profileView.changeProfileImageButton.addTarget(self, action: #selector(changeProfileButtonPressed), for: .touchUpInside)
    }
    
    
    @objc private func logoutPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func changeProfileButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

}
