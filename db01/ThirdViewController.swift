//
//  CustomTableView.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/25.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var customTableView: UITableView!
    private var addresses = Prefecture?.self
    private var result:[Prefecture.Obj] = []
    private var highestCase:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemGray6
        
        customTableView.register(UINib(nibName: "CustomTableViewCellThird", bundle: nil), forCellReuseIdentifier: "customCell")
        let realm = try! Realm()
        let pre = realm.objects(Preference.self)
        highestCase = pre[12].deaths
        customTableView.dataSource = self
        customTableView.delegate = self
        customTableView.layer.borderWidth = 2
        customTableView.layer.borderColor = .init(srgbRed: 20/255, green: 50/255, blue: 150/255, alpha: 0.6)
        customTableView.layer.cornerRadius = 4
        
        segment.setTitle("都道府県順", forSegmentAt: 0)
        segment.setTitle("死者数降順", forSegmentAt: 1)
        segment.setTitle("死者数昇順", forSegmentAt: 2)
        
        let color:UIColor = .init(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.7)
        segment.selectedSegmentTintColor = color
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        customTableView.isEditing = editing //editingはBool型でeditButtonに依存する変数
    }
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segment.selectedSegmentIndex = 0
        case 1:
            segment.selectedSegmentIndex = 1
        case 2:
            segment.selectedSegmentIndex = 2
        default:
            break
        }
        customTableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let pre = realm.objects(Preference.self)
        let cellCount = pre.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCellThird
            
        let screen = UIScreen.main.bounds
        
        let realm = try! Realm()
        let pref = realm.objects(Preference.self)
        var pre:Results<Preference>?
        if segment.selectedSegmentIndex == 0 {
            pre = realm.objects(Preference.self)
        } else if segment.selectedSegmentIndex == 1 {
            pre = pref.sorted(byKeyPath: "deaths", ascending: false)
        } else {
            pre = pref.sorted(byKeyPath: "deaths")
        }
        
        let label = UILabel()
        label.text = pre![indexPath.row].name
        label.frame = CGRect(x: 20 ,y:7,width:52,height:21)
        cell.contentView.addSubview(label)
        
        let num = UILabel()
        num.text = String(pre![indexPath.row].deaths)
        num.frame = CGRect(x: screen.width - 100 ,y:7,width:52,height:21)
        num.textAlignment = .right
        cell.contentView.addSubview(num)
        
        let progressView = UIProgressView()
        progressView.frame = CGRect(x: 100,y:17,width:screen.width - 100,height:20)
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
        progressView.backgroundColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        progressView.progressTintColor = .init(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.7)
        progressView.setProgress(Float(pre![indexPath.row].deaths) / Float(highestCase!), animated: false)
        cell.contentView.addSubview(progressView)
            
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         customTableView.deselectRow(at: indexPath, animated: true)
    }
}
