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

    var pastSliderValue: Float = 0
    
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
        
        editImageView.photoOptionsView.shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        
        editImageView.photoOptionsView.filtersButton.addTarget(self, action: #selector(filtersButtonPressed), for: .touchUpInside)
    }
    
    private func addEditView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "deleteIcon"), style: .done, target: self, action: #selector(deleteButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkIcon"), style: .done, target: self, action: #selector(saveButtonPressed))
    }
    
    private func removeEditView() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        editImageView.editView.isHidden = true
        editImageView.filterView.isHidden = true
    }
    
    @objc private func resizeButtonPressed() {
        editImageView.editView.isHidden = false
        
        pastSliderValue = editImageView.editView.sizeSlider.value
        addEditView()
    }
    
    @objc private func deleteButtonPressed() {
        //reset slider
        editImageView.editView.sliderValueLabel.text = pastSliderValue.truncatingRemainder(dividingBy: 10).description
        editImageView.editView.sizeSlider.value = pastSliderValue
        removeEditView()
    }
    
    @objc private func saveButtonPressed() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        removeEditView()
    }
    
    @objc private func shareButtonPressed() {
        let text = "Check out this tattoo preview!!"
        let imageToBeShared: UIImage = #imageLiteral(resourceName: "checkIcon")
        let activityVC = UIActivityViewController(activityItems: [text, imageToBeShared], applicationActivities: [])
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc private func filtersButtonPressed() {
        editImageView.filterView.isHidden = false
        
        addEditView()
    }
}
