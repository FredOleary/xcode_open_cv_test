//
//  RawDataViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/26/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
import Charts

class RawDataViewController: UIViewController {

    var redAmplitude :[Double] = []
    var timeSeries :[Double] = []
    
    @IBOutlet weak var chtChart: LineChartView!
    

//    @IBAction func showChart(_ sender: Any) {
////        numbers = testAccelerate.makeSineWave()
//        updateGraph()
//    }
    
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

    

    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<redAmplitude.count {

            let value = ChartDataEntry(x: timeSeries[i], y: redAmplitude[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.red] 

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        

        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
}
