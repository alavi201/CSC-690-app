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
        print(postTweet)
        
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
