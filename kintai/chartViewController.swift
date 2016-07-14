//
//  chartViewController.swift
//  kintai
//
//  Created by KAMAKURAKAZUHIRO on 2016/07/14.
//  Copyright © 2016年 KAMAKURAKAZUHIRO. All rights reserved.
//

import UIKit
import Charts

class chartViewController: UIViewController {
    // storyboardから接続
    @IBOutlet weak var barChartView: BarChartView!
    var weekArray: [Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 「ud」というインスタンスをつくる。
        let ud = NSUserDefaults.standardUserDefaults()

        if ud.objectForKey("udWeek") != nil {
            let udWeek : [Double] = ud.objectForKey("udWeek") as! [Double]
            weekArray = udWeek
        }
        
        months = ["日","月","火","水","木","金","土"]
        let unitsSold = weekArray//[5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        barChartView.animate(yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = true
        barChartView.descriptionText = "アプリ起動曜日"
        
        setChart(months, values: unitsSold)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "起動回数")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData  
    }
}
