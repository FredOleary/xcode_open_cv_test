//
//  FilteredDataViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 12/15/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import Foundation
import Charts

class FilteredDataViewController: UIViewController, ChartReadyDelegate {

    @IBOutlet weak var lineChart: LineChartView!
    
    weak var heartRateData: HeartRateCalculation?

    override func viewDidLoad() {
        print("FilteredDataViewController - viewDidLoad")
        super.viewDidLoad()
        updateGraph()
    }

    
    func dataReady() {
        updateGraph()
    }

    func updateGraph(){
        if let timeSeries = heartRateData?.timeSeries {
            let data = LineChartData()
            if let redData = heartRateData?.filteredRedAmplitude  {
                addLine(data, redData, timeSeries, color:[NSUIColor.red], "Red")
            }
            if let greenData = heartRateData?.filteredGreenAmplitude  {
                addLine(data, greenData, timeSeries, color:[NSUIColor.green], "Green")

            }
            if let blueData = heartRateData?.filteredBlueAmplitude  {
                addLine(data, blueData, timeSeries, color:[NSUIColor.blue], "Blue")
            }
            lineChart.data = data
            lineChart.chartDescription?.text = "Filtered RGB data (Normalized)"
        }
    }
    func addLine( _ lineChartData:LineChartData, _ yData:[Double], _ xData:[Double], color:[NSUIColor], _ name:String) {
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        for i in 0..<yData.count {
            let value = ChartDataEntry(x: xData[i], y: yData[i])
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: name)
        line1.drawCirclesEnabled = false
        line1.colors = color
        lineChartData.addDataSet(line1) //Adds the line to the dataSet

    }
}
