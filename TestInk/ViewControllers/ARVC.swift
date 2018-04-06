//
//  ARVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import ARKit

class ARVC: UIViewController {
    
    private var arView = ARView()
    //for convenience
    private var sceneView: ARSCNView {
        return arView.ARView
    }
    //    private var arOn: Bool = true
    //Serial queue for updating node stuff
    private var updateQueue: DispatchQueue {
        return DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialSceneKitQueue")
    }
    private var currentNode: SCNNode?
    private var tattooImage: UIImage!
    //    private var tattooImageView: UIImageView {
    //        return UIImageView(image: tattooImage)
    //    }
    //used only if user triggers AR from tattoo image in feed
    private var designID: String?
    
    init(tattooImage: UIImage, designID: String?) {
        self.tattooImage = tattooImage
        self.designID = designID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Custom.lapisLazuli
        view.addSubview(arView)
        arView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        setUpViews()
        setUpNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        if arOn {
        startAR()
        //        } else {
        //            startARWithoutImageTracking()
        //        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //pause ar
        sceneView.session.pause()
    }
    
    private func startAR() {
        //        arOn = true
        //remove all existing nodes
        sceneView.scene.rootNode.childNodes.forEach { (node) in
            node.removeFromParentNode()
        }
        //        let subviews = sceneView.subviews
        //        for subview in subviews {
        //            subview.removeFromSuperview()
        //        }
        //start ar
        //this configuration uses the back camera and tracks device's movement
        let configuration = ARWorldTrackingConfiguration()
        //load the set of reference images
        
        
///UNCOMMENT lines 79-82 TO GET AR FUNCTIONALITY
        
                guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
                    print("Missing asset images")
                    return
                }
//        tell the AR configuration to detect these reference images
        
///UNCOMMENT line 90 TO GET AR FUNCTIONALITY
        configuration.detectionImages = referenceImages
        configuration.planeDetection = [.horizontal, .vertical]
        
        //run the scene
        //if the scene is paused, it will remove all nodes and stop tracking
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //delete
    //check to see what happens if screen rotates
    private func startARWithoutImageTracking() {
        //        arOn = false
        //remove all existing nodes
        sceneView.scene.rootNode.childNodes.forEach { (node) in
            node.removeFromParentNode()
        }
        
        //        tattooImageView.contentMode = .scaleAspectFit
        //        sceneView.addSubview(tattooImageView)
        ////        tattooImageView.translatesAutoresizingMaskIntoConstraints = false
        //        tattooImageView.center = CGPoint(x: 1000, y: 1000)
        //        tattooImageView.isOpaque = true
        //        tattooImageView.layer.opacity = 0.75
        //        tattooImageView.layoutIfNeeded()
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        //pointOfView is the node where the scene's content is being viewed
        if let pointOfView = sceneView.pointOfView {
            let image = tattooImage!
            let imageWidthMeters = image.size.width * 0.00352778
            let imageHeightMeters = image.size.height * 0.00352778
            //find the smallest scale, to scale uiimage down to size of reference
            //            let scaleWidth = (referenceImage.physicalSize.width < imageWidthMeters) ? referenceImage.physicalSize.width / imageWidthMeters : imageWidthMeters / referenceImage.physicalSize.width
            //            let scaleHeight = (referenceImage.physicalSize.height < imageHeightMeters) ? referenceImage.physicalSize.height / imageHeightMeters : imageHeightMeters / referenceImage.physicalSize.height
            //use the smaller scale
            //            let scale = (scaleWidth > scaleHeight) ? scaleHeight : scaleWidth
            
            //create the plane for the initial position of the detected image
            let plane = SCNPlane(width: imageWidthMeters, height: imageHeightMeters)
            
            //            let screenSizeWidth = UIScreen.main.bounds.width
            //            let screenSizeHeight = UIScreen.main.bounds.height
            //            //get the scale factor for making a smaller image
            //            let scaleWidth = (image.size.width > screenSizeWidth) ? (screenSizeWidth / image.size.width) : (image.size.width / screenSizeWidth)
            //            let scaleHeight = (image.size.height > screenSizeHeight) ? (screenSizeHeight / image.size.height) : (image.size.height / screenSizeHeight)
            //SCNPlane - rectangular one-sided plane geometry of specified width and height
            //            let plane = SCNPlane(width: 0.5, height: 0.5)
            //material for the plane node - defines appearance of geometry's surface when rendered
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            plane.materials = [material]
            let planeNode = SCNNode(geometry: plane)
            //          planeNode.look(at: pointOfView.position)
            //        let ball = SCNSphere(radius: 0.02)
            //            ball.materials = [material]
            //        let ballNode = SCNNode(geometry: ball)
            //        ballNode.position = SCNVector3Make(0, 0, -0.2)
            planeNode.position = SCNVector3Make(0, 0, -2)
            pointOfView.addChildNode(planeNode)
            //            sceneView.scene.rootNode.addChildNode(planeNode)
            //            //doesn't work
        }
    }
    
    private func setUpViews() {
         sceneView.delegate = self
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        arView.captureButton.addTarget(self, action: #selector(captureButtonPressed), for: .touchUpInside)
        //        arView.segmentedControl.addTarget(self, action: #selector(ARButtonTapped(sender:)), for: .valueChanged)
    }
    
    private func setUpNavigation() {
        //        arView.dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(dismissView))
    }
    
    @objc private func captureButtonPressed() {
        //should snap image, then segue to EditImageVC
        var image: UIImage?
        //        if arOn {
        image = sceneView.snapshot()
        //        } else {
        //            //begin image context
        //            UIGraphicsBeginImageContextWithOptions(sceneView.bounds.size, false, UIScreen.main.scale)
        //            //gets snapshot and puts it in current context
        //            sceneView.drawHierarchy(in: sceneView.frame, afterScreenUpdates: true)
        //            //returns image from current context
        //            if let snapshot = UIGraphicsGetImageFromCurrentImageContext() {
        //                //remove context
        //                UIGraphicsEndImageContext()
        //                image = snapshot
        //
        //            }
        //        }
        if let image = image {
            let editImageVC = EditImageVC(image: image, designID: self.designID)
            self.navigationController?.pushViewController(editImageVC, animated: false)
        }
    }
    
    //    @objc private func ARButtonTapped(sender: UISegmentedControl) {
    //        switch sender.selectedSegmentIndex {
    //        case 0: //ar on
    //            startAR()
    //        default: //ar off
    //            //to do - should remove all anchors and stop image tracking, but have tattoo image at center
    //            startARWithoutImageTracking()
    //            return
    //        }
    //    }
    
    @objc private func dismissView() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

///UNCOMMENT TO GET AR FUNCTIONALITY

extension ARVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor
            //        let planeAnchor = anchor as? ARPlaneAnchor
            else {
                print("couldn't get image anchor")
                return
        }

        let referenceImage = imageAnchor.referenceImage
        updateQueue.async {
            //maybe i could let user add in what size they want the image to be? and use that instead?
                //figure out how to let user interact with the node
            let image = self.tattooImage!
            //points to meters = (x points * 0.000352778
            let imageWidthMeters = image.size.width * 0.000352778
            let imageHeightMeters = image.size.height * 0.000352778
            //find the smallest scale, to scale uiimage down to size of reference
            let scaleWidth = (referenceImage.physicalSize.width < imageWidthMeters) ? referenceImage.physicalSize.width / imageWidthMeters : imageWidthMeters / referenceImage.physicalSize.width
            let scaleHeight = (referenceImage.physicalSize.height < imageHeightMeters) ? referenceImage.physicalSize.height / imageHeightMeters : imageHeightMeters / referenceImage.physicalSize.height
            //use the smaller scale
            let scale = (scaleWidth > scaleHeight) ? scaleHeight : scaleWidth

            //create the plane for the initial position of the detected image
            let plane = SCNPlane(width: imageWidthMeters * scale, height: imageHeightMeters * scale)
            let material = SCNMaterial()
            material.diffuse.contents = image
            plane.materials = [material]
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.75

            //SCNPlane is vertically oriented by default, but imageAnchor is horizontally orientated, but ARImageAnchor assumes the image is horizontal, so rotate the plane to match
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

            node.addChildNode(planeNode)
            //remove previous node in case multiple ones are added
            if let previousNode = self.currentNode, let anchor = self.sceneView.anchor(for: previousNode) {
                self.sceneView.session.remove(anchor: anchor)
                //should get rid of the current node
                previousNode.removeFromParentNode()
            }
            //add current node
            self.currentNode = planeNode
        }
    }
}

