//
//  ViewController.swift
//  Twitter-Clone
//
//  Created by Vipul Karanjkar on 4/14/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onSignInClicked(_ sender: Any) {
        
        let username: String = userName.text!
        let pass: String = password.text!
    
        let Url = String(format: "http://127.0.0.1:8081/login")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["username" :username, "password" : pass]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) {

        (data, response, error) in
            if let response = response {
//                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
//                    print(json)
                    
                    guard let jsonArray = json as? [String: Any] else {
                        return
                    }
//                    print(jsonArray)

                    //Now get authToken
                    guard let token = jsonArray["authToken"] as? String else { return }

//                    print(token)
                    if ((token as? String) != nil) {
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                    }
                } catch {
                    print(error)
                }
            }
            }

        task.resume()
    }
    
    
    @IBAction func onSignUpClicked(_ sender: Any) {
    }
}
