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
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])

                    guard let jsonArray = json as? [String: Any] else {
                        return
                    }
                    
                    if jsonArray["authToken"] != nil {
                        
                       
                            // set username and authToken in user defaults (permant data storage)
                        let token = jsonArray["authToken"] as! String
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.set(token, forKey: "token")
                            
                            self.performSegue(withIdentifier: "signIn", sender: nil)
                        
                    }
                    else {
                        self.displayAlertMessage(messageToDisplay: "Invalid username or password")
                    }

                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func onSignUpClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "signUpView", sender: nil)
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let oKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
        }
        
        alertController.addAction(oKAction)
        
        self.present(alertController, animated: true, completion: nil)
        viewDidLoad()
    }
}
