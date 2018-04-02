//
//  LikeServiceDelegate.swift
//  TestInk
//
//  Created by C4Q on 3/29/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

protocol LikeServiceDelegate: class {
    //Methods to handle favoriting functionality
    func didUnfavoritePost(_ service: FirebaseLikingService, withPostID: String)
    func didFavoritePost(_ service: FirebaseLikingService, withPostID: String)
    func didFailFavoritingPost(_ service: FirebaseLikingService, error: String)
}
