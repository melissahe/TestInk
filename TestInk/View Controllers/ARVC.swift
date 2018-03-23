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
    //Serial queue for updating node stuff
    private var updateQueue: DispatchQueue {
        return DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialSceneKitQueue")
    }
    private var currentNode: SCNNode?
    private var tattooImage: UIImage!
    
    init(tattooImage: UIImage) {
        self.tattooImage = tattooImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arView)
        arView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        setUpViews()
        setUpNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //pause ar
        sceneView.session.pause()
    }
    
    private func startAR() {
        //start ar
        //this configuration uses the back camera and tracks device's movement
        let configuration = ARWorldTrackingConfiguration()
        //load the set of reference images
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            print("Missing asset images")
            return
        }
        //tell the AR configuration to detect these reference images
        configuration.detectionImages = referenceImages
        //run the scene
        //if the scene is paused, it will remove all nodes and stop tracking
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    private func setUpViews() {
        sceneView.delegate = self
        arView.captureButton.addTarget(self, action: #selector(captureButtonPressed), for: .touchUpInside)
        arView.segmentedControl.addTarget(self, action: #selector(ARButtonTapped(sender:)), for: .valueChanged)
    }
    
    private func setUpNavigation() {
        //        arView.dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(dismissView))
    }
    
    @objc private func captureButtonPressed() {
        //should snap image, then segue to EditImageVC
        let image = sceneView.snapshot()
        let editImageVC = EditImageVC(image: image)
        self.navigationController?.pushViewController(editImageVC, animated: false)
    }
    
    @objc private func ARButtonTapped(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //ar on
            startAR()
        default: //ar off
            //to do - should remove all anchors and stop image tracking, but have tattoo image at center
            return
        }
    }
    
    @objc private func dismissView() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

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
            planeNode.opacity = 1.0
            
            //SCNPlane is vertically oriented by default, but imageAnchor is horizontally orientated, but ARImageAnchor assumes the image is horizontal, so rotate the plane to match
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            node.addChildNode(planeNode)
            //remove previous node in case multiple ones are added
            if let previousNode = self.currentNode, let anchor = self.sceneView.anchor(for: previousNode) {
                self.sceneView.session.remove(anchor: anchor)
            }
            //add current node
            self.currentNode = planeNode
        }
    }
}
