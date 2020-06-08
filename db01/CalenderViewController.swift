//
//  CalenderViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/30.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift
import KRProgressHUD

class CalenderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
    @IBOutlet weak var firstSwitch: UISwitch!
    @IBOutlet weak var secondSwitch: UISwitch!
    @IBOutlet weak var thirdSwitch: UISwitch!
    @IBOutlet weak var fourthSwitch: UISwitch!
    @IBOutlet weak var fifthSwitch: UISwitch!
    
    var checkLabel = "診断完了"
    //今日の日付を受け取る
    var day = ""
    //感染危険度を数値化する為の変数
    var checkCount = 0
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLayoutSubviews() {
        
        checkButton.frame = CGRect(x: view.frame.size.width / 2 - 100, y: 800, width: 200, height: 40)
        checkButton.titleLabel?.font = .systemFont(ofSize: 20)
        firstLabel.frame = CGRect(x: 20, y: 15, width: 200, height: 40)
        secondLabel.frame = CGRect(x: 20, y: 15, width: 200, height: 40)
        thirdLabel.frame = CGRect(x: 20, y: 15, width: 200, height: 40)
        fourthLabel.frame = CGRect(x: 20, y: 15, width: 200, height: 40)
        fifthLabel.frame = CGRect(x: 20, y: 15, width: 200, height: 40)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        calendarView.delegate = self
        calendarView.dataSource = self
        
        titleLabel.text = "健康チェック"
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .init(red: 0/255, green: 30/255, blue: 120/255, alpha: 0.6)
        titleLabel.textColor = .white
        
        let color:UIColor = .init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        view.backgroundColor = .lightGray
        bottomView.backgroundColor = .init(red: 0/255, green: 30/255, blue: 120/255, alpha: 0.5)
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        contentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.6
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = color
        
        let radius:CGFloat = 20
        firstView.layer.shadowRadius = 4
        firstView.layer.shadowOpacity = 0.3
        firstView.layer.shadowColor = UIColor.black.cgColor
        firstView.layer.shadowOffset = CGSize(width: 4, height: 2)
        firstView.layer.cornerRadius = radius
        secondView.layer.shadowRadius = 4
        secondView.layer.shadowOpacity = 0.3
        secondView.layer.shadowColor = UIColor.black.cgColor
        secondView.layer.shadowOffset = CGSize(width: 4, height: 2)
        secondView.layer.cornerRadius = radius
        thirdView.layer.shadowRadius = 4
        thirdView.layer.shadowOpacity = 0.3
        thirdView.layer.shadowColor = UIColor.black.cgColor
        thirdView.layer.shadowOffset = CGSize(width: 4, height: 2)
        thirdView.layer.cornerRadius = radius
        fourthView.layer.shadowRadius = 4
        fourthView.layer.shadowOpacity = 0.3
        fourthView.layer.shadowColor = UIColor.black.cgColor
        fourthView.layer.shadowOffset = CGSize(width: 4, height: 2)
        fourthView.layer.cornerRadius = radius
        fifthView.layer.shadowRadius = 4
        fifthView.layer.shadowOpacity = 0.3
        fifthView.layer.shadowColor = UIColor.black.cgColor
        fifthView.layer.shadowOffset = CGSize(width: 4, height: 2)
        fifthView.layer.cornerRadius = radius
        
        firstLabel.text = "1・37.5度以上の熱がある"
        secondLabel.text = "2・のどの痛みがある"
        thirdLabel.text = "3・匂いを感じない"
        fourthLabel.text = "4・味が薄く感じる"
        fifthLabel.text = "5・だるさがある"
        
//        checkButton.layer.borderColor = .init(srgbRed: 0/255, green: 30/255, blue: 150/255, alpha: 0.7)
//        checkButton.layer.borderWidth = 2
        checkButton.layer.cornerRadius = 5
        checkButton.tintColor = .white
        checkButton.setTitle(checkLabel, for: .normal)
        checkButton.backgroundColor = .init(red: 0/255, green: 30/255, blue: 120/255, alpha: 0.6)
        
        firstSwitch.isOn = false
        secondSwitch.isOn = false
        thirdSwitch.isOn = false
        fourthSwitch.isOn = false
        fifthSwitch.isOn = false
        
        calendarView.appearance.headerTitleColor = .init(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.9)
        calendarView.appearance.weekdayTextColor = .init(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.9)
        
        //診断をしていた場合、チェックボタンを無効にする
        LaunchCheck()
        //今日の日付を変数dayに代入
        today()
        
        KRProgressHUD.dismiss()
        
    }
    
    func LaunchCheck() {
        if UserDefaults.standard.string(forKey: "todayLaunch") ?? "0" == day {
            firstSwitch.isEnabled = false
            secondSwitch.isEnabled = false
            thirdSwitch.isEnabled = false
            fourthSwitch.isEnabled = false
            fifthSwitch.isEnabled = false
            checkButton.isEnabled = false
            checkButton.setTitle("本日終了", for: .normal)
        } else {
            UserDefaults.standard.removeObject(forKey: "todayLaunch")
        }
    }
    @IBAction func firstSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            checkCount += 2
        } else {
            checkCount -= 2
        }
    }
    @IBAction func secondSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            checkCount += 2
        } else {
            checkCount -= 2
        }
    }
    @IBAction func thirdSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            checkCount += 1
        } else {
            checkCount -= 1
        }
    }
    @IBAction func fourthSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            checkCount += 1
        } else {
            checkCount -= 1
        }
    }
    @IBAction func fifthSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            checkCount += 2
        } else {
            checkCount -= 2
        }
    }
    @IBAction func checkButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "診断を完了しますか？", message: "診断は１日に1回までです", preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "はい", style: .default, handler: {
            (action) -> Void in
            let alert = UIAlertController(title: "今日の診断が保存されました", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.dismiss(animated: true, completion: {
                    
                    let countArray = Colona()
                    if self.checkCount >= 6{
                        countArray.high.append(self.day)
                        let alert = UIAlertController(title: "感染している可能性「高」", message: "コロナウイルスの感染症状が\n多く見られます。\nPCR検査を一度\n受診されることをおすすめします。", preferredStyle: .alert)
                        let close = UIAlertAction(title: "閉じる", style: .default, handler: {
                                (action) -> Void in
                        })
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else if self.checkCount >= 3 {
                        countArray.middle.append(self.day)
                        let alert = UIAlertController(title: "感染している可能性「中」", message: "コロナウイルスの感染症状が\n少し見られます。\n風邪の可能性もありますが、\n悪化するようであればPCR検査を\n受診されることをおすすめします。", preferredStyle: .alert)
                        let close = UIAlertAction(title: "閉じる", style: .default, handler: {
                                (action) -> Void in
                        })
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else if self.checkCount >= 1 {
                        countArray.low.append(self.day)
                        let alert = UIAlertController(title: "感染している可能性「低」", message: "コロナウイルスの感染症状が\nほんの少し見られます。\n安静に過ごし、経過を見てみましょう。", preferredStyle: .alert)
                        let close = UIAlertAction(title: "閉じる", style: .default, handler: {
                                (action) -> Void in
                        })
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        countArray.none.append(self.day)
                        let alert = UIAlertController(title: "感染している可能性\n「極めて低い」", message: "コロナウイルスの感染症状が\n見られないようです。安静に過ごし、\n3密に気をつけてください。", preferredStyle: .alert)
                        let close = UIAlertAction(title: "閉じる", style: .default, handler: {
                                (action) -> Void in
                        })
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                        UserDefaults.standard.set(self.day, forKey: "todayLaunch")
                    }
                    let realm = try! Realm()
                    try! realm.write{
                        realm.add(countArray)
                    }
                })
            }
            
        })
        let no = UIAlertAction(title: "キャンセル", style: .destructive, handler: {
            (action) -> Void in
        })
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: {
        })
        checkButton.setTitle("本日終了", for: .normal)
        firstSwitch.isEnabled = false
        secondSwitch.isEnabled = false
        thirdSwitch.isEnabled = false
        fourthSwitch.isEnabled = false
        fifthSwitch.isEnabled = false
        checkButton.isEnabled = false
        
        
        
    }
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        if dateFormatter2.string(from: date) == day {
            return .init(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.9)
        }
        return .clear
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 0.5
    }
    //診断結果をカレンダーに表示する
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let realm = try! Realm()
        let colona = realm.objects(Colona.self)
        var str = ""
        for col in colona {
            if col.none.contains(dateFormatter2.string(from: date)){
                str = "良好"
            } else if col.low.contains(dateFormatter2.string(from: date)) {
                str = "低"
            } else if col.middle.contains(dateFormatter2.string(from: date)) {
                str = "中"
            } else if col.high.contains(dateFormatter2.string(from: date)) {
                str = "高"
            } else {
                str = ""
            }
        }
        return str
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        print(getDay(date))
    }
    func getDay(_ date:Date) -> (String){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = NSString(format: "%02d",tmpCalendar.component(.month, from: date))
        let day = tmpCalendar.component(.day, from: date)
        return ("\(year)-\(month)-\(day)")
    }
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return .init(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        }
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return .init(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        } else if weekday == 7 {  //土曜日
            return .init(red: 0/255, green: 30/255, blue: 150/255, alpha: 0.9)
        }

        return .black
    }
    func today() {
        //今日の日付をdayに代入
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "y-M-d", options: 0, locale: Locale(identifier: "ja_JP"))
        let today = String(dateFormatter.string(from: date)).replacingOccurrences(of: "/", with: "-")
        let trans = today.components(separatedBy: "-")
        day = "\(trans[0])-\(NSString(format: "%02d",Int(trans[1])!))-\(NSString(format: "%02d",Int(trans[2])!))"
    }
}
