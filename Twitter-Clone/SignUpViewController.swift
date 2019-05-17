//
//  SignUpViewController.swift
//  Twitter-Clone
//
//  Created by Vipul Karanjkar on 4/27/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var dob: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUpClicked(_ sender: Any) {
        let username: String = userName.text!
        let pass: String = password.text!
        
        let Url = String(format: "http://127.0.0.1:8081/register")
        guard let serviceUrl = URL(string: Url) else { return }

        let dateFormatter = DateFormatter()
        // we specify the display format, e.g. "27-08-2015
        dateFormatter.dateFormat = "YYYY-MM-dd"
        // we get the date from the UIDatePicker and convert it to a string
        let dateOfBirth = dateFormatter.string(from: dob.date)

//        print("Dob: " + dateOfBirth)
        
        let parameterDictionary = ["username" :username, "password" : pass, "dob":dateOfBirth]
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
//            if let response = response {
////                print(response)
//            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                                        print(json)
                    
                    guard let jsonArray = json as? [String: Any] else {
                        return
                    }
                  
//                       print(jsonArray)
                    
                    // get authToken
                    guard let token = jsonArray["authToken"] as? String else { return }
//                        print(token)
                    
                    if ((token as? String) != nil) {                        
                        // set username and authToken in user defaults (permant data storage)
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(token, forKey: "token")

                        self.performSegue(withIdentifier: "signUp", sender: nil)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        task.resume()
        
    }
    
    
    @IBAction func onSignInClicked(_ sender: Any) {
        
        
    }
    
}
