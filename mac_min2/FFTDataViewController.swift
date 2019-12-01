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
        var barChartEntry  = [BarChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<redAmplitude.count {

            let value = BarChartDataEntry(x: timeSeries[i], y: redAmplitude[i]) // here we set the X and Y status in a data chart entry
            barChartEntry.append(value) // here we add it to the data set
        }

        let bar1 = BarChartDataSet(entries: barChartEntry, label: "Number")
        bar1.colors = [NSUIColor.red]

        let data = BarChartData() //This is the object that will be added to the chart
        data.addDataSet(bar1) //Adds the line to the dataSet
        

        barChart.data = data //finally - it adds the chart data to the chart and causes an update
        barChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }

}
