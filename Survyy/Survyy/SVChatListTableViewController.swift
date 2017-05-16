//
//  SVChatListTableViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SVChatListTableViewController: UITableViewController {

    private lazy var ref: FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    private var channelRefHandle: FIRDatabaseHandle?

    let cellReuseIdentifier = "cell"
    var listOfUsers : [String] = []
    
    deinit {
        ref.removeObserver(withHandle: channelRefHandle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAccount))
        
        self.updateNameTextField()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        
        channelRefHandle = self.ref.observe(.value, with: { (snapshot) -> Void in
            // Get user value
            for (_, v) in snapshot.value as! NSDictionary {
                if v is NSDictionary {
                    
                    let dic = v as! NSDictionary
                    let str = dic.value(forKey: "username") as! String
                    
                    if (!self.listOfUsers.contains(str)) {
                        self.listOfUsers.append(str)
                    }
                }
                
                self.listOfUsers = self.listOfUsers.sorted { $0 < $1 }
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateNameTextField() {
        self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.title = value?["username"] as? String ?? FIRAuth.auth()?.currentUser?.email
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func logOut() {
        SVLoginManager.shared.signOut()
        self.navigationController?.popViewController(animated: false)
    }
    
    func editAccount() {
        
    }
    
// MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
    
        cell.textLabel?.text = self.listOfUsers[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    @IBAction func send(_ sender: Any) {
//        self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(["username": nameTextfield.text])
//        
//        self.updateNameTextField()
//    }
//
}
