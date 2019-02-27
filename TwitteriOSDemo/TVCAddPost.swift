//
//  TVCAddPost.swift
//  TwitteriOSDemo
//
//  Created by hint on 17/12/18.
//  Copyright © 2018 ZidniRyi. All rights reserved.
//

import UIKit
import Firebase

class TVCAddPost: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var txtPostText: UITextView!
    //untuk inisialisasi
    var ref = DatabaseReference.init()
    var UserUID:String?
    var imagePath:String = "no image"
    //browse img
    var imagePicker: UIImagePickerController!
    var main:VCPosting? 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func buAttachImage(_ sender: Any) {
        // to brose img 2 
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // method to select img
        main!.present(imagePicker, animated: true, completion: nil)
    }
    
    //Membuat fungsi untuk imagepickerviewcontroller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let images = info[UIImagePickerControllerOriginalImage] as? UIImage{
            uploadUserImage(image: images)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // upload gambarkeserver
    
    func uploadUserImage(image:UIImage){
        // Upload move to here
        //Upload Images Ke FireBase
        let storaegRef = Storage.storage().reference(forURL: "gs://myiosapps-7b24e.appspot.com/")
        var data = NSData()
        data = UIImageJPEGRepresentation(image, 0.8) as! NSData
        let dataformat = DateFormatter()
        dataformat.dateFormat = "MM_DD_yy_h_mm_a"
        //(self.UserUID) Untuk setiap user yang berbeda
        let imageName = "\(self.UserUID!)_ \(dataformat.string(from: NSDate() as Date))"
        
        //Upload ke firebase berdasarkan path yang telah dibuat sebelumnya
        self.imagePath = "UsersPosts/\(imageName).jpg"
        let childUserImages = storaegRef.child(self.imagePath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        //Upload data
        childUserImages.putData(data as Data, metadata: metaData)
        
    }
    @IBAction func buPost(_ sender: Any) {
        
        ref = Database.database().reference()
        var postMSG = ["UserUID":UserUID!, "text":txtPostText.text!, "imagePath":imagePath, "postDate":ServerValue.timestamp() ] as [String : Any]
        ref.child("Post").childByAutoId().setValue(postMSG)
        imagePath = "no image"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
