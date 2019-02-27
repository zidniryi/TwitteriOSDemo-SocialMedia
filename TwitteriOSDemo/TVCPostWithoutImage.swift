//
//  TVCPostWithoutImage.swift
//  TwitteriOSDemo
//
//  Created by hint on 18/12/18.
//  Copyright © 2018 ZidniRyi. All rights reserved.
//

import UIKit

class TVCPostWithoutImage: UITableViewCell {

    @IBOutlet weak var textPostText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(postText:String){
      textPostText.text = postText
    }

}
