//
//  SVChatTableViewController.swift
//  ChatFirebase
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 ChatFirebase. All rights reserved.
//

import UIKit
import Firebase

struct User {
    let username : String
    let avatar : String
    let email : String
}

class SVChatTableViewController: UITableViewController {
    
    let kShowRoomSegue = "ShowRoomSegue"

    private lazy var usersRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    private var usersChannelRefHandle: FIRDatabaseHandle?
    private lazy var chatRef: FIRDatabaseReference! = FIRDatabase.database().reference().child("chatroom")
    private var chatChannelRefHandle: FIRDatabaseHandle?

    let cellReuseIdentifier = "cell"
    var listOfUsers : [User] = []
    var lastMessages : Dictionary<String, String> = [:]

    deinit {
        usersRef.removeObserver(withHandle: usersChannelRefHandle!)
        chatRef.removeObserver(withHandle: chatChannelRefHandle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAccount))
        
        self.title = SVLoginManager.shared.username
        
        self.observeListOfUsers()
    }
    
    func observeListOfUsers() {
        self.usersChannelRefHandle = self.usersRef.observe(.childAdded, with: { (snapshot) -> Void in
            // Get user value
            if snapshot.value is NSDictionary {
                
                let dic = snapshot.value as! NSDictionary
                let username = dic.value(forKey: "username") as! String
                let avatar = dic.value(forKey: "avatar") as! String
                let email = dic.value(forKey: "email") as! String
                
                if (SVLoginManager.shared.email != dic.value(forKey: "email") as! String) {
                    self.listOfUsers.append(User.init(username: username, avatar: avatar, email: email))
                }
            }
            
            self.listOfUsers = self.listOfUsers.sorted { $0.username < $1.username }
            self.observeLastMessages()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func observeLastMessages()  {
        self.chatChannelRefHandle = chatRef.observe(.value, with: { (snapshot) -> Void in
            if snapshot.value is NSDictionary {
                let v = snapshot.value as! NSDictionary
                
                for i in 0..<self.listOfUsers.count {
                    let str = self.sortedString(self.listOfUsers[i].username + " & " + self.title!)
                    if (v.allKeys as! Array<String>).contains(str) {
                        let lastMessage : String = ((v.value(forKey: str) as! NSDictionary).allValues.last as! NSDictionary).allValues.last as! String
                        self.lastMessages[self.listOfUsers[i].username] = lastMessage
                        self.listOfUsers.insert(self.listOfUsers.remove(at: i), at: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func logOut() {
        SVLoginManager.shared.signOut()
        self.navigationController?.popViewController(animated: false)
    }
    
    func editAccount() {
        
    }
    
    func sortedString(_ str : String) -> String {
        let charArray = Array(str.characters)
        return String(charArray.sorted())
    }
    
// MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)

        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        }
    
        cell!.textLabel?.text = self.listOfUsers[indexPath.row].username
        
        if self.lastMessages.keys.contains(self.listOfUsers[indexPath.row].username) {
            cell!.detailTextLabel?.text = self.lastMessages[self.listOfUsers[indexPath.row].username]
            cell!.detailTextLabel?.textColor = UIColor.black
        } else {
            cell!.detailTextLabel?.text = "This conversation is empty"
            cell!.detailTextLabel?.textColor = UIColor.lightGray
        }
        
        cell!.imageView?.image = UIImage.init(named: self.listOfUsers[indexPath.row].avatar)
        cell!.imageView?.contentMode = .scaleAspectFit
        cell!.imageView?.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)

        cell!.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
// MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: kShowRoomSegue, sender: self.listOfUsers[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowRoomSegue  {
            let roomVC : SVRoomViewController = segue.destination as! SVRoomViewController
            roomVC.attendee = sender as? User
        }
    }
}
