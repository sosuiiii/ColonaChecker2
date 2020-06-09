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
    let colors = Colors.init()
    
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
        
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 25, width: 60, height: 30)
        backButton.setTitle("戻る", for: .normal)
        backButton.setTitleColor(colors.white, for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        
        let nextButton = UIButton(type: .system)
        nextButton.frame = CGRect(x: view.frame.size.width - 105, y: 25, width: 100, height: 30)
        nextButton.setTitle("円グラフ", for: .normal)
        nextButton.setTitleColor(colors.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(goCircle), for: .touchUpInside)
        view.addSubview(nextButton)
        
        segmentList.frame = CGRect(x: 10, y: 105 - segmentListHeight, width: width - 20, height: 20)
        segmentList.setTitle("都道府県別", forSegmentAt: 0)
        segmentList.setTitle("昇順", forSegmentAt: 1)
        segmentList.setTitle("降順", forSegmentAt: 2)
        segmentList.selectedSegmentTintColor = colors.blue
        segmentList.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentList.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.bluePurple], for: .normal)
        segmentData.frame = CGRect(x: 10, y: 135 - segmentDataHeight, width: width - 20, height: 20)
        segmentData.setTitle("感染者数", forSegmentAt: 0)
        segmentData.setTitle("PCR検査人数", forSegmentAt: 1)
        segmentData.setTitle("死者数", forSegmentAt: 2)
        segmentData.selectedSegmentTintColor = colors.blue
        segmentData.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentData.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.bluePurple], for: .normal)
        
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
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        gradientLayer.colors = [colors.bluePurple.cgColor,
                                colors.blue.cgColor,
                                /*colors.blue.cgColor,
                                colors.blueGreen.cgColor*/]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        view.layer.insertSublayer(gradientLayer, at:0)
        
        segmentList.selectedSegmentIndex = segment
        segmentData.selectedSegmentIndex = segmentDataCount
        
        name.text = "場所 "
        name.textColor = colors.bluePurple
        name.font = .systemFont(ofSize: 17, weight: .medium)
        cases.text = "感染数 "
        cases.textColor = colors.bluePurple
        cases.font = .systemFont(ofSize: 17, weight: .medium)
        pcr.text = "PCR数 "
        pcr.textColor = colors.bluePurple
        pcr.font = .systemFont(ofSize: 17, weight: .medium)
        deaths.text = "死者数 "
        deaths.textColor = colors.bluePurple
        deaths.font = .systemFont(ofSize: 17, weight: .medium)
        var chartFixHeight:CGFloat = 0
        if view.frame.size.height == 667 {
            chartFixHeight = 45
        } else if view.frame.size.height == 736 {
            chartFixHeight = 30
        } else if view.frame.size.height == 896 {
            chartFixHeight -= 20
        }
        let chartView = HorizontalBarChartView(frame: CGRect(x: 0, y: 180 - chartFixHeight, width: size.width, height: (520 - chartFixHeight )))
        chartView.legend.textColor = colors.bluePurple
        chartView.animate(yAxisDuration: 1.0, easingOption: .easeOutCirc)
        chartView.xAxis.labelCount = 47
        chartView.xAxis.labelTextColor = colors.bluePurple
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.leftAxis.labelTextColor = colors.bluePurple
        chartView.rightAxis.labelTextColor = colors.bluePurple
        chartView.delegate = self
        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.legend.enabled = false
            
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
        set.colors = [colors.blue]
        set.valueTextColor = colors.bluePurple
        set.highlightColor = colors.green
        set.drawIconsEnabled = true
        chartView.data = BarChartData(dataSet: set)
        view.addSubview(chartView)
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
    @objc func backButtonAction(){
        dismiss(animated: true, completion: nil)
    }
    @objc func goCircle(){
        performSegue(withIdentifier: "goCircle", sender: nil)
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

}
