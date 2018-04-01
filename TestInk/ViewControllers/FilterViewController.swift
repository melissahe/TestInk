//
//  CroppedImageFilterViewController.swift
//  TestInk
//
//  Created by C4Q on 3/31/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    let croppedImageFilterView = ImageFilterView()
    
    var image: UIImage!
    let filterView = ImageFilterView()
    
    var aCIImage = CIImage()
    var spotColorFilter: CIFilter!
    var context = CIContext()
    var outputImage = CIImage()
    var newUIImage = UIImage()
    
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
        filterView.imageView.image = image
        setupSubView()
        setupNavBar()
        applyFilter()
        
 
    }
    private func setupSubView() {
        view.addSubview(filterView)
        filterView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        filterView.contrastSlider.addTarget(self, action: #selector(self.contrastSliderValueChanged(_:)), for: .valueChanged)
        filterView.closenessSlider.addTarget(self, action: #selector(self.closenessSliderValueChanged(_:)), for: .valueChanged)
        
    }
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(presentCropVC))
    }
    
    private func applyFilter() {
        let myImage = filterView.imageView.image!
        let aCGImage = myImage.cgImage
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil)
        spotColorFilter = CIFilter(name: "CISpotColor")
        spotColorFilter.setValue(aCIImage, forKey: "inputImage")
        spotColorFilter.setValuesForKeys(["inputCenterColor1": CIColor(color: .red), "inputCenterColor2" : CIColor(color: .clear), "inputCenterColor3": CIColor(color: .black), "inputReplacementColor1": CIColor(color: .black), "inputReplacementColor2": CIColor(color: .clear), "inputReplacementColor3": CIColor(color: .black)])
        outputImage = spotColorFilter.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: cgimg!)
        filterView.imageView.image = newUIImage
    }
   
    @objc func presentCropVC() {
        let cropVC = CropViewController(image: newUIImage)
        navigationController?.pushViewController(cropVC, animated: true)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: false) {
            
        }
    }
    
    @objc func contrastSliderValueChanged(_ sender: UISlider) {
        spotColorFilter.setValue(NSNumber(value: sender.value), forKey: "inputContrast1")
        spotColorFilter.setValue(NSNumber(value: sender.value), forKey: "inputContrast2")
        spotColorFilter.setValue(NSNumber(value: sender.value), forKey: "inputContrast3")
        outputImage = spotColorFilter.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: cgimg!)
        filterView.imageView.image = newUIImage
    }
    
    @objc func closenessSliderValueChanged(_ sender: UISlider) {
        spotColorFilter.setValue(NSNumber(value: sender.value), forKey: "inputCloseness1")
        spotColorFilter.setValue(NSNumber(value: sender.value), forKey: "inputCloseness2")
        spotColorFilter.setValue(NSNumber(value: sender.value), forKey: "inputCloseness3")
        outputImage = spotColorFilter.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: cgimg!)
        filterView.imageView.image = newUIImage
    }

    
  

}




