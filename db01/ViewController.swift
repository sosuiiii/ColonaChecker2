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

class ViewController: UIViewController {
    
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
    
    override func viewDidLayoutSubviews() {
        let width = Int(view.frame.size.width)
        let height = Int(view.frame.size.height)
        var textHeight = 0
        var buttonHeight = 0
        var contentHeight = 0
        if height == 667 {
            textHeight = 20
            buttonHeight = 70
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
        healthButton.frame = CGRect(x: width / 2 - 100, y: height - 190 + buttonHeight, width: 200, height: 40)
        healthButton.titleLabel?.font = .systemFont(ofSize: 20)
        infoButton.frame = CGRect(x: width / 2 - 100, y: height - 130 + buttonHeight, width: 200, height: 40)
        infoButton.titleLabel?.font = .systemFont(ofSize: 20)
        
        let labelWidth:Int = 120
        let labelHeight:Int = 50
        let widthSub = 140
        let widthAdd = 25
        
        titleLabel.frame = CGRect(x: width / 2 - 105, y: 130 - textHeight, width: 300, height: labelHeight)
        titleLabel.font = UIFont(name: "Helvetica-Light", size: 25)
        containLabel.frame = CGRect(x: 0, y: 170 + contentHeight, width: width, height: 340)
        pcr.frame = CGRect(x: width / 2 - widthSub, y: 10, width: labelWidth, height: labelHeight)
        pcr.font = .systemFont(ofSize: 30.0)
        pcr.font = UIFont(name: "Helvetica-Light", size: 30)
        pcrNum.frame = CGRect(x: width / 2 - widthSub, y: 60, width: labelWidth, height: labelHeight)
        pcrNum.font = .systemFont(ofSize: 30, weight: .ultraLight)
        positive.frame = CGRect(x: width / 2 + widthAdd, y: 10, width: labelWidth, height: labelHeight)
        positive.font = UIFont(name: "Helvetica-Light", size: 30)
        positiveNum.frame = CGRect(x: width / 2 + widthAdd, y: 60, width: labelWidth, height: labelHeight)
        positiveNum.font = .systemFont(ofSize: 30, weight: .ultraLight)
        hospitalize.frame = CGRect(x: width / 2 - widthSub, y: 110, width: labelWidth, height: labelHeight)
        hospitalize.font = UIFont(name: "Helvetica-Light", size: 30)
        hospitalizeNum.frame = CGRect(x: width / 2 - widthSub, y: 160, width: labelWidth, height: labelHeight)
        hospitalizeNum.font = .systemFont(ofSize: 30, weight: .ultraLight)
        severe.frame = CGRect(x: width / 2 + widthAdd, y: 110, width: labelWidth, height: labelHeight)
        severe.font = UIFont(name: "Helvetica-Light", size: 30)
        severeNum.frame = CGRect(x: width / 2 + widthAdd, y: 160, width: labelWidth, height: labelHeight)
        severeNum.font = .systemFont(ofSize: 30, weight: .ultraLight)
        death.frame = CGRect(x: width / 2 - widthSub, y: 210, width: labelWidth, height: labelHeight)
        death.font = UIFont(name: "Helvetica-Light", size: 30)
        deathNum.frame = CGRect(x: width / 2 - widthSub, y: 260, width: labelWidth, height: labelHeight)
        deathNum.font = .systemFont(ofSize: 30, weight: .ultraLight)
        discharge.frame = CGRect(x: width / 2 + widthAdd, y: 210, width: labelWidth, height: labelHeight)
        discharge.font = UIFont(name: "Helvetica-Light", size: 30)
        dischargeNum.frame = CGRect(x: width / 2 + widthAdd, y: 260, width: labelWidth, height: labelHeight)
        dischargeNum.font = .systemFont(ofSize: 30, weight: .ultraLight)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        let cgColor:CGColor = .init(srgbRed: 0/255, green: 30/255, blue: 120/255, alpha: 0.7)
        let color:UIColor = .white
        
        let gradientLayer = CAGradientLayer()
        // グラデーションレイヤーの領域の設定
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 340)
        // グラデーションカラーの設定
        gradientLayer.colors = [UIColor(red: 5/255, green: 222/255, blue: 240/255, alpha: 0.8).cgColor,
                                UIColor(red: 39/255, green: 48/255, blue: 152/255, alpha: 0.8).cgColor]
        // 左上から右下へグラデーション向きの設定
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y:1)
        containLabel.layer.insertSublayer(gradientLayer, at:0)
        containLabel.layer.cornerRadius = 30
        containLabel.layer.shadowOffset = CGSize(width: 0, height: 10)
        containLabel.layer.shadowColor = UIColor.black.cgColor
        containLabel.layer.shadowOpacity = 0.6
        containLabel.layer.shadowRadius = 4
        
        navigationController?.navigationBar.barTintColor = .init(red: 0/255, green: 30/255, blue: 100/255, alpha: 0.1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        title = "コロナチェッカー"
        
//      healthButton.layer.borderColor = UIColor.white.cgColor
        healthButton.layer.backgroundColor = cgColor
//        healthButton.layer.borderWidth = 1
        healthButton.layer.cornerRadius = 5
        healthButton.tintColor = color
        healthButton.setTitle("健 康 管 理", for: .normal)
//        infoButton.layer.borderColor = cgColor
        infoButton.layer.backgroundColor = cgColor
//        infoButton.layer.borderWidth = 1
        infoButton.layer.cornerRadius = 5
        infoButton.frame.size.width = 200
        infoButton.tintColor = color
        infoButton.setTitle("県 別 状 況", for: .normal)
        
        let uiColor:UIColor = .init(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.8)
        titleLabel.text = "日本全体の感染状況"
        titleLabel.textColor = .init(red: 0/255, green: 40/255, blue: 120/255, alpha: 0.8)
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowRadius = 5
        pcr.text = "PCR数"
        pcr.textColor = uiColor
        pcr.textAlignment = .center
        positive.text = "感染者数"
        positive.textColor = uiColor
        hospitalize.text = "入院者数"
        hospitalize.textColor = uiColor
        severe.text = "重傷者数"
        severe.textColor = uiColor
        death.text = "死者数"
        death.textColor = uiColor
        death.textAlignment = .center
        discharge.text = "退院者数"
        discharge.textColor = uiColor
        
        pcrNum.layer.borderColor = cgColor
//        pcrNum.layer.borderWidth = 1
        pcrNum.layer.cornerRadius = 5
        pcrNum.textColor = color
        pcrNum.textAlignment = .center
        pcrNum.alpha = 0.0
        positiveNum.layer.borderColor = cgColor
//        positiveNum.layer.borderWidth = 1
        positiveNum.layer.cornerRadius = 5
        positiveNum.textAlignment = .center
        positiveNum.textColor = color
        positiveNum.alpha = 0.0
        hospitalizeNum.layer.borderColor = cgColor
//        hospitalizeNum.layer.borderWidth = 1
        hospitalizeNum.layer.cornerRadius = 5
        hospitalizeNum.textAlignment = .center
        hospitalizeNum.textColor = color
        hospitalizeNum.alpha = 0.0
        severeNum.layer.borderColor = cgColor
//        severeNum.layer.borderWidth = 1
        severeNum.layer.cornerRadius = 5
        severeNum.textAlignment = .center
        severeNum.textColor = color
        severeNum.alpha = 0.0
        deathNum.layer.borderColor = cgColor
//        deathNum.layer.borderWidth = 1
        deathNum.layer.cornerRadius = 5
        deathNum.textAlignment = .center
        deathNum.textColor = color
        deathNum.alpha = 0.0
        dischargeNum.layer.borderColor = cgColor
//        dischargeNum.layer.borderWidth = 1
        dischargeNum.layer.cornerRadius = 5
        dischargeNum.textAlignment = .center
        dischargeNum.textColor = color
        dischargeNum.alpha = 0.0
        
        
        numAnimate()
        realmPrefecture()
        realmJapan()
        
//        let countArray = Colona()
//        countArray.high.append("2020-05-20")
//        countArray.none.append("2020-05-17")
//        countArray.low.append("2020-05-18")
//        countArray.middle.append("2020-05-19")
//        let realms = try! Realm()
//        try! realms.write{
//            realms.add(countArray)
//        }
        
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
    //Prefectureを上書き
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
    @IBAction func healthButton(_ sender: Any) {
        performSegue(withIdentifier: "goHealth", sender: nil)
    }
    @IBAction func prefectureButton(_ sender: Any) {
        performSegue(withIdentifier: "goPrefecture", sender: nil)
    }
    
    //MARK:-日本の感染者数を取得している
        func getCovidInfo(completion: @escaping ([Prefecture.Obj])->Void){
            var data:[Prefecture.Obj] = []
            let decoder = JSONDecoder()
            // AlamofireでAPIリクエストをする
            AF.request("https://covid19-japan-web-api.now.sh/api//v1/prefectures")
                // レスポンスをJSON形式で受け取る
                .responseJSON { response in
                    do {
                        // decode関数の引数にはJSONからマッピングさせたいクラスをと実際のデータを指定する
                        let result:[Prefecture.Obj] = try decoder.decode([Prefecture.Obj].self, from: response.data!)
                        data = result
                    } catch {
                        // JSONの形式とクラスのプロパティが異なっている場合には失敗する
                        print("failed")
                        print(error.localizedDescription)
                    }
                    completion(data)
            }
        }
    func getCovidSumInfo(completion: @escaping (Prefecture.Total)->Void){
            var data:Prefecture.Total?
            let decoder = JSONDecoder()
            // AlamofireでAPIリクエストをする
            AF.request("https://covid19-japan-web-api.now.sh/api//v1/total")
                // レスポンスをJSON形式で受け取る
                .responseJSON { response in
                    do {
                        // decode関数の引数にはJSONからマッピングさせたいクラスをと実際のデータを指定する
                        let result:Prefecture.Total = try decoder.decode(Prefecture.Total.self, from: response.data!)
                        data = result
                    } catch {
                        // JSONの形式とクラスのプロパティ、型が異なっている場合には失敗する
                        print("failed:\(error.localizedDescription)")
                    }
                    completion(data!)
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    

}

