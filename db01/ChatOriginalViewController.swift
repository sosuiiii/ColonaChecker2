//
//  TestViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/06/10.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChatOriginalViewController: UIViewController, UITextViewDelegate {
    
    var firestore = Firestore.firestore()
    var chatView = UIView()
    let colors = Colors()
    let field = UITextView()
    var launch = 1
    var message = [
        "$私はドクターです\n症状にお困りの際は\nご相談ください。",
        "37.5度以上の熱が \n3日続いています。\nだるさがあります。",
        "$発熱にともない、\n喉の痛みや味覚、嗅覚に\n違和感はありますか？",
        "今のところ違和感はありません。",
        "$安静にして、\nもう数日様子を\n見てみましょう。"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "send"), for: .normal)
        backButton.tintColor = colors.blueGreen
        backButton.frame = CGRect(x: view.frame.size.width - 90, y: 10, width: 30, height: 40)
        backButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        chatView.addSubview(backButton)
        
        view.addSubview(labelStatus(view.frame.size.width / 2 - 50, 15, 100, 40, text: "Doctor", size: 20, weight: .bold, color: colors.white))
        
        
        field.delegate = self
//        field.returnKeyType = .done
        field.resignFirstResponder()
        field.layer.cornerRadius = 20
        field.textContainer.maximumNumberOfLines = 3
        field.frame = CGRect(x: 15, y: 5, width: view.frame.size.width - 110, height: 50)
        chatView.addSubview(field)
        
        view.backgroundColor = colors.white
        chatView.frame = CGRect(x: 20, y: view.frame.size.height - 110, width: view.frame.size.width - 40, height: 60)
        chatView.backgroundColor = .white
        chatView.layer.cornerRadius = 30
        chatView.layer.shadowColor = colors.black.cgColor
        chatView.layer.shadowOffset = CGSize(width: 0, height: 1)
        chatView.layer.shadowRadius = 30
        chatView.layer.shadowOpacity = 0.3
        view.addSubview(chatView)
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70)
        gradientLayer.colors = [colors.bluePurple.cgColor,colors.blue.cgColor,]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        view.layer.insertSublayer(gradientLayer, at:0)
        
        var first = true
        var line:CGFloat = 0
        var heightFix:CGFloat = 0
        var sumHeihgt:CGFloat = 10
        for i in 0..<message.count {
            let m = message[i]
            line = linesCount(string: m)
            heightFix = line * 25 + 10
            if first {
                sumHeihgt += 80
                first = false
            } else {
                sumHeihgt += 10
            }
            
            if m.prefix(1) == "$" {
                view.addSubview(labelView(10, sumHeihgt, 300, heightFix, color: colors.redOrange, text: String(m.suffix(m.count - 1)), line: line, doctor: true))
            } else {
                view.addSubview(labelView(view.frame.size.width - 310, sumHeihgt, 300, heightFix, color: colors.blueGreen, text: m, line: line, doctor: false))
            }
            sumHeihgt += heightFix
        }
        view.bringSubviewToFront(chatView)

        // Do any additional setup after loading the view.
    }
    @objc func sendButtonAction(){
        
        if field.text != "" {
            if message.count == 5 {
                message.remove(at: 0)
            }
            message.append(field.text)
        }
        view.endEditing(true)
        field.text = ""
        
        launch += 1
        loadView()
        viewDidLoad()
    }
    func labelStatus(_ x: CGFloat,_ y: CGFloat,_ width: CGFloat, _ height: CGFloat,  text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.text = text
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        label.layer.opacity = 0
        label.textAlignment = .center
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseIn], animations: {
            label.layer.opacity = 1
        }, completion: nil)
        return label
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        field.resignFirstResponder()
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveLinear], animations: {
            self.chatView.frame = CGRect(x: 20, y: self.view.frame.size.height - 110, width: self.view.frame.size.width - 40, height: 60)
        }, completion: nil)
        view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        var heightFix:CGFloat = 330
        if launch >= 2 {
            heightFix = 370
        }
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveLinear], animations: {
            self.chatView.frame = CGRect(x: 20, y: self.view.frame.size.height - heightFix, width: self.view.frame.size.width - 40, height: 60)
        }, completion: nil)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        field.resignFirstResponder()
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveLinear], animations: {
            self.chatView.frame = CGRect(x: 20, y: self.view.frame.size.height - 110, width: self.view.frame.size.width - 40, height: 60)
        }, completion: nil)
        view.endEditing(true)
    }
    func labelView(_ x:CGFloat, _ y:CGFloat, _ width:CGFloat, _ height:CGFloat, color:UIColor, text:String, line: CGFloat, doctor:Bool) -> UIView{
        
        let labelView = UIView()
        labelView.frame = CGRect(x: x, y: y, width: width, height: height)
//        labelView.backgroundColor = color
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        if color == colors.redOrange {
            gradientLayer.colors = [colors.redOrange.cgColor,colors.orange.cgColor,]
        } else {
            gradientLayer.colors = [colors.blue.cgColor,colors.blueGreen.cgColor,]
        }
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        if doctor {
            gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
            labelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        } else {
            gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            labelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
        }
        labelView.layer.cornerRadius = 10
        gradientLayer.cornerRadius = 10
        view.addSubview(labelView)
        view.layer.insertSublayer(gradientLayer, at:0)
        
        let label = UILabel()
        label.numberOfLines = Int(line)
        label.frame = CGRect(x: 10, y: 10, width: width - 30, height: height - 20)
        label.text = text
        if !doctor {
            label.textAlignment = .right
        }
        label.textColor = colors.white
        labelView.addSubview(label)
        
        return labelView
    }
    func linesCount(string:String) -> CGFloat {
        
        let str = string
        let word = "\n"
        var count = 1
        var nextRange = str.startIndex..<str.endIndex
        while let range = str.range(of: word, options: .caseInsensitive, range: nextRange) {
            count += 1
            nextRange = range.upperBound..<str.endIndex
        }
        return CGFloat(count)
    }

}
