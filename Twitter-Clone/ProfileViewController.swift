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
    @IBOutlet weak var welcomeMsg: UILabel!
    
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var usernameDisplay: UILabel!
    struct User {
        var username: String = ""
        var imageUrl: String = ""
        var dob: String = ""
        init(){}
        init(_ dictionary: [String: Any]) {
            self.username = dictionary["username"] as? String ?? ""
            self.imageUrl = dictionary["image_url"] as? String ?? ""
            self.dob = dictionary["dob"] as? String ?? ""
        }
    }
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get username
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        
        welcomeMsg.text = "Welcome " + username

        
        fetchProfile(input: "") {
            (result: String) in
            self.usernameDisplay.text = "Welcome back " + self.currentUser.username
            guard let url = URL(string: self.currentUser.imageUrl) else { return }
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                let currentImage = UIImage(data: imageData)
                self.imageView.image = currentImage
            }
        }
        
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
    
    func fetchProfile(input: String, completion: @escaping (_ result: String) -> Void) {
        let Url = String(format: "http://127.0.0.1:8081/getProfile")
        guard let serviceUrl = URL(string: Url) else { return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let parameterDictionary = ["authToken": token]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) {
            
            (data, response, error) in
            if response != nil {
            }
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonArray = jsonResponse as? [[String: Any]] else {
                        return
                    }
                    //print(jsonArray)
                    for dic in jsonArray{
                        self.currentUser = User(dic)
                    }
                    completion("")
                } catch {
                    print(error)
                    completion("")
                }
            }
        }
        
        task.resume()
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
