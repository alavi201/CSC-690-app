// IMAGE SELECTOR
//  HomeViewController.swift
//  Twitter-Clone
//
//  Created by Vipul Karanjkar on 4/27/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var welcomeText: UILabel!
    
    @IBOutlet weak var uploadImage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let defaults = UserDefaults.standard
        //welcomeText.text = defaults.object(forKey: "username") as? String
        
        // Do any additional setup after loading the view.
    }
    @IBAction func clickCamera(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (galleryImage) in
            print(galleryImage)
            self.imageView.image = galleryImage
            /* get your image here */
        }
    }
    
    
    @IBAction func clickUploadImg(_ sender: Any) {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
