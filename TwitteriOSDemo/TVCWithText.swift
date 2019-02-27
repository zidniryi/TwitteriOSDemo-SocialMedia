//
//  TVCWithText.swift
//  TwitteriOSDemo
//
//  Created by hint on 18/12/18.
//  Copyright © 2018 ZidniRyi. All rights reserved.
//

import UIKit
import Firebase

class TVCWithText: UITableViewCell {

    @IBOutlet weak var textPostText: UITextView!
    
    @IBOutlet weak var iv_postImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setText(post:Post){
        textPostText.text = post.postText!
        let url = post.postImage!
    }
    
    func setImage(url:String){
        //from url firebase storage we have
        let storageref = Storage.storage().reference(forURL: "gs://myiosapps-7b24e.appspot.com")
        let postImageRef = storageref.child(url)
        postImageRef.getData(maxSize: 8 * 1024 * 1024) {
            data, error in
            
            if let error = error{
                print("tidak bisa ambil gambar")
            }else{
                self.iv_postImage.image = UIImage(data: data!)
                
            }
        }
    }
}
