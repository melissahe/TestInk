//
//  CropViewController.swift
//  TestInk
//
//  Created by C4Q on 3/30/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {

    var image: UIImage!
    let cropView = CropView()
    let strokeColor:UIColor = UIColor.blue
    
    //Update this for path line width
    let lineWidth:CGFloat = 2.0
    
    var path = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    var croppedImage = UIImage()
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        addActions()
        setupNavBar()

        
    }
    
    private func setupNavBar() {
    }
    
    
    private func setupSubView() {
        view.addSubview(cropView)
        cropView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            cropView.imageView.image = self.image
        }
    }
    
    private func addActions() {
        cropView.cropButton.addTarget(self, action: #selector(crop), for: .touchUpInside)
        cropView.cancelButton.addTarget(self, action: #selector(cancelCrop), for: .touchUpInside)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: false) {
            
        }
    }
    
  
    
}



// MARK:- Cropping Functions
extension CropViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self.cropView.imageView)
            print("touch begin to : \(touchPoint)")
            path.move(to: touchPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self.cropView.imageView)
            print("touch moved to : \(touchPoint)")
            path.addLine(to: touchPoint)
            addNewPathToImage()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self.cropView.imageView)
            print("touch ended at : \(touchPoint)")
            path.addLine(to: touchPoint)
            addNewPathToImage()
            path.close()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: self.cropView.imageView)
            print("touch canceled at : \(touchPoint)")
            path.close()
        }
    }
    func addNewPathToImage(){
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        cropView.imageView.layer.addSublayer(shapeLayer)
    }
    
    
    @objc func crop() {
        shapeLayer.fillColor = UIColor.black.cgColor
        cropView.imageView.layer.mask = shapeLayer
        
    }
    
    @objc func cancelCrop() {
        shapeLayer.removeFromSuperlayer()
        path = UIBezierPath()
        shapeLayer = CAShapeLayer()
    }
    
//    This methods is making cropped object of tempImageView's image

    func cropImage(){
        UIGraphicsBeginImageContextWithOptions(cropView.imageView.bounds.size, false, 1)
        
        cropView.imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        croppedImage = newImage!
    }
    

}
