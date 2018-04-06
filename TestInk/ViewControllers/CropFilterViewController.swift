//
//  CropFilterViewController.swift
//  TestInk
//
//  Created by C4Q on 4/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
protocol CropFilterVCDelegate : class {
    func didUpdateImage(image: UIImage)
    
}

class CropFilterViewController: UIViewController {

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }
    weak var delegate: CropFilterVCDelegate?
    public var image: UIImage!
    let cropFilterView = CropFilterView()
    
    //Update this for path line color
    private let strokeColor: UIColor = UIColor.blue
    
    //Update this for path line width
    private let lineWidth: CGFloat = 2.0
    
    //Path to draw while touch events occur
    private var path = UIBezierPath()
    
    //ShapeLayer of cropped view
    private var shapeLayer = CAShapeLayer()
    
    //Final Cropped Image
    private var croppedImage = UIImage()
    
    var finalImage = UIImage()
    
    private let ciFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectMono",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CITemperatureAndTint",
        //"CIColorInvert",
        //"CIColorMap",
        "CIColorMonochrome",
        "CIColorPosterize",
        "CIFalseColor",
        //"CIMaskToAlpha",
        "CIVignetteEffect",
        //"CIBumpDistortionLinear",
        //"CICircularWrap",
        //"CIGlassDistortion",
        "CIComicEffect",
        //"CIConvolution7X7",
        //"CICrystallize",
        "CIEdges",
        //"CIEdgeWork",
        //"CIHeightFieldFromMask",
        //"CIHexagonalPixellate",
        //"CILineOverlay",
        "CIPixellate",
        //"CIPointillize",
        //"CIColorCrossPolynomial",
        //"CIColorCube",
        //"CIColorCubeWithColorSpace",
        //"CIMotionBlur",
        //"CIZoomBlur",
        //"CIWhitePointAdjust",
        //"CIAffineTile",
        //"CIEightfoldReflectedTile",
        //"CIKaleidoscope",
        //"CIOpTile",
        //"CISixfoldRotatedTile",
        //"CITriangleTile",
        "CISpotColor"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        setupNavBar()
        cropFilterView.imageView.image = image
        cropFilterView.collectionView.dataSource = self
        cropFilterView.collectionView.delegate = self
        finalImage = image

  
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(cropFilterView.collectionView)
        cropFilterView.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cropFilterView.collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),
            cropFilterView.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cropFilterView.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cropFilterView.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    private func setupSubView() {
        view.addSubview(cropFilterView)
        cropFilterView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        cropFilterView.cropButton.addTarget(self, action: #selector(crop), for: .touchUpInside)
        cropFilterView.cancelButton.addTarget(self, action: #selector(cancelCrop), for: .touchUpInside)
    }
    
    private func addFilter(filterName: String) {
        // Create filters for each button
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: filterName )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let filteredUIImage = UIImage.init(cgImage: filteredImageRef!)//UIImage(CGImage: filteredImageRef!);
        cropFilterView.imageView.image = filteredUIImage
        finalImage = filteredUIImage
        
    }
    
    @objc func crop() {
        shapeLayer.fillColor = UIColor.black.cgColor
        cropFilterView.imageView.layer.mask = shapeLayer
        
        cropImage()
    }
    
    @objc func cancelCrop() {
        shapeLayer.removeFromSuperlayer()
        path = UIBezierPath()
        shapeLayer = CAShapeLayer()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    @objc func doneButtonPressed() {
        updateImage(image: finalImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateImage(image: UIImage) {
        delegate?.didUpdateImage(image: finalImage)
    }


}

extension CropFilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ciFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.backgroundColor = .clear
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: ciFilterNames[indexPath.row])
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let filteredUIImage = UIImage.init(cgImage: filteredImageRef!)//UIImage(CGImage:
        cell.filterImageView.image = filteredUIImage
        
        
        let filterName = ciFilterNames[indexPath.row]
        cell.filterNameLabel.text = filterName
        return cell
    }
}

extension CropFilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterName = ciFilterNames[indexPath.row]
        addFilter(filterName: filterName)
    }
}

// MARK:- Cropping Functions
extension CropFilterViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: cropFilterView.imageView)
            print("touch begin to : \(touchPoint)")
            path.move(to: touchPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: cropFilterView.imageView)
            print("touch moved to : \(touchPoint)")
            path.addLine(to: touchPoint)
            addNewPathToImage()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: cropFilterView.imageView)
            print("touch ended at : \(touchPoint)")
            path.addLine(to: touchPoint)
            addNewPathToImage()
            path.close()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: cropFilterView.imageView)
            print("touch canceled at : \(touchPoint)")
            path.close()
        }
}
    
    func addNewPathToImage(){
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        cropFilterView.imageView.layer.addSublayer(shapeLayer)
    }
    
    /**
     This methods is making cropped object of tempImageView's image
     */
    func cropImage(){
        UIGraphicsBeginImageContextWithOptions(cropFilterView.imageView.bounds.size, false, 1)
        
        cropFilterView.imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        croppedImage = newImage!
        image = croppedImage
        finalImage = croppedImage
       
    }

}
