//
//  SearchViewController.swift
//  Twitter-Clone
//
//  Created by Vipul Karanjkar on 5/11/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var welcomeMsg: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    var results = [[String:Any]]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get username
        let username = UserDefaults.standard.string(forKey: "username") ?? ""

        welcomeMsg.text = "Welcome " + username

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 50
    }

    // to search for a user name
    @IBAction func onSearchButtonClicked(_ sender: Any) {
        let search: String = searchBar.text!
        
        // if search is empty
        if (search == "") {
            displayAlertMessage(messageToDisplay: "Please Enter User Name")
            
            // redirecting to the same page (not sure, if this is a correct approach)
            return self.viewDidLoad()
        }
        
        let Url = String(format: "http://127.0.0.1:8081/search")
        guard let serviceUrl = URL(string: Url) else { return }
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let parameterDictionary = ["authToken": token,"query" :search]
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
                    
                    let users = jsonArray["users"] as? [[String:Any]]
                    
                    if (users!.count > 0 ) {
                        // if users exists
                        self.results = users!
                        self.tableView.reloadData()
                    } else {
                        self.displayAlertMessage(messageToDisplay: "No Results Found!")
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchCell
        let result = self.results[indexPath.row]
        var username = result["username"] as! String
        let followers = result["followed"] as! Int
        let imageURL = result["image_url"] as! String
        
        let data = NSData(contentsOf: NSURL(string: imageURL)! as URL)
        let image = UIImage(data: data! as Data)
        
        if (followers == 1 ) {
            // when follows another user
            username = "\(username)"
//
//            DispatchQueue.main.async(execute: {
//                cell.cellImage.image = image
//            })
            cell.cellImage.image = image
            cell.cellButton.setTitle("Unfollow",for: .normal)
            cell.cellButton.backgroundColor = UIColor.red
        } else {
            // when unfollows another user
            username = "\(username)"
//
//            DispatchQueue.main.async(execute: {
//                cell.cellImage.image = image
//            })
            cell.cellImage.image = image
            cell.cellButton.setTitle("Follow",for: .normal)
            cell.cellButton.backgroundColor = UIColor.blue
        }
        
        cell.cellText.text! = username
        return cell
    }

    // when either of the cell is clicked --> follow/unfollow calls
    @IBAction func buttonClicked(_ sender: Any) {
        let from = sender as AnyObject
        let type = from.titleLabel!.text!
        let cell = from.superview?.superview as! SearchCell
        let indexPath = tableView.indexPath(for:cell)
        let indexTarget = indexPath?.row
        let user = results[indexTarget!]
        let userId = user["id"]

        if (type == "Unfollow") {
            print("Unfollow User: Unfollow -> Follow")
        
            let Url = String(format: "http://127.0.0.1:8081/unfollowUser")
            guard let serviceUrl = URL(string: Url) else { return }
        
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            let parameterDictionary = ["authToken": token,"unfollowUserId" :userId]
        
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
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                        print(json)
                    
                        cell.cellButton.setTitle("Follow",for: .normal)
                        cell.cellButton.backgroundColor = UIColor.blue
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
            self.tableView.reloadData()
        } else {
            print("Follow User: Follow -> Unfollow")
            
            let Url = String(format: "http://127.0.0.1:8081/followUser")
            guard let serviceUrl = URL(string: Url) else { return }
            
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            let parameterDictionary = ["authToken": token,"followUserId" :userId]
            
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
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        print(json)
                        cell.cellButton.setTitle("Unollow",for: .normal)
                        cell.cellButton.backgroundColor = UIColor.red
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
            self.tableView.reloadData()
        }
    }
    
    // display alert message --> could be a modular function
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let oKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            
            print("Ok Button Clicked")
        }
        
        alertController.addAction(oKAction)
        
        self.present(alertController, animated: true, completion: nil)
        viewDidLoad()
    }
}
