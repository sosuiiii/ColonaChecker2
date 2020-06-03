//
//  ChartFirstViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/06/01.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import RealmSwift

class ChartFirstViewController: UIViewController, ChartViewDelegate {
    
    var chart: CombinedChartView!
    var lineDataSet: BarChartDataSet!
    var bubbleDataSet: BubbleChartDataSet!
    
    @IBOutlet weak var segmentList: UISegmentedControl!
    @IBOutlet weak var segmentData: UISegmentedControl!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cases: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var pcr: UILabel!
    var pre:Results<Preference>?
    var segment = 0
    var segmentDataCount = 0
    
    override func viewDidLayoutSubviews() {
        let width = view.frame.size.width
        let height = view.frame.size.height
        var segmentListHeight:CGFloat = 0
        var segmentDataHeight:CGFloat = 0
        if height == 667 {
            segmentListHeight = 33
            segmentDataHeight = 38
        } else if height == 736 {
            segmentListHeight = 26
            segmentDataHeight = 30
        } else if height == 896 {
            segmentListHeight -= 10
            segmentDataHeight -= 10
        }
        segmentList.frame = CGRect(x: 10, y: 105 - segmentListHeight, width: width - 20, height: 20)
        segmentList.setTitle("都道府県別", forSegmentAt: 0)
        segmentList.setTitle("昇順", forSegmentAt: 1)
        segmentList.setTitle("降順", forSegmentAt: 2)
        segmentList.selectedSegmentTintColor = .init(red: 40/255, green: 72/255, blue: 104/255, alpha: 1)
        segmentList.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentList.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 0/255, green: 32/255, blue: 64/255, alpha: 1)], for: .normal)
        segmentData.frame = CGRect(x: 10, y: 135 - segmentDataHeight, width: width - 20, height: 20)
        segmentData.setTitle("感染者数", forSegmentAt: 0)
        segmentData.setTitle("PCR検査人数", forSegmentAt: 1)
        segmentData.setTitle("死者数", forSegmentAt: 2)
        segmentData.selectedSegmentTintColor = .init(red: 40/255, green: 72/255, blue: 104/255, alpha: 1)
        segmentData.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentData.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 0/255, green: 32/255, blue: 64/255, alpha: 1)], for: .normal)
        
        let leftFix:CGFloat = 120
        let rightFix:CGFloat = 30
        var labelHeight:CGFloat = 0
        var labelHeightBottom:CGFloat = 0
        if height == 667 {
            labelHeight = 100
            labelHeightBottom = 70
        } else if height == 736 {
            labelHeight = 70
            labelHeightBottom = 60
        } else if height == 812 {
            labelHeight = 50
            labelHeightBottom = 40
        } else if height == 896 {
            labelHeight = 10
            labelHeightBottom = 10
        }
        name.frame = CGRect(x: width / 2 - leftFix, y: height - 170 + labelHeight, width: 200, height: 40)
        cases.frame = CGRect(x: width / 2 + rightFix, y: height - 170 + labelHeight, width: 200, height: 40)
        deaths.frame = CGRect(x: width / 2 - leftFix, y: height - 120 + labelHeightBottom, width: 200, height: 40)
        pcr.frame = CGRect(x: width / 2 + rightFix, y: height - 120 + labelHeightBottom, width: 200, height: 40)
        name.textAlignment = .left
        cases.textAlignment = .left
        deaths.textAlignment = .left
        pcr.textAlignment = .left
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = view.frame.size
        view.backgroundColor = .systemGray6
        
        segmentList.selectedSegmentIndex = segment
        segmentData.selectedSegmentIndex = segmentDataCount
        
        name.text = "場所 "
        name.textColor = .white
        name.font = .systemFont(ofSize: 17, weight: .ultraLight)
        cases.text = "感染数 "
        cases.textColor = .white
        cases.font = .systemFont(ofSize: 17, weight: .ultraLight)
        pcr.text = "PCR数 "
        pcr.textColor = .white
        pcr.font = .systemFont(ofSize: 17, weight: .ultraLight)
        deaths.text = "死者数 "
        deaths.textColor = .white
        deaths.font = .systemFont(ofSize: 17, weight: .ultraLight)
        var chartFixHeight:CGFloat = 0
        if view.frame.size.height == 667 {
            chartFixHeight = 45
        } else if view.frame.size.height == 736 {
            chartFixHeight = 30
        } else if view.frame.size.height == 896 {
            chartFixHeight -= 20
        }
        let chartView = HorizontalBarChartView(frame: CGRect(x: 0, y: 180 - chartFixHeight, width: size.width, height: (520 - chartFixHeight )))
        chartView.legend.textColor = .white
        chartView.animate(yAxisDuration: 1.0, easingOption: .easeOutCirc)
        chartView.xAxis.labelCount = 47
        chartView.xAxis.labelTextColor = .white
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.gridBackgroundColor = .red
        chartView.leftAxis.labelTextColor = .white
        chartView.rightAxis.labelTextColor = .white
        chartView.delegate = self
            
        
        let realm = try! Realm()
        let pref = realm.objects(Preference.self)
        
        if segment == 0 {
            pre = realm.objects(Preference.self).sorted(byKeyPath: "id", ascending: false)
        } else if segment == 1 && segmentDataCount == 0 {
            pre = pref.sorted(byKeyPath: "cases", ascending: false)
        } else if segment == 1 && segmentDataCount == 1 {
            pre = pref.sorted(byKeyPath: "pcr", ascending: false)
        } else if segment == 1 && segmentDataCount == 2 {
            pre = pref.sorted(byKeyPath: "deaths", ascending: false)
        } else if segment == 2 && segmentDataCount == 0 {
            pre = pref.sorted(byKeyPath: "cases")
        } else if segment == 2 && segmentDataCount == 1 {
            pre = pref.sorted(byKeyPath: "pcr")
        } else if segment == 2 && segmentDataCount == 2 {
            pre = pref.sorted(byKeyPath: "deaths")
        }
        var labels = [pre![0].name]
        for i in 1...46 {
            labels += [pre![i].name]
        }
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
        var entrys:[BarChartDataEntry]?
        if segmentDataCount == 0 {
            entrys = [
                BarChartDataEntry(x: 0, y: Double(pre![0].cases)),
            ]
            for i in 1...46 {
                entrys! += [BarChartDataEntry(x: Double(i), y: Double(pre![i].cases))]
            }
        } else if segmentDataCount == 1 {
            entrys = [
                BarChartDataEntry(x: 0, y: Double(pre![0].pcr)),
            ]
            for i in 1...46 {
                entrys! += [BarChartDataEntry(x: Double(i), y: Double(pre![i].pcr))]
            }
        } else if segmentDataCount == 2 {
            entrys = [
                BarChartDataEntry(x: 0, y: Double(pre![0].deaths)),
            ]
            for i in 1...46 {
                entrys! += [BarChartDataEntry(x: Double(i), y: Double(pre![i].deaths))]
            }
        }
        let set = BarChartDataSet(entries: entrys, label: "県別状況")
        set.colors = [NSUIColor.init(red: 205/255, green: 203/255, blue: 100/255, alpha: 1)]
        set.valueTextColor = .white
        set.highlightColor = .init(red: 39/255, green: 148/255, blue: 52/255, alpha: 1)
        set.drawIconsEnabled = true
        chartView.data = BarChartData(dataSet: set)
        view.addSubview(chartView)
        //グラデーション
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 170 - chartFixHeight, width: size.width, height: view.frame.size.height - 100)
        gradientLayer.colors = [UIColor(red: 40/255, green: 72/255, blue: 104/255, alpha: 1).cgColor,
                                    UIColor(red: 10/255, green: 42/255, blue: 74/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y:1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func segmentListAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segment = 0
            loadView()
            viewDidLoad()
        } else if sender.selectedSegmentIndex == 1 {
            segment = 1
            loadView()
            viewDidLoad()
        } else if sender.selectedSegmentIndex == 2 {
            segment = 2
            loadView()
            viewDidLoad()
        }
    }
    @IBAction func segmentDataAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentDataCount = 0
            loadView()
            viewDidLoad()
        } else if sender.selectedSegmentIndex == 1 {
            segmentDataCount = 1
            loadView()
            viewDidLoad()
        } else if sender.selectedSegmentIndex == 2 {
            segmentDataCount = 2
            loadView()
            viewDidLoad()
        }
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {
           let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            name.text! = "場所 : \(pre![sliceIndex].name)"
            cases.text! = "感染数 : \(pre![sliceIndex].cases)"
            pcr.text! = "PCR数 : \(pre![sliceIndex].pcr)"
            deaths.text! = "死者数 : \(pre![sliceIndex].deaths)"
            
        }
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

}
