//
//  SVRoomViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 17/05/2017.
//  Copyright © 2017 Survyy. Axll rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class SVRoomViewController: JSQMessagesViewController {
    
    var attendee : User?
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()

    private lazy var ref: FIRDatabaseReference! = FIRDatabase.database().reference().child("chatroom")
    private var channelRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName
        
        self.title = self.senderDisplayName + " & " + attendee!.username
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.observeConversation()
    }
    
    private func observeConversation() {
        let roomRef = ref!.child(sortedString(self.title!))
        let messageQuery = roomRef.queryLimited(toLast:25)
        
        self.channelRefHandle = messageQuery.observe(.value, with: { (snapshot) -> Void in

            if snapshot.value is NSDictionary {
                let messageData = snapshot.value as! NSDictionary
                
                if let id = messageData["senderId"] as! String!,
                   let name = messageData["senderName"] as! String!,
                   let text = messageData["text"] as! String!,
                       text.characters.count > 0 {
                
                    self.addMessage(withId: id, name: name, text: text)
                    self.finishReceivingMessage()
                }
                else {
                    print("Error! Could not decode message data")
                }
            }
        })
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        return message.senderId == senderId ? outgoingBubbleImageView : incomingBubbleImageView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        cell.textView?.textColor = message.senderId == senderId ? UIColor.white : UIColor.black
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.inputToolbar.contentView.textView.text = ""

        let roomRef = ref!.child(sortedString(self.title!))
        roomRef.setValue( [ "senderId": senderId!,
                            "senderName": senderDisplayName!,
                            "text": text! ])
        
        finishSendingMessage()
    }
    
    func sortedString(_ str : String) -> String {
        let charArray = Array(str.characters)
        return String(charArray.sorted())
    }
}
