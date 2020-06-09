//
//  ViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/22.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//
///Users/tanakasoushi/Desktop/SwiftiPhone/COVID/db01/Base.lproj/Main.storyboard: error: IB Designables: Failed to render and update auto layout status for UIViewController (g7j-Xd-C33): Failed to launch designables agent. Check the console for a more detailed description and please file a bug report at feedbackassistant.apple.com.

import UIKit
import RealmSwift
import Alamofire
import KRProgressHUD

class ViewController: UIViewController{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containLabel: UIView!
    
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pcr: UILabel!
    @IBOutlet weak var positive: UILabel!
    @IBOutlet weak var hospitalize: UILabel!
    @IBOutlet weak var severe: UILabel!
    @IBOutlet weak var death: UILabel!
    @IBOutlet weak var discharge: UILabel!
    
    @IBOutlet weak var pcrNum: UILabel!
    @IBOutlet weak var positiveNum: UILabel!
    @IBOutlet weak var hospitalizeNum: UILabel!
    @IBOutlet weak var severeNum: UILabel!
    @IBOutlet weak var deathNum: UILabel!
    @IBOutlet weak var dischargeNum: UILabel!
    
    private var result:[Prefecture.Obj] = []
    let colors = Colors.init()
    
    override func viewDidLayoutSubviews() {
        let width:CGFloat = view.frame.size.width
        let height:CGFloat = view.frame.size.height
        var textHeight:CGFloat = 0
        var buttonHeight:CGFloat = 0
        var contentHeight:CGFloat = 0
        if height == 667 {
            textHeight = 30
            buttonHeight = 60
            contentHeight -= 10
        } else if height == 736 {
            textHeight = 10
            buttonHeight = 50
            contentHeight = 30
        } else if height == 812 {
            contentHeight = 30
        } else if height == 896 {
            contentHeight = 80
            textHeight -= 20
            buttonHeight -= 20
        }
        
        
        let labelWidth:CGFloat = 150
        let labelHeight:CGFloat = 50
        let widthSub:CGFloat = 140
        let widthAdd:CGFloat = 30
        let labelSize:CGFloat = 15
        let numSize:CGFloat = 35
        
        titleLabel.frame = CGRect(x: width / 2 - 105, y: 130 - textHeight, width: 300, height: labelHeight)
        titleLabel.font = UIFont(name: "Helvetica-Light", size: 25)
        containLabel.frame = CGRect(x: 0, y: 170 + contentHeight, width: width, height: 340)
        pcr.frame = CGRect(x: width / 2 - widthSub, y: 20, width: labelWidth, height: labelHeight)
        pcr.font = UIFont(name: "Helvetica-Light", size: labelSize)
        pcrNum.frame = CGRect(x: width / 2 - widthSub, y: 60, width: labelWidth, height: labelHeight)
        pcrNum.font = .systemFont(ofSize: numSize, weight: .heavy)
        positive.frame = CGRect(x: width / 2 + widthAdd, y: 20, width: labelWidth, height: labelHeight)
        positive.font = UIFont(name: "Helvetica-Light", size: labelSize)
        positiveNum.frame = CGRect(x: width / 2 + widthAdd, y: 60, width: labelWidth, height: labelHeight)
        positiveNum.font = .systemFont(ofSize: numSize, weight: .heavy)
        hospitalize.frame = CGRect(x: width / 2 - widthSub, y: 120, width: labelWidth, height: labelHeight)
        hospitalize.font = UIFont(name: "Helvetica-Light", size: labelSize)
        hospitalizeNum.frame = CGRect(x: width / 2 - widthSub, y: 160, width: labelWidth, height: labelHeight)
        hospitalizeNum.font = .systemFont(ofSize: numSize, weight: .heavy)
        severe.frame = CGRect(x: width / 2 + widthAdd, y: 120, width: labelWidth, height: labelHeight)
        severe.font = UIFont(name: "Helvetica-Light", size: labelSize)
        severeNum.frame = CGRect(x: width / 2 + widthAdd, y: 160, width: labelWidth, height: labelHeight)
        severeNum.font = .systemFont(ofSize: numSize, weight: .heavy)
        death.frame = CGRect(x: width / 2 - widthSub, y: 220, width: labelWidth, height: labelHeight)
        death.font = UIFont(name: "Helvetica-Light", size: labelSize)
        deathNum.frame = CGRect(x: width / 2 - widthSub, y: 260, width: labelWidth, height: labelHeight)
        deathNum.font = .systemFont(ofSize: numSize, weight: .heavy)
        discharge.frame = CGRect(x: width / 2 + widthAdd, y: 220, width: labelWidth, height: labelHeight)
        discharge.font = UIFont(name: "Helvetica-Light", size: labelSize)
        dischargeNum.frame = CGRect(x: width / 2 + widthAdd, y: 260, width: labelWidth, height: labelHeight)
        dischargeNum.font = .systemFont(ofSize: numSize, weight: .heavy)
        
        healthButton.frame = CGRect(x: width / 2 - 100, y: height - 190 + buttonHeight, width: 200, height: 40)
        healthButton.titleLabel?.font = .systemFont(ofSize: 20)
        infoButton.frame = CGRect(x: width / 2 - 100, y: height - 130 + buttonHeight, width: 200, height: 40)
        infoButton.titleLabel?.font = .systemFont(ofSize: 20)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 25, width: 60, height: 30)
        backButton.setTitle("reload", for: .normal)
        backButton.setTitleColor(colors.white, for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        
        let imageView = UIImageView()
        let image = UIImage(named: "virus2")
        imageView.image = image
        imageView.frame = CGRect(x: view.frame.size.width + 0, y: 100, width: 50, height: 50)
        imageView.layer.accessibilityRespondsToUserInteraction = false
        view.addSubview(imageView)
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
            imageView.frame = CGRect(x: self.view.frame.size.width - 100, y: 100, width: 50, height: 50)
            imageView.transform = .init(rotationAngle: -900)
        }, completion: nil)
        
        view.backgroundColor = .systemGray6
        
        let cgColor:CGColor = colors.blue.cgColor
//        let cgColor:CGColor = .init(srgbRed: 0/255, green: 30/255, blue: 120/255, alpha: 0.7)
        let color:UIColor = colors.blue
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
        gradientLayer.colors = [colors.bluePurple.cgColor,
                                colors.blue.cgColor,
                                /*colors.blue.cgColor,
                                colors.blueGreen.cgColor*/]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        view.layer.insertSublayer(gradientLayer, at:0)
        containLabel.layer.cornerRadius = 30
        containLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        containLabel.layer.shadowColor = UIColor.gray.cgColor
        containLabel.layer.shadowOpacity = 0.5
        containLabel.layer.shadowRadius = 4
        containLabel.backgroundColor = .white
        
        healthButton.layer.backgroundColor = colors.white.cgColor
        healthButton.layer.cornerRadius = 5
        healthButton.tintColor = color
        healthButton.setTitle("健 康 管 理", for: .normal)
        infoButton.layer.backgroundColor = colors.white.cgColor
        infoButton.layer.cornerRadius = 5
        infoButton.frame.size.width = 200
        infoButton.tintColor = color
        infoButton.setTitle("県 別 状 況", for: .normal)
        
        let uiColor:UIColor = colors.black
        titleLabel.text = "Covid in Japan"
        titleLabel.textColor = colors.white
        
        pcr.text = "PCR数"
        pcr.textColor = uiColor
        positive.text = "感染者数"
        positive.textColor = uiColor
        hospitalize.text = "入院者数"
        hospitalize.textColor = uiColor
        severe.text = "重傷者数"
        severe.textColor = uiColor
        death.text = "死者数"
        death.textColor = uiColor
        discharge.text = "退院者数"
        discharge.textColor = uiColor
        
        labelNum(pcrNum, color: color, cgColor: cgColor)
        labelNum(positiveNum, color: color, cgColor: cgColor)
        labelNum(hospitalizeNum, color: color, cgColor: cgColor)
        labelNum(severeNum, color: color, cgColor: cgColor)
        labelNum(deathNum, color: color, cgColor: cgColor)
        labelNum(dischargeNum, color: color, cgColor: cgColor)
        
        testData()
        numAnimate()
        realmPrefecture()
        realmJapan()

    }
    
    @IBAction func healthButton(_ sender: Any) {
        KRProgressHUD.appearance().activityIndicatorColors = .init(arrayLiteral: colors.blue)
        KRProgressHUD.show(withMessage: "Loading...", completion: {
            self.performSegue(withIdentifier: "goHealth", sender: nil)
        })
    }
    @IBAction func prefectureButton(_ sender: Any) {
            self.performSegue(withIdentifier: "goChart", sender: nil)
    }
    @objc func backButtonAction() {
        viewDidLoad()
        viewDidLayoutSubviews()
    }
    func testData(){
        let countArray = Colona()
        countArray.high.append("2020-05-31")
        countArray.none.append("2020-06-01")
        countArray.low.append("2020-05-28")
        countArray.middle.append("2020-05-29")
        let realms = try! Realm()
        try! realms.write{
            realms.add(countArray)
        }
    }
    func numAnimate() {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseIn], animations: {
            self.pcrNum.alpha = 1.0
            self.positiveNum.alpha = 1.0
            self.hospitalizeNum.alpha = 1.0
            self.severeNum.alpha = 1.0
            self.deathNum.alpha = 1.0
            self.dischargeNum.alpha = 1.0
        }, completion: nil)
    }
    //県別情報を上書き
    func realmPrefecture() {
        let realm = try! Realm()
        let pre = realm.objects(Preference.self).filter("id < 50")
        if !pre.isEmpty {
            try! realm.write() {
                realm.delete(pre)
            }
        }
        getCovidInfo(completion: {(result: [Prefecture.Obj]) -> Void in
            for i in 0...46 {
                let preModel = Preference()
                preModel.id = result[i].id
                preModel.name = result[i].name_ja
                preModel.cases = result[i].cases
                preModel.deaths = result[i].deaths
                preModel.pcr = result[i].pcr
                
                let realm = try! Realm()
                try! realm.write{
                    realm.add(preModel)
                    
                }
            }
        })
    }
    func labelNum(_ num: UILabel, color: UIColor, cgColor: CGColor) {
        num.layer.borderColor = cgColor
        num.layer.cornerRadius = 5
        num.textColor = color
        num.alpha = 0.0
    }
    //日本全体情報を上書き
    func realmJapan() {
        let realmSum = try! Realm()
        let preSum = realmSum.objects(Japan.self)

        if !preSum.isEmpty {
            try! realmSum.write() {
                realmSum.delete(preSum)
            }
        }
        getCovidSumInfo(completion: {(result: Prefecture.Total) -> Void in
            self.pcrNum.text = "\(result.pcr)"
            self.positiveNum.text = "\(result.positive)"
            self.hospitalizeNum.text = "\(result.hospitalize)"
            self.severeNum.text = "\(result.severe)"
            self.dischargeNum.text = "\(result.discharge)"
            self.deathNum.text = "\(result.death)"
            
                let preModel = Japan()
                preModel.pcr = result.pcr
                preModel.positive = result.positive
                preModel.hospitalize = result.hospitalize
                preModel.severe = result.severe
                preModel.discharge = result.discharge
                preModel.death = result.death

                let realm = try! Realm()
                try! realm.write{
                    realm.add(preModel)

                }
        })
    }
    
    //MARK:-日本の感染者数を取得している
    func getCovidInfo(completion: @escaping ([Prefecture.Obj])->Void){
        var data:[Prefecture.Obj] = []
        let decoder = JSONDecoder()
        AF.request("https://covid19-japan-web-api.now.sh/api//v1/prefectures")
            .responseJSON { response in
                do {
                    let result:[Prefecture.Obj] = try decoder.decode([Prefecture.Obj].self, from: response.data!)
                        data = result
                } catch {
                    print("failed")
                    print(error.localizedDescription)
                }
                completion(data)
        }
    }
    func getCovidSumInfo(completion: @escaping (Prefecture.Total)->Void){
            var data:Prefecture.Total?
            let decoder = JSONDecoder()
            AF.request("https://covid19-japan-web-api.now.sh/api//v1/total")
                .responseJSON { response in
                    do {
                        let result:Prefecture.Total = try decoder.decode(Prefecture.Total.self, from: response.data!)
                        data = result
                    } catch {
                        print("failed:\(error.localizedDescription)")
                    }
                    completion(data!)
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

