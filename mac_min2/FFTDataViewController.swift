//
//  FFTDataViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/30/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
import Charts

class FFTDataViewController: UIViewController {

    var redAmplitude :[Double] = []
    var greenAmplitude :[Double] = []
    var blueAmplitude :[Double] = []
    var timeSeries :[Double] = []

    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FFTDataViewController - viewDidLoad")
        updateGraph()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateGraph(){
        
        let data = BarChartData()
        addBar(data, redAmplitude, timeSeries, color:[NSUIColor.red], "Red")
        addBar(data, greenAmplitude, timeSeries, color:[NSUIColor.green], "Green")
        addBar(data, blueAmplitude, timeSeries, color:[NSUIColor.blue], "Blue")

//        var barChartEntry  = [BarChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
//
//
//        //here is the for loop
//        for i in 0..<redAmplitude.count {
//
//            let value = BarChartDataEntry(x: timeSeries[i], y: redAmplitude[i]) // here we set the X and Y status in a data chart entry
//            barChartEntry.append(value) // here we add it to the data set
//        }
//
//        let bar1 = BarChartDataSet(entries: barChartEntry, label: "Number")
//        bar1.colors = [NSUIColor.red]
//
//        data.addDataSet(bar1) //Adds the line to the dataSet
        data.barWidth = 0.03

        barChart.xAxis.axisMaximum = 0 + data.groupWidth(groupSpace: 0.02, barSpace: 0.2) * Double(3)
        
        data.groupBars(fromX: 0, groupSpace: 0.02, barSpace: 0.02)
        
        barChart.data = data //finally - it adds the chart data to the chart and causes an update
        barChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
    func addBar( _ barChartData:BarChartData, _ yData:[Double], _ xData:[Double], color:[NSUIColor], _ name:String) {
        var barChartEntry  = [BarChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        for i in 0..<yData.count {
            let value = BarChartDataEntry(x: xData[i], y: yData[i]) // here we set the X and Y status in a data chart entry
            barChartEntry.append(value) // here we add it to the data set
        }

        let bar1 = BarChartDataSet(entries: barChartEntry, label: name)
        bar1.colors = color
        barChartData.addDataSet(bar1) //Adds the line to the dataSet
    }
}
