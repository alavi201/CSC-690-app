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
            self.imageView.image = galleryImage
            self.uploadImage(paramName: "image", fileName: "DP", image: galleryImage)
            /* get your image here */
        }
    }
    
    func uploadImage(paramName: String, fileName: String, image: UIImage) {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let url = URL(string: "http://127.0.0.1:8081/createProfile")
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        let session = URLSession.shared
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"authToken\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(token)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
    
}
