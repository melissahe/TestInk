//
//  PostServiceDelegate.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

protocol DesignPostDelegate: class {
    //adding design post methods
    func didAddDesignPostToFirebase(_ postService: FirebaseDesignPostService, user: DesignPost)
    func failedToAddDesignPostToFirebase(_ postService: FirebaseDesignPostService, error: Error)
    
    //getting all design post methods
    func didGetAllDesignPosts(_ postService: FirebaseDesignPostService, user: DesignPost)
    func failedToGetAllDeignPosts(_ postService: FirebaseDesignPostService, error: Error)
}


protocol PreviewPostDelegate: class {
    //adding preview posts methods
    func didAddPreviewPostToFirebase(_ postService: FirebasePreviewPostService, user: PreviewPost)
    func failedToAddDesignPostToFirebase(_ postService: FirebaseDesignPostService, error: Error)
    
    //getting all preview posts methods
    func didGetAllPreviewPosts(_ postService: FirebasePreviewPostService, user: PreviewPost)
    func failedToGetAllDeignPosts(_ postService: FirebaseDesignPostService, error: Error)
}

