//
//  CircleViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/06/09.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    
    let colors = Colors()
    
    override func viewDidLayoutSubviews() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 25, width: 60, height: 30)
        backButton.setTitle("戻る", for: .normal)
        backButton.setTitleColor(colors.white, for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        gradientLayer.colors = [colors.bluePurple.cgColor,
                                colors.blue.cgColor,
                                /*colors.blue.cgColor,
                                colors.blueGreen.cgColor*/]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    @objc func backButtonAction(){
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
