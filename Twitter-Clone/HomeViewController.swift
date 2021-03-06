//
//  HomeViewController.swift
//  Twitter-Clone
//
//  Created by Vipul Karanjkar on 4/27/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var logOut: UIImageView!
    @IBOutlet weak var welcomeMsg: UILabel!
    @IBOutlet weak var postList: UITableView!


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = self.posts[indexPath.row].username + ": " + self.posts[indexPath.row].text
        return cell
    }
    
    struct Post {
        var username: String
        var uuid: String
        var text: String
        var createdAt: String
        init(_ dictionary: [String: Any]) {
            self.username = dictionary["username"] as? String ?? ""
            self.uuid = dictionary["uuid"] as? String ?? ""
            self.text = dictionary["text"] as? String ?? ""
            self.createdAt = dictionary["created_at"] as? String ?? ""
        }
    }
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get username from UserDefaults
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        welcomeMsg.text = "Welcome " + username
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        self.logOut.isUserInteractionEnabled = true
        self.logOut.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // logout function
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let Url = String(format: "http://127.0.0.1:8081/logout")
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
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if ((token as? String) != nil) {
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "username")
                        self.performSegue(withIdentifier: "logout", sender: nil)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()        
    }

    // to refresh posts
    override func viewDidAppear(_ animated: Bool) {
        populatePosts(input: "") {
            (result: String) in
            self.postList.delegate = self
            self.postList.dataSource = self
            self.postList.register(UITableViewCell.self, forCellReuseIdentifier: "customcell")
            self.postList.reloadData()
        }
    }
    
    // displays post on home screen
    func populatePosts(input: String, completion: @escaping (_ result: String) -> Void) {
        let Url = String(format: "http://127.0.0.1:8081/getFollowedPosts")
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
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonArray = jsonResponse as? [[String: Any]] else {
                        return
                    }
                    
                    self.posts.removeAll()
                    for dic in jsonArray{
                        self.posts.append(Post(dic))
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
}
