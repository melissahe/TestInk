//
//  TutorialViewController.swift
//  TestInk
//
//  Created by C4Q on 3/20/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    open var photoName: String?
    open var photoIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photoName = photoName {
            self.imageView.image = UIImage(named: photoName)
        }

      
    }



}
