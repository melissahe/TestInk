//
//  EditImageVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class EditImageVC: UIViewController {

    lazy private var editImageView = EditImageView(frame: view.safeAreaLayoutGuide.layoutFrame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        view.addSubview(editImageView)
        editImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        editImageView.photoOptionsView.resizeButton.addTarget(self, action: #selector(resizeButtonPressed), for: .touchUpInside)
    }
    
    @objc private func resizeButtonPressed() {
        editImageView.editView.isHidden = false
    }
    
}
