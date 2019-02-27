//
//  Post.swift
//  TwitteriOSDemo
//
//  Created by hint on 17/12/18.
//  Copyright © 2018 ZidniRyi. All rights reserved.
//

import UIKit

class Post {
    var postText: String?
    var userUID: String?
    var postDate: String?
    var postImage: String?
    
    init(postText: String, userUID: String, postDate: String, postImage: String ) {
        self.postText=postText
        self.userUID=userUID
        self.postDate=postDate
        self.postImage=postImage
    }
    

}
