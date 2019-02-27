//
//  VCPosting.swift
//  TwitteriOSDemo
//
//  Created by hint on 14/12/18.
//  Copyright © 2018 ZidniRyi. All rights reserved.
//

import UIKit
import Firebase

class VCPosting: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvListsPosts: UITableView!
    var ref = DatabaseReference.init()
    
    
    var UserUID: String?
    //Memanggil Object
    var listOfPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.ref = Database.database().reference()

        // Do any additional setup after loading the view.
        print("user uid \(UserUID)")
        listOfPosts.append(Post(postText: "", userUID: "@#$2@", postDate: "", postImage: ""))
        
        //Membuat datasource dan delegate
        tvListsPosts.delegate = self
        tvListsPosts.dataSource = self
        
        //memanggil fungsi dari firebase
        loadPostFromFireBase() 
    }
    //Membuat Fungsi
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = listOfPosts[indexPath.row]
        
       if (post.userUID! == "@#$2@"){
        let cellAdd = tableView.dequeueReusableCell(withIdentifier: "cellAdd", for: indexPath) as! TVCAddPost
        
        cellAdd.UserUID = self.UserUID
        cellAdd.main = self
        return cellAdd
       }else if (post.postImage == ""){
         let cellwithOutImage = tableView.dequeueReusableCell(withIdentifier: "cellWithOutPost", for: indexPath) as! TVCPostWithoutImage
        
        cellwithOutImage.setText(postText: post.postText!)
        return cellwithOutImage
        
       } else {
        let cellWithImage = tableView.dequeueReusableCell(withIdentifier: "cellWithImage", for: indexPath) as! TVCWithText
        
        cellWithImage.setText(post: post)
        return cellWithImage
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPostFromFireBase(){
        self.ref.child("Post").queryOrdered(byChild: "postDate").observe(.value, with: {
            
            (snapshoot) in
            self.listOfPosts.removeAll()
            self.listOfPosts.append(Post(postText: "", userUID: "@#$2@", postDate: "", postImage: ""))
            
            if let snapshot = snapshoot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot{
                    
                    if let postDic = snap.value as? [String:Any]{
                        var postText:String?
                        if let postTextF = postDic["text"] as? String {
                            postText = postTextF
                        }
                        ""
                        var userUID:String?
                        if let userUIDF = postDic["userUID"] as? String {
                            userUID = userUIDF
                        }
                        var postDate:String?
                        if let postDateF = postDic["postDate"] as? String {
                            postDate = postDateF
                        }
                        var postImage:String?
                        if let postImageF = postDic["imagePath"] as? String {
                            postImage = postImageF
                        }
                        
                        self.listOfPosts.append(Post(postText: postText!, userUID: self.UserUID!, postDate: "",  postImage: postImage!))
                    }
                }
                self.tvListsPosts.reloadData()
                
            }
            
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
