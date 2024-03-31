//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()

    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []

            if let e = error {
                print("There was an error retrieving data from Firestore")
            } else {
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        if let sender = data[K.FStore.senderField] as? String,                         let body = data[K.FStore.bodyField] as? String {
                            let message = Message(sender: sender, body: body)
                            self.messages.append(message)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messagebody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender, K.FStore.bodyField : messagebody, K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue pusing to firestore")
                } else {
                    print("The action was successful")
                }
            }
        }

    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let index = indexPath.row
        cell.label.text = messages[index].body
        return cell
    }
}

