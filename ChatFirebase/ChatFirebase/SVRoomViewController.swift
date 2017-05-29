//
//  SVRoomViewController.swift
//  ChatFirebase
//
//  Created by Guillermo Delgado on 17/05/2017.
//  Copyright © 2017 ChatFirebase. Axll rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class SVRoomViewController: JSQMessagesViewController {

    var attendee: User?
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()

    var lastMasage = [AnyHashable: Any]()

    private lazy var ref: DatabaseReference! = Database.database().reference().child("chatroom")
    private lazy var lastRecRef: DatabaseReference! = Database.database().reference().child("chatRecords")

    private var channelRefHandle: DatabaseHandle?

    deinit {
        ref.removeAllObservers()
        lastRecRef.removeAllObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId = Auth.auth().currentUser?.uid
        self.senderDisplayName = Auth.auth().currentUser?.displayName

        self.title = self.senderDisplayName + " & " + attendee!.username

        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

        lastRecRef!.child(sortedString(self.title!)).observe(.value, with: { (snapshot) in
            // Get value
            if let value = snapshot.value as? [AnyHashable: Any] {
                self.lastMasage = value
                self.collectionView.reloadData()
            }
        })

        self.observeConversation()
    }

    private func observeConversation() {
        let roomRef = ref!.child(sortedString(self.title!))
        let messageQuery = roomRef.queryLimited(toLast:25)

        self.channelRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in

            guard snapshot.value is NSDictionary,
                  let messageData = snapshot.value as? NSDictionary,
                  let id = messageData["senderId"] as? String!,
                  let name = messageData["senderName"] as? String!,
                  let text = messageData["text"] as? String!,
                  text.characters.count > 0 else {
                    print("Error! Could not decode message data")
                    return
            }

            self.addMessage(withId: id, name: name, text: text)
            self.finishReceivingMessage()
        })
    }

    private func addMessage(withId idString: String, name: String, text: String) {
        if let message = JSQMessage(senderId: idString, displayName: name, text: text) {
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

    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAt indexPath: IndexPath!)
        -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        return message.senderId == senderId ? outgoingBubbleImageView: incomingBubbleImageView
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = super.collectionView(collectionView,
                                              cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell else {
            return UICollectionViewCell.init()
        }

        let message = messages[indexPath.item]

        let isMyMessage: Bool = message.senderId == senderId
        cell.textView?.textColor = isMyMessage ? UIColor.white: UIColor.black

        if let lastMsg = self.lastMasage["lastRecord"] as? String,
           lastMsg == message.text,
           !isMyMessage {
            self.updateLastMessage(lastMsg, isRead: true)
        }

        return cell
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    override func didPressSend(_ button: UIButton!,
                               withMessageText text: String!,
                               senderId: String!,
                               senderDisplayName: String!,
                               date: Date!) {
        self.inputToolbar.contentView.textView.text = ""

        let roomRef = ref!.child(sortedString(self.title!)).childByAutoId()

        roomRef.setValue( [ "senderId": senderId!,
                            "senderName": senderDisplayName!,
                            "date": Date().toString(),
                            "text": text! ])

        finishSendingMessage()
        self.updateLastMessage(text!, isRead: false)
    }

    func sortedString(_ str: String) -> String {
        let charArray = Array(str.characters)
        return String(charArray.sorted())
    }

    func updateLastMessage(_ text: String, isRead read: Bool) {
        self.lastMasage = ["lastRecord": text, "read": read]
        lastRecRef!.child(sortedString(self.title!)).updateChildValues(self.lastMasage)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
