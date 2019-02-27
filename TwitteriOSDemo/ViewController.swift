//
//  ViewController.swift
//  TwitteriOSDemo
//
//  Created by hint on 12/12/18.
//  Copyright © 2018 ZidniRyi. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var txtFullName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var iv_userImage: UIImageView!
    var imagePicker: UIImagePickerController!
    var ref = DatabaseReference.init()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buPickImage(_ sender: Any) {
        
    }
    //Membuat fungsi untuk imagepickerviewcontroller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let images = info[UIImagePickerControllerOriginalImage] as? UIImage{
            iv_userImage.image = images
            
          
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    var UserUID:String?
    @IBAction func buLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!){
            (user,error) in
            //Tulisnya tuh di sini
            if let error = error{
                print(error)
            }else{
                let user = Auth.auth().currentUser
                print("User id \(user?.uid)")
                self.UserUID = user?.uid
                self.GotPosting()
                
                
            }
        }
    }
    
    @IBAction func buRegister(_ sender: Any) {
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!){
             (user,error) in
            
            //Tulisnya tuh di sini
            if let error = error{
                print(error)
            }else{
                let user = Auth.auth().currentUser
                print("User id \(user?.uid)")
                self.UserUID = user?.uid

                self.uploadUserImage()
                self.GotPosting()
            }
    
        }
        
        
    }
    
    func SaveToFirebaseDatabase(UserImagePath: String, UserName: String){
        let msg = ["fullName": UserName,
                   "UserImagePath": UserImagePath]
        
        self.ref.child("Users").child(self.UserUID!).setValue(msg )
    }
    
    func uploadUserImage(){
        // Upload move to here
        //Upload Images Ke FireBase
        let image:UIImage = iv_userImage.image!
        let storaegRef = Storage.storage().reference(forURL: "gs://myiosapps-7b24e.appspot.com/")
        var data = NSData()
        data = UIImageJPEGRepresentation(image, 0.8) as! NSData
        let dataformat = DateFormatter()
        dataformat.dateFormat = "MM_DD_yy_h_mm_a"
        //(self.UserUID) Untuk setiap user yang berbeda
        let imageName = "\(self.UserUID!)_ \(dataformat.string(from: NSDate() as Date))"
        
        //Upload ke firebase berdasarkan path yang telah dibuat sebelumnya
        let imagepath = "UsersImages/\(imageName).jpg"
        let childUserImages = storaegRef.child(imagepath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        //Upload data
        childUserImages.putData(data as Data, metadata: metaData)
        
        //Menyimpan database
        self.SaveToFirebaseDatabase(UserImagePath: imagepath, UserName:  txtFullName.text!)
        
    }
    func GotPosting(){
        
        performSegue(withIdentifier: "ShowPosts", sender: self.UserUID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPosts" {
            if let vcposting = segue.destination as? VCPosting{
                if let UserUID = sender as? String {
                    vcposting.UserUID = UserUID
                }
            }
        }
    }
    
}

