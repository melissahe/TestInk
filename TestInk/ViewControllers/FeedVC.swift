//
//  FeedVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class FeedVC: UIViewController {
    
    private lazy var feedView = FeedView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
    private var designPosts: [DesignPost] = []
    private var previewPosts: [PreviewPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        feedView.designTableView.delegate = self
        feedView.designTableView.dataSource = self
        feedView.designTableView.dataSource = self
        feedView.designTableView.rowHeight = UITableViewAutomaticDimension
        feedView.designTableView.estimatedRowHeight = 120
        self.title = "Feed"
    }
    
    private func loadData() {
        if noInternet {
            let noInternetAlert = Alert.createErrorAlert(withMessage: "No internet. Please check your network connection.")
            self.present(noInternetAlert, animated: true, completion: nil)
            return
        }
        FirebaseDesignPostService.service.getAllDesignPosts { (posts, error) in
            if let posts = posts {
                self.designPosts = posts
                self.feedView.designTableView.reloadData()
            } else if let error = error {
                print(error)
                let errorAlert = Alert.createErrorAlert(withMessage: "Could not get designs. Please check network connection.")
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        FirebasePreviewPostService.service.getAllPreviewPosts { (posts, error) in
            if let posts = posts {
                self.previewPosts = posts
                self.feedView.previewTableView.reloadData()
            } else if let error = error {
                print(error)
                let errorAlert = Alert.createErrorAlert(withMessage: "Could not get tattoo previews. Please check network connection.")
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(feedView)
        view.backgroundColor = UIColor.Custom.lapisLazuli
        view.addSubview(feedView)
        feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        
        //right bar button
        let uploadButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadButtonPressed))
        navigationItem.rightBarButtonItem = uploadButton
        
    }
    
    @objc private func uploadButtonPressed() {
        let upLoadVC = UploadVC()
        navigationController?.pushViewController(upLoadVC, animated: true)
    }

}

extension FeedVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return designPosts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDesign = designPosts[indexPath.row]
        let uploadVC = UploadVC(designID: currentDesign.uid)
        self.navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == feedView.designTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
            let currentDesign = designPosts[indexPath.row]
            cell.userImage.image = #imageLiteral(resourceName: "catplaceholder") //todo
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewCell")!
            //as! PreviewCell
        let currentPreview = previewPosts[indexPath.row]
//        cell.userImage.image = #imageLiteral(resourceName: "catplaceholder") //todo
        
        return cell
    }
}

extension FeedVC: UITableViewDelegate{
    //to do - should segue to ARView
}
