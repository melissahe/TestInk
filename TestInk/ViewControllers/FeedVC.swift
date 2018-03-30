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
    private var currentUserID: String {
        return AuthUserService.manager.getCurrentUser()!.uid
    }
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(tableViewRefreshed), for: .valueChanged)
        feedView.designTableView.refreshControl = refreshControl
        feedView.designTableView.delegate = self
        feedView.designTableView.dataSource = self
        feedView.designTableView.rowHeight = UITableViewAutomaticDimension
        feedView.designTableView.estimatedRowHeight = 200
        self.title = "Feed"
    }
    
    @objc private func tableViewRefreshed() {
        loadData()
    }
    
    private func presentNoInternetAlert() {
        let noInternetAlert = Alert.createErrorAlert(withMessage: "No internet. Please check your network connection.")
        self.present(noInternetAlert, animated: true, completion: nil)
    }
    
    private func loadData() {
        if noInternet {
            presentNoInternetAlert()
            return
        }
        FirebaseDesignPostService.service.getAllDesignPosts { (posts, error) in
            self.refreshControl.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == feedView.designTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
            let currentDesign = designPosts[indexPath.row]
            cell.delegate = self
            cell.configureCell(withPost: currentDesign)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDesign = designPosts[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? FeedCell, let image = cell.feedImage.image {
            let arVC = ARVC(tattooImage: image, designID: currentDesign.uid)
                 self.navigationController?.pushViewController(arVC, animated: true)
        }
    }
}

extension FeedVC: FeedCellDelegate {
    func didTapFlag(onPost post: DesignPost, cell: FeedCell) {
        print("tapped flag!!")
        if noInternet {
            presentNoInternetAlert()
            return
        }
        FirebaseFlaggingService.service.delegate = self
        //get flags, if userID and postID aren't already there, then allow for flagging, else present error saying you've already flagged
        
        FirebaseFlaggingService.service.checkIfPostIsFlagged(post: post, byUserID: currentUserID) { (postHasBeenFlaggedByUser) in
            if postHasBeenFlaggedByUser {
                let errorAlert = Alert.createErrorAlert(withMessage: "You have already flagged this post. Moderators will review your request shortly.")
                self.present(errorAlert, animated: true, completion: nil)
            } else {
                let flagAlert = Alert.create(withTitle: "Flag", andMessage: "Enter a reason  for your flag request.", withPreferredStyle: .alert)
                flagAlert.addTextField(configurationHandler: nil)
                Alert.addAction(withTitle: "Cancel", style: .cancel, andHandler: nil, to: flagAlert)
                Alert.addAction(withTitle: "OK", style: .default, andHandler: { (_) in
                    if let textField = flagAlert.textFields?.first, let flagText = textField.text {
                        FirebaseFlaggingService.service.addFlagToFirebase(flaggedBy: self.currentUserID, userFlagged: post.userID, postID: post.uid, flagMessage: flagText)
                        FirebaseFlaggingService.service.flagPost(withDesignPostID: post.uid, flaggedByUserID: self.currentUserID, flaggedCompletion: {_ in})
                        
                        cell.flagButton.setImage(#imageLiteral(resourceName: "flagFilled"), for: .normal)
                    }
                }, to: flagAlert)
                self.present(flagAlert, animated: true, completion: nil)
            }
        }
    }
    
    func didTapShare(image: UIImage, forPost post: DesignPost) {
        print("tapped share button!!")
        let activityVC = UIActivityViewController(activityItems: [image, "Check out this cool design from TestInk!!!"], applicationActivities: [])
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func didTapLike(onPost post: DesignPost, cell: FeedCell) {
        print("tapped like button!!")
        FirebaseLikingService.service.delegate = self
//        let currentImage = cell.likeButton.imageView?.image
//        let newImage = (currentImage == #imageLiteral(resourceName: "heartUnfilled")) ? #imageLiteral(resourceName: "heartFilled") : #imageLiteral(resourceName: "heartUnfilled")
//        updates like button icon
//        cell.likeButton.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
        FirebaseLikingService.service.favoritePost(withDesignPostID: post.uid, favoritedByUserID: currentUserID) { (numberOfLikes) in
            cell.numberOfLikes.text = numberOfLikes.description
        }
    }
    
}

extension FeedVC: FlagDelegate {
    func didAddFlagToFirebase(_ service: FirebaseFlaggingService) {
        print("added user to flag")
    }
    
    func failedToAddFlagToFirebase(_ service: FirebaseFlaggingService, error: String) {
    }
    
    func didFlagPostAlready(_ service: FirebaseFlaggingService, error: String) {
    }
    
    func didFlagPost(_ service: FirebaseFlaggingService) {
        let successAlert = Alert.create(withTitle: "Success", andMessage: "This post has been flagged. Moderators will review this post shortly.", withPreferredStyle: .alert)
        Alert.addAction(withTitle: "OK", style: .default, andHandler: nil, to: successAlert)
        self.present(successAlert, animated: true, completion: nil)
    }
    
    func didFailToFlagPost(_ service: FirebaseFlaggingService, error: String) {
        let errorAlert = Alert.createErrorAlert(withMessage: "Could not flag this post. Please check your internet connection and try again.")
        self.present(errorAlert, animated: true, completion: nil)
    }
}

extension FeedVC: LikeServiceDelegate {
    func didUnfavoritePost(_ service: FirebaseLikingService, withPostID: String) {
    }
    
    func didFavoritePost(_ service: FirebaseLikingService, withPostID: String) {
    }
    
    func didFailFavoritingPost(_ service: FirebaseLikingService, error: String) {
    }
}
