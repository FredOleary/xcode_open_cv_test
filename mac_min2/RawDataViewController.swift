//
//  RawDataViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/26/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
import Charts

class RawDataViewController: UIViewController, ChartReadyDelegate {

//    var redAmplitude :[Double] = []
//    var greenAmplitude :[Double] = []
//    var blueAmplitude :[Double] = []
//    var timeSeries :[Double] = []
    
    weak var heartRateData: HeartRateCalculation?
    
    @IBOutlet weak var chtChart: LineChartView!
    
    
    override func viewDidLoad() {
        print("RawDataViewController - viewDidLoad")
        super.viewDidLoad()
        updateGraph()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("RawDataViewController - init")
    }

    func dataReady() {
        updateGraph()
    }

    func updateGraph(){
        if let timeSeries = heartRateData!.timeSeries {
            let data = LineChartData()
            if let redData = heartRateData?.normalizedRedAmplitude  {
                addLine(data, redData, timeSeries, color:[NSUIColor.red], "Red")
            }
            if let greenData = heartRateData?.normalizedGreenAmplitude  {
                addLine(data, greenData, timeSeries, color:[NSUIColor.green], "Green")

            }
            if let blueData = heartRateData?.normalizedBlueAmplitude  {
                addLine(data, blueData, timeSeries, color:[NSUIColor.blue], "Blue")
            }
            chtChart.data = data
            chtChart.chartDescription?.text = "Raw RGB data (Normalized)"
        }
    }
    func addLine( _ lineChartData:LineChartData, _ yData:[Double], _ xData:[Double], color:[NSUIColor], _ name:String) {
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        for i in 0..<yData.count {
            let value = ChartDataEntry(x: xData[i], y: yData[i])
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: name) //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawCirclesEnabled = false
        line1.colors = color
        lineChartData.addDataSet(line1) //Adds the line to the dataSet

    }
}
