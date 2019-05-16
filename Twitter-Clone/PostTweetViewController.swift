//
//  PostTweetViewController.swift
//  Twitter-Clone
//
//  Created by Vipul Karanjkar on 5/10/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import UIKit

class PostTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweet: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        @IBOutlet weak var tweet: UITextView!
            // Do any additional setup after loading the view.

        // set border to the text view
        tweet.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        tweet.layer.borderWidth = 2.0;
        tweet.layer.cornerRadius = 5.0;
        
        // set placeholder and color to the text view
        tweet.text = "Enter your tweet here"
        tweet.textColor = UIColor.lightGray
        
        // add a delgate to the tweet text view
        tweet.delegate = self
    }

    // when text view is clicked, remove the placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your tweet here" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func onPostTweetClicked(_ sender: Any) {
        let postTweet: String = tweet.text!
        
        // if tweet is empty
        if (postTweet == "Enter your tweet here" || postTweet == "") {
            // need to show the required validation insted of returning to the home screen
            displayAlertMessage(messageToDisplay: "Please enter your tweet")
  
            // redirecting to the same page (not sure, if this is a correct approach)
            return self.viewDidLoad()
        }
        
        let Url = String(format: "http://127.0.0.1:8081/createPost")
        guard let serviceUrl = URL(string: Url) else { return }
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""

        let parameterDictionary = ["authToken": token,"text" :postTweet]
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

                    print(json)

                    guard let jsonArray = json as? [String: Any] else {
                        return
                    }

                    if ((token as? String) != nil) {
//                        self.tweet.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
                        
//                        self.tweet.layer.borderWidth = 2.0;
//                        self.tweet.layer.cornerRadius = 5.0;
//
                        // set placeholder and color to the text view
                        self.tweet.text = "Enter your tweet here"
                        self.tweet.textColor = UIColor.lightGray
                        
                        // add a delgate to the tweet text view
//                        self.tweet.delegate = self
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        
    }
    
    // display alert message
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let oKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            
            print("Ok button clicked")
        }
        
        alertController.addAction(oKAction)
        
        self.present(alertController, animated: true, completion: nil)
        viewDidLoad()
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
