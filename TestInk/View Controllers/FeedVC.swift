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
    
    private let feedView = FeedView()
    private var designPosts: [DesignPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(feedView)
        feedView.tableView.delegate = self
        feedView.tableView.dataSource = self
        view.backgroundColor = .orange
        view.addSubview(feedView)
        feedView.tableView.dataSource = self
        feedView.tableView.rowHeight = UITableViewAutomaticDimension
        feedView.tableView.estimatedRowHeight = 120
        setupViews()
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
            } else if let error = error {
                print(error)
                let errorAlert = Alert.createErrorAlert(withMessage: "Could not get designs. Please check network connection.")
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupViews() {
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        cell.userImage.image = #imageLiteral(resourceName: "catplaceholder") //todo
        return cell
    }
}

extension FeedVC: UITableViewDelegate{
    //to do - should segue to ARView
}
