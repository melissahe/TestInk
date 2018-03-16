//
//  ARVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ARVC: UIViewController {

    var arView = ARView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arView)
        arView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        arView.dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)

        
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }


}
