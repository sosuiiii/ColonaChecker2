//
//  TestViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/06/10.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import RealmSwift

class ChatViewController: MessagesViewController, MessagesDataSource, MessageCellDelegate, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate{

    private var messages: [Message] = []
    private var messageText: [String] = []
    private var messageInterval: [TimeInterval] = []
    private var messageDate: [Date] = []
    let colors = Colors()
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("users").document("Message").getDocument(completion: {
            (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.get("UserMessage") ?? ["メッセージが存在しません"]
                self.messageText += dataDescription as! Array
                let timeInterval = document.get("Date") as? [Timestamp] ?? [Timestamp()]
                self.messageDate = timeInterval.map({$0.dateValue() as Date
                })
            } else {
                print("Document does not exist")
            }
            
            print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
            print(self.messages)
            DispatchQueue.main.async {
                // messageListにメッセージの配列をいれて
                self.messages = self.getMessages()
                // messagesCollectionViewをリロードして
                self.messagesCollectionView.reloadData()
                // 一番下までスクロールする
                self.messagesCollectionView.scrollToBottom()
            }
        })
        
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.contentInset.top = 70
        
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70)
        view.addSubview(uiView)
        
        uiView.addSubview(labelStatus(view.frame.size.width / 2 - 50, 20, 100, 40, text: "Doctor", size: 20, weight: .bold, color: colors.white))
        
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.tintColor = colors.white
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        uiView.addSubview(backButton)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70)
        gradientLayer.colors = [colors.bluePurple.cgColor,colors.blue.cgColor,]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        uiView.layer.insertSublayer(gradientLayer, at:0)
        
//        if let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
//            layout.setMessageIncomingAvatarSize(.zero)
//            layout.setMessageOutgoingAvatarSize(.zero)
//            layout.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)))
//            layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)))
//            layout.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)))
//            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)))
//        }
        
    }
    @objc func backButtonAction(){
        dismiss(animated: true, completion: nil)
    }
    func labelStatus(_ x: CGFloat,_ y: CGFloat,_ width: CGFloat, _ height: CGFloat,  text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.text = text
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        label.textAlignment = .center
        return label
    }
    func currentSender() -> SenderType {
        return Sender(senderId: "134", displayName: "そっしー")
    }
    func otherSender() -> SenderType {
        return Sender(senderId: "1234", displayName: "そっしー")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func getMessages() -> [Message] {
        var messageArray:[Message] = []
        for i in 0..<messageText.count {
            
            messageArray.append(createMessage(text: messageText[i], date: messageDate[i]))
        }
        return messageArray
    }
    var token = true
    func createMessage(text: String, date: Date) -> Message {
        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                           .foregroundColor: UIColor.white])
        token = Bool.random()
        if token {
            return Message(attributedText: attributedText, sender: otherSender() as! Sender, messageId: UUID().uuidString, date: date)
        } else {
            return Message(attributedText: attributedText, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: date)
        }
        
    }
    // メッセージの上に文字を表示
//    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if indexPath.section % 4 == 0 {
//            return NSAttributedString(
//                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
//                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
//                             NSAttributedString.Key.foregroundColor: UIColor.darkGray]
//            )
//        }
//        return nil
//    }
    // メッセージの下に文字を表示（日付）
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    //MARK:- MessagesDisplayDelegate
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .white
    }
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? colors.blueGreen : colors.redOrange
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
       let avatar: Avatar
        avatar = Avatar(image: UIImage(named: isFromCurrentSender(message: message) ? "virus2": "virus"))
       avatarView.set(avatar: avatar)

    }
    //MARK: -MessagesLayoutDelegate
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 { return 10 }
        return 0
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    
    //MARK: -MessageCellDelegate
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    //MARK: -MessageInputBarDelegate
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("send tapped")
        for component in inputBar.inputTextView.components {
            if let image = component as? UIImage {

                let imageMessage = Message(image: image, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messages.append(imageMessage)
                messagesCollectionView.insertSections([messages.count - 1])
            } else if let text = component as? String {

                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                                   .foregroundColor: UIColor.white])
                let message = Message(attributedText: attributedText, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messages.append(message)
                messagesCollectionView.insertSections([messages.count - 1])
                messageText.append(text)
                messageInterval.append(Date().timeIntervalSince1970)
                messageDate.append(Date())
                fire(message: messageText)
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
    func fire(message: [String]) {
        Firestore.firestore().collection("users").document("Message").setData([
            "UserMessage": message,
            "Date": messageDate
            
        ],merge: false) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    func messageInputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("Send tapped")
        for component in inputBar.inputTextView.components {
            if let image = component as? UIImage {

                let imageMessage = Message(image: image, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messages.append(imageMessage)
                messagesCollectionView.insertSections([messages.count - 1])

            } else if let text = component as? String {

                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                                   .foregroundColor: UIColor.white])
                let message = Message(attributedText: attributedText, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messages.append(message)
                messagesCollectionView.insertSections([messages.count - 1])
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
}

