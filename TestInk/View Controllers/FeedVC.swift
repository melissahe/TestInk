//
//  FeedVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    let feedView = FeedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(feedView)
//        feedView.tableView.dataSource = self
        feedView.tableView.rowHeight = UITableViewAutomaticDimension
        feedView.tableView.estimatedRowHeight = 120
        setupViews()
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

//extension FeedVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
//
//        return cell
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//}
