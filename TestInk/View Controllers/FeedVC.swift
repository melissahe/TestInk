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
        view.addSubview(feedView)
        feedView.tableView.delegate = self
        feedView.tableView.dataSource = self
        view.backgroundColor = .orange
    }

}

extension FeedVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        cell.userImage.image = #imageLiteral(resourceName: "catplaceholder")
        return cell
    }
}

extension FeedVC: UITableViewDelegate{
    
}
