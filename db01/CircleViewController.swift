//
//  CircleViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/06/09.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class CircleViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let colors = Colors()
    var segment = 0
    var pre:Results<Preference>?
    var searchText = "東京"
    
    override func viewDidLayoutSubviews() {
        
        segmentControl.frame = CGRect(x: 10, y: 70, width: view.frame.size.width - 20, height: 20)
        segmentControl.setTitle("感染者数", forSegmentAt: 0)
        segmentControl.setTitle("PCR数", forSegmentAt: 1)
        segmentControl.setTitle("死者数", forSegmentAt: 2)
        segmentControl.selectedSegmentTintColor = colors.blue
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.white], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.black], for: .normal)
        searchBar.frame = CGRect(x: 10, y: 100, width: view.frame.size.width - 20, height: 30)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.size.width
//        let height = view.frame.size.height
        
        segmentControl.selectedSegmentIndex = segment
        view.backgroundColor = colors.white

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
        

        
        searchBar.delegate = self
        searchBar.placeholder = "都道府県を入力してください"
        searchBar.showsCancelButton = true
        searchBar.tintColor = colors.blue
        
        let uiView = UIView()
        uiView.frame = CGRect(x: 10, y: 480, width: view.frame.size.width - 20, height: 167)
        uiView.layer.cornerRadius = 10
        uiView.backgroundColor = .white
        uiView.layer.shadowColor = colors.black.cgColor
        uiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        uiView.layer.shadowOpacity = 0.4
        uiView.layer.shadowRadius = 10
        view.addSubview(uiView)
        
        
        let realm = try! Realm()
        let pref = realm.objects(Preference.self)
        var array:[String] = []
        var checkArray:[String] = []
        for i in 0...46 {
            array.append(pref[i].name)
        }
        checkArray = array.map({
            String($0.prefix(2))
        })
        if !checkArray.contains(String(searchText.prefix(2))) {
            searchText = "東京"
        }
        if searchText.contains("東京都") || searchText.contains("大阪府") || searchText.contains("県") {
            searchText = String(searchText.prefix(searchText.count - 1))
        }
        let result = pref.filter("name == '\(searchText)'")
        uiView.addSubview(labelStatus(width / 2 - 60,10,100,50, text: "\(result[0].name)", size: 30, weight: .ultraLight, color: colors.black))
        
        uiView.addSubview(labelStatus(10,50,100,50, text: "PCR数", size: 15, weight: .bold, color: colors.bluePurple))
        uiView.addSubview(labelStatus(10,85,100,50, text: "\(result[0].pcr)", size: 30, weight: .bold, color: colors.blue))
        uiView.addSubview(labelStatus(130,50,100,50, text: "感染者数", size: 15, weight: .bold, color: colors.bluePurple))
        uiView.addSubview(labelStatus(130,85,100,50, text: "\(result[0].cases)", size: 30, weight: .bold, color: colors.blue))
        uiView.addSubview(labelStatus(245,50,100,50, text: "死者数", size: 15, weight: .bold, color: colors.bluePurple))
        uiView.addSubview(labelStatus(245,85,100,50, text: "\(result[0].deaths)", size: 30, weight: .bold, color: colors.blue))

        var entrys:[PieChartDataEntry] = []
        if segment == 0 {
            pre = pref.sorted(byKeyPath: "cases", ascending: false)
            for i in 0...4{
                entrys += [PieChartDataEntry(value: Double(pre![i].cases), label: pre![i].name)]
            }
        } else if segment == 1 {
            pre = pref.sorted(byKeyPath: "pcr", ascending: false)
            for i in 0...4{
                entrys += [PieChartDataEntry(value: Double(pre![i].pcr), label: pre![i].name)]
            }
        } else if segment == 2 {
            pre = pref.sorted(byKeyPath: "deaths", ascending: false)
            for i in 0...4{
                entrys += [PieChartDataEntry(value: Double(pre![i].deaths), label: pre![i].name)]
            }
        }
        let circleView = PieChartView(frame: CGRect(x: 0, y: 150, width: width, height: 300))
        circleView.centerText = "Top5"
        circleView.animate(xAxisDuration: 2, easingOption: .easeOutExpo)
        let dataSet = PieChartDataSet(entries: entrys)
        dataSet.colors = [
            colors.blue, colors.blueGreen, colors.yellowGreen, colors.yellowOrange,
            colors.redOrange,
        ]
        dataSet.valueTextColor = colors.white
        dataSet.entryLabelColor = colors.white
        circleView.data = PieChartData(dataSet: dataSet)
        circleView.legend.enabled = false
        view.addSubview(circleView)
    }
    @objc func backButtonAction(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            segment = 0
            loadView()
            viewDidLoad()
        } else if sender.selectedSegmentIndex == 1 {
            segment = 1
            loadView()
            viewDidLoad()
        } else {
            segment = 2
            loadView()
            viewDidLoad()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        view.endEditing(true)
        searchText = searchBar.text ?? "東京"
        print("検索ボタンがタップ ")
        loadView()
        viewDidLoad()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        print("キャンセルボタンがタップ")
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
}
