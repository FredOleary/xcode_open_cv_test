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
    var redMaxFrequency :Double = 0
    var greenMaxFrequency :Double = 0
    var blueMaxFrequency :Double = 0

    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FFTDataViewController - viewDidLoad")
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1), font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = barChart
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChart.marker = marker

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
        if( timeSeries.count > 0){
            let timeWidth = timeSeries[timeSeries.count-1] - timeSeries[0]; // total X time
            let groupWidth = timeWidth/Double(timeSeries.count)
            let groupSpace = groupWidth/4.0
            let barSpace = groupWidth/8.0
            let barWidth = groupWidth/8.0
            // (barSpace + barWidth) * 3 + groupSpace= groupWidth

            let data = BarChartData()
            let redFreq = NSString(format: "Red BPM %.2f", (redMaxFrequency * 60))
            let greenFreq = NSString(format: "Green BPM %.2f", (greenMaxFrequency * 60))
            let blueFreq = NSString(format: "Blue BPM %.2f", (blueMaxFrequency * 60))
            addBar(data, redAmplitude, timeSeries, color:[NSUIColor.red], redFreq as String)
            addBar(data, greenAmplitude, timeSeries, color:[NSUIColor.green], greenFreq as String)
            addBar(data, blueAmplitude, timeSeries, color:[NSUIColor.blue], blueFreq as String)

            data.barWidth = barWidth
            

            barChart.xAxis.axisMinimum = timeSeries[0];
            barChart.xAxis.axisMaximum = timeSeries[timeSeries.count-1]
            
            data.groupBars(fromX: timeSeries[0], groupSpace:groupSpace, barSpace: barSpace)
            data.setValueFont(.systemFont(ofSize: 0, weight: .light))
            
            barChart.data = data //finally - it adds the chart data to the chart and causes an update
            barChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
            barChart.legend.font = .systemFont(ofSize: 18, weight: .light)
        }
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
