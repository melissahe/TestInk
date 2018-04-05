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
    private lazy var designEmptyView = EmptyView(frame: self.view.safeAreaLayoutGuide.layoutFrame, emptyStateType: .designs)
    private lazy var previewEmptyView = EmptyView(frame: self.view.safeAreaLayoutGuide.layoutFrame, emptyStateType: .previews)
    
    private var designPosts: [DesignPost] = []
    private var previewPosts: [PreviewPost] = []
    
    private var currentUserID: String {
        return AuthUserService.manager.getCurrentUser()!.uid
    }
    
    private var designRefreshControl: UIRefreshControl!
    private var previewRefreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadDesignData()
        //loadPreviewData()
        designRefreshControl = UIRefreshControl()
        previewRefreshControl = UIRefreshControl()
        designRefreshControl.addTarget(self, action: #selector(loadDesignData), for: .valueChanged)
        previewRefreshControl.addTarget(self, action: #selector(loadPreviewData), for: .valueChanged)
        //MARK: design tableview setup
        feedView.designTableView.refreshControl = designRefreshControl
        feedView.designTableView.delegate = self
        feedView.designTableView.dataSource = self
        //MARK: preview tableview setup
        feedView.previewTableView.refreshControl = previewRefreshControl
        feedView.previewTableView.delegate = self
        feedView.previewTableView.dataSource = self
        //MARK: used for self sizing cells
        feedView.designTableView.rowHeight = UITableViewAutomaticDimension
        feedView.previewTableView.rowHeight = UITableViewAutomaticDimension
        feedView.designTableView.estimatedRowHeight = 200
        feedView.previewTableView.estimatedRowHeight = 200
        self.navigationItem.title = "Feed"
        //MARK: functionality for segmented control
        feedView.segmentedControl.removeBorder()
        feedView.segmentedControl.addTarget(self, action: #selector(segControlIndexPressed(_:)), for: .valueChanged)
    }
    
    func addUnderlineForSelectedSegment(segmentedControl: UISegmentedControl){
        let underlineWidth: CGFloat = (feedView.frame.size.width / CGFloat(segmentedControl.numberOfSegments))
        let underlineHeight: CGFloat = 2
        let underlineXPosition = CGFloat(segmentedControl.selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = segmentedControl.frame.maxY + 8
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = Stylesheet.Colors.Lapislazuli
        underline.tag = 1
        feedView.addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func changeUnderlinePosition(segmentedControl: UISegmentedControl){
        guard let underline = self.feedView.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.feedView.frame.width / CGFloat(segmentedControl.numberOfSegments)) * CGFloat(segmentedControl.selectedSegmentIndex)
        UIView.animate(withDuration: 0.15, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
    
    override func viewDidLayoutSubviews() {
        if self.feedView.viewWithTag(1) == nil {
            addUnderlineForSelectedSegment(segmentedControl: feedView.segmentedControl)
        }
    }
    
    @objc private func segControlIndexPressed(_ sender: UISegmentedControl){
       
        switch sender.selectedSegmentIndex {
        case 0:
            changeUnderlinePosition(segmentedControl: feedView.segmentedControl)
            loadDesignData()
            navigationItem.title = "Tattoo Designs"
            feedView.previewTableView.isHidden = true
            feedView.designTableView.isHidden = false
            previewEmptyView.removeFromSuperview()
        case 1:
            changeUnderlinePosition(segmentedControl: feedView.segmentedControl)
            loadPreviewData()
             navigationItem.title = "Tattoo Previews"
            feedView.designTableView.isHidden = true
            feedView.previewTableView.isHidden = false
            designEmptyView.removeFromSuperview()
        default:
            break
        }
    }
    
    private func presentNoInternetAlert() {
        let noInternetAlert = Alert.createErrorAlert(withMessage: "No internet. Please check your network connection.")
        self.present(noInternetAlert, animated: true, completion: nil)
    }
    
    @objc private func loadDesignData() {
        if noInternet {
            presentNoInternetAlert()
            designRefreshControl.endRefreshing()
            return
        }
        FirebaseDesignPostService.service.getAllDesignPosts { (posts, error) in
            self.designRefreshControl.endRefreshing()
            if let posts = posts {
                self.designPosts = posts
                self.feedView.designTableView.reloadData()
                
                if posts.isEmpty {
                    self.view.addSubview(self.designEmptyView)
                    self.designEmptyView.snp.makeConstraints({ (make) in
                        make.edges.equalTo(self.feedView.designTableView.snp.edges)
                    })
                } else {
                    self.designEmptyView.removeFromSuperview()
                    
                }
            } else if let error = error {
                print(error)
                let errorAlert = Alert.createErrorAlert(withMessage: "Could not get designs. Please check network connection.")
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func loadPreviewData() {
        if noInternet {
            presentNoInternetAlert()
            previewRefreshControl.endRefreshing()
            return
        }
        FirebasePreviewPostService.service.getAllPreviewPosts { (posts, error) in
            self.previewRefreshControl.endRefreshing()
            if let posts = posts {
                self.previewPosts = posts
                self.feedView.previewTableView.reloadData()
                if posts.isEmpty {
                    self.view.addSubview(self.previewEmptyView)
                    self.previewEmptyView.snp.makeConstraints({ (make) in
                        make.edges.equalTo(self.feedView.designTableView.snp.edges)
                    })
                } else {
                    self.previewEmptyView.removeFromSuperview()
                    
                }
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
        feedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension FeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == feedView.designTableView {
            return designPosts.count
        }
        return previewPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == feedView.designTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
            let currentDesign = designPosts[indexPath.row]
            cell.delegate = self
            cell.selectionStyle = .none
            cell.configureCell(withPost: currentDesign)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewCell") as! PreviewCell
        //as! PreviewCell
        let currentPreview = previewPosts[indexPath.row]
        cell.delegate = self
        cell.configureCell(withPost: currentPreview)
        //        cell.userImage.image = #imageLiteral(resourceName: "catplaceholder") //todo
        
        return cell
    }
}

extension FeedVC: UITableViewDelegate{
    //to do - should segue to ARView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == feedView.designTableView {
            let currentDesign = designPosts[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? FeedCell, let image = cell.feedImage.image {
                let arVC = ARVC(tattooImage: image, designID: currentDesign.uid)
                self.navigationController?.pushViewController(arVC, animated: true)
            }
        }
        //need to check if it's ar ready, try bool?
        
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
                    
                    guard let index = self.designPosts.index(where: { (designPost) -> Bool in
                        return post.uid == designPost.uid
                    }) else {
                        return
                    }
                    
                    self.feedView.designTableView.beginUpdates()
                    self.designPosts.remove(at: index)
                    self.feedView.designTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    self.feedView.designTableView.endUpdates()
                    
                    if let textField = flagAlert.textFields?.first, let flagText = textField.text {
                        FirebaseFlaggingService.service.addFlagToFirebase(flaggedBy: self.currentUserID, userFlagged: post.userID, postID: post.uid, flagMessage: flagText)
                        
                        FirebaseFlaggingService.service.flagPost(withPostType: .design, flaggedPostID: post.uid, flaggedByUserID: self.currentUserID, flaggedCompletion: { (_) in})
                        
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
        if cell.likeButton.imageView?.image == #imageLiteral(resourceName: "heartUnfilled") {
            cell.likeButton.layer.shadowColor = UIColor(hex: "F78F8F").cgColor
            cell.likeButton.layer.masksToBounds = false
            let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
            opacityAnimation.fromValue = 0 // minimum value
            opacityAnimation.toValue = 1 // maximum value
            
            // changing shadow radius
            cell.likeButton.layer.shadowRadius = 10
            
            // create group animation for shadow animation
            let groupAnimation = CAAnimationGroup()
            groupAnimation.autoreverses = true
            groupAnimation.animations = [opacityAnimation]
            groupAnimation.duration = 0.7
            cell.likeButton.layer.add(groupAnimation, forKey: nil)
        }
        FirebaseLikingService.service.favoritePost(withDesignPostID: post.uid, favoritedByUserID: currentUserID) { (numberOfLikes) in
            cell.numberOfLikes.text = numberOfLikes.description
        }
    }
}

extension FeedVC: PreviewCellDelegate {
    func didTapFlag(onPost post: PreviewPost, cell: PreviewCell) {
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
                    
                    guard let index = self.previewPosts.index(where: { (previewPost) -> Bool in
                        return post.uid == previewPost.uid
                    }) else {
                        return
                    }
                    
                    self.feedView.previewTableView.beginUpdates()
                    self.previewPosts.remove(at: index)
                    self.feedView.previewTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    self.feedView.previewTableView.endUpdates()
                    
                    if let textField = flagAlert.textFields?.first, let flagText = textField.text {
                        FirebaseFlaggingService.service.addFlagToFirebase(flaggedBy: self.currentUserID, userFlagged: post.userID, postID: post.uid, flagMessage: flagText)
                        
                        FirebaseFlaggingService.service.flagPost(withPostType: .preview, flaggedPostID: post.uid, flaggedByUserID: self.currentUserID, flaggedCompletion: { (_) in})
                        
                        cell.flagButton.setImage(#imageLiteral(resourceName: "flagFilled"), for: .normal)
                    }
                }, to: flagAlert)
                self.present(flagAlert, animated: true, completion: nil)
            }
        }
    }
    
    func didTapShare(image: UIImage, forPost post: PreviewPost) {
        print("tapped share button!!")
        let activityVC = UIActivityViewController(activityItems: [image, "Check out this cool design from TestInk!!!"], applicationActivities: [])
        self.present(activityVC, animated: true, completion: nil)
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

//////////////////MARK: this will remove the the border from the segmented control and add an underline for the selected segment
//inspiration: https://stackoverflow.com/questions/42755590/how-to-display-only-bottom-border-for-selected-item-in-uisegmentedcontrol
extension UISegmentedControl{
    
    func removeBorder(){
        //background image - if you want both options to have the same color, you need to set the same background image for different states
        let backgroundImage = UIImage.getColoredRectImageWith(color: Stylesheet.Colors.LightBlue.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        //the dividing line - the line that divides the options
        let dividerImage = UIImage.getColoredRectImageWith(color: Stylesheet.Colors.LightBlue.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(dividerImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        //unselected
        self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.Custom.taupeGrey], for: .normal)
        //selected
        self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Stylesheet.Colors.Lapislazuli], for: .selected)
    }
}

extension UIImage{
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
