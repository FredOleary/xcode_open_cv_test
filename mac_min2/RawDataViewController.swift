//
//  RawDataViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/26/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
import Charts

class RawDataViewController: UIViewController, rawDataReadyDelegate {

    var redAmplitude :[Double] = []
    var greenAmplitude :[Double] = []
    var blueAmplitude :[Double] = []
    var timeSeries :[Double] = []
    
    @IBOutlet weak var chtChart: LineChartView!
    
    
    override func viewDidLoad() {
        print("RawDataViewController - viewDidLoad")
        super.viewDidLoad()
        updateGraph()

        // Do any additional setup after loading the view.
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("RawDataViewController - init")
    }
    
//    convenience init() {
//        self.init()
//        print("init")
//    }

    func rawDataReady( _ redPixels:[Double], _ greenPixels:[Double], _ bluePixels:[Double], _ timeSeries:[Double] ) {
        redAmplitude = redPixels
        greenAmplitude = greenPixels
        blueAmplitude = bluePixels
        self.timeSeries = timeSeries
        updateGraph()

    }

    func updateGraph(){
        let data = LineChartData()
        addLine(data, redAmplitude, timeSeries, color:[NSUIColor.red], "Red")
        addLine(data, greenAmplitude, timeSeries, color:[NSUIColor.green], "Green")
        addLine(data, blueAmplitude, timeSeries, color:[NSUIColor.blue], "Blue")
        
        chtChart.data = data
        
//        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
//
//
//        //here is the for loop
//        for i in 0..<redAmplitude.count {
//
//            let value = ChartDataEntry(x: timeSeries[i], y: redAmplitude[i]) // here we set the X and Y status in a data chart entry
//            lineChartEntry.append(value) // here we add it to the data set
//        }
//
//        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Red") //Here we convert lineChartEntry to a LineChartDataSet
//        line1.drawCirclesEnabled = false
//        line1.colors = [NSUIColor.red]
//
//        let data = LineChartData() //This is the object that will be added to the chart
//        data.addDataSet(line1) //Adds the line to the dataSet
//
//        chtChart.data = data //finally - it adds the chart data to the chart and causes an update

        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
    func addLine( _ lineChartData:LineChartData, _ yData:[Double], _ xData:[Double], color:[NSUIColor], _ name:String) {
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<yData.count {
            let value = ChartDataEntry(x: xData[i], y: yData[i])
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: name) //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawCirclesEnabled = false
        line1.colors = color

//        let data = LineChartData() //This is the object that will be added to the chart
        lineChartData.addDataSet(line1) //Adds the line to the dataSet
//        chtChart.data = data //finally - it adds the chart data to the chart and causes an update

    }
}
