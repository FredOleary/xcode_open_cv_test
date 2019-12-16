//
//  SettingsViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 12/5/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
import Charts

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var FilterResponse: LineChartView!
    
    var pauseBetweenSamples : Bool = false
    
    var filterStart:Double  = 42/60.0
    var filterEnd:Double  = 150/60
    var startFrequency:Double = 15/60
    var endFrequency:Double = 600/60
    
    @IBAction func clickPauseBetweenSamples(_ sender: Any) {
        let defaults = UserDefaults.standard
        pauseBetweenSamples = switchPauseBetweenSamples.isOn
        defaults.set(pauseBetweenSamples, forKey: settingsKeys.pauseBetweenSamples )

    }
    @IBOutlet weak var switchPauseBetweenSamples: UISwitch!

    override func viewDidLoad() {
        print("SettingsViewController - viewDidLoad")
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        pauseBetweenSamples = defaults.bool(forKey: settingsKeys.pauseBetweenSamples)
        switchPauseBetweenSamples.setOn(pauseBetweenSamples, animated: true )
        
        updateGraph()
    }
    func updateGraph(){
        let temporalFilter: TemporalFilter = TemporalFilter()
        let (filterResponse, freqs) = temporalFilter.getFilterResponse(
            fps: 30.0,
            filterStart: filterStart,
            filterEnd: filterEnd,
            startFrequency: startFrequency,
            endFrequency: endFrequency )
        
        let data = LineChartData()
        addLine(data, filterResponse, freqs, color:[NSUIColor.red], "")
        
        FilterResponse.data = data
        FilterResponse.chartDescription?.text = "Filter response)"

    }
    func addLine( _ lineChartData:LineChartData, _ yData:[Double], _ xData:[Double], color:[NSUIColor], _ name:String) {
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        for i in 0..<yData.count {
            let value = ChartDataEntry(x: xData[i], y: yData[i])
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: name) //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        line1.colors = color
        lineChartData.addDataSet(line1) //Adds the line to the dataSet

    }

}

