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
    let username: String
    let avatar: String
    let email: String
}

class SVChatTableViewController: UITableViewController {

    let kShowRoomSegue = "ShowRoomSegue"

    private lazy var usersRef: DatabaseReference! = Database.database().reference().child("users")
    private var usersChannelRefHandle: DatabaseHandle?
    private lazy var chatRecordsRef: DatabaseReference! = Database.database().reference().child("chatRecords")
    private var chatRecordsRefHandle: DatabaseHandle?

    let cellReuseIdentifier = "cell"
    var listOfUsers: [User] = []
    var lastMessages: NSDictionary = NSDictionary()

    deinit {
        usersRef.removeObserver(withHandle: usersChannelRefHandle!)
        chatRecordsRef.removeObserver(withHandle: chatRecordsRefHandle!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                 target: self,
                                                                 action: #selector(editAccount))
        self.title = SVLoginManager.shared.username ?? ""
        self.observeListOfUsers()
        self.observeLastMessages()
    }

    func observeListOfUsers() {
        self.usersChannelRefHandle = self.usersRef.observe(.childAdded, with: { (snapshot) -> Void in
            // Get user value
            if snapshot.value is NSDictionary,
                let dic = snapshot.value as? NSDictionary,
                let username = dic.value(forKey: "username") as? String,
                let avatar = dic.value(forKey: "avatar") as? String,
                let email = dic.value(forKey: "email") as? String {

                if SVLoginManager.shared.email != dic.value(forKey: "email") as? String {
                    self.listOfUsers.append(User.init(username: username, avatar: avatar, email: email))
                }
            }

            self.listOfUsers = self.listOfUsers.sorted { $0.username < $1.username }
            self.tableView.reloadData()

        }) { (error) in
            print(error.localizedDescription)
        }
    }

    private func observeLastMessages() {
        self.chatRecordsRefHandle = chatRecordsRef.observe(.value, with: { (snapshot) -> Void in

            if snapshot.value is NSDictionary,
               let dic = snapshot.value as? NSDictionary {

                self.lastMessages = dic
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

    func sortedString(_ str: String) -> String {
        let charArray = Array(str.characters)
        return String(charArray.sorted())
    }

// MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)

        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        }

        cell!.textLabel?.text = self.listOfUsers[indexPath.row].username

        let keyStr = self.sortedString(self.title! + " & " + self.listOfUsers[indexPath.row].username)

        if let value: NSDictionary = self.lastMessages.value(forKey: keyStr) as? NSDictionary,
           let lastMsg: String = value.value(forKey:"lastRecord") as? String {

            cell!.detailTextLabel?.text = lastMsg
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
        if segue.identifier == kShowRoomSegue {
            if let roomVC: SVRoomViewController = segue.destination as? SVRoomViewController {
                roomVC.attendee = sender as? User
            }
        }
    }
}

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm"
        return dateFormatter.date(from: self)!
    }
}
