//
//  ProfileVC.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    let profileView = ProfileView()
    let cellSpacing: CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        view.addSubview(profileView)
        view.backgroundColor = .green
        setupViews()
        profileView.collectionView.dataSource = self
        profileView.collectionView.delegate = self
    }
    
    private func setupViews() {
        //right bar button
        let addLogoutItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = addLogoutItem
        profileView.changeProfileImageButton.addTarget(self, action: #selector(changeProfileButtonPressed), for: .touchUpInside)
    }
    
    
    @objc private func logoutPressed() {
        
    }
    
    @objc private func changeProfileButtonPressed() {
        
    }

}

extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.backgroundColor = UIColor(red:0.92, green:0.47, blue:0.25, alpha:1.0)
        return cell
    }
}
extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}





