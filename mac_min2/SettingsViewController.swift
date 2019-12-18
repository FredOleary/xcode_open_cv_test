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
    var pauseBetweenSamples : Bool = false
    var startFrequency:Double = 15/60
    var endFrequency:Double = 600/60

    @IBOutlet weak var FilterResponse: CombinedChartView!
    @IBOutlet weak var framesPerHRSampleTextBox: UITextField!

    @IBOutlet weak var filterStartTextBox: UITextField!
    @IBOutlet weak var filterEndTextBox: UITextField!
    @IBOutlet weak var switchPauseBetweenSamples: UISwitch!


    
    @IBAction func clickPauseBetweenSamples(_ sender: Any) {
        Settings.setPauseBetweenSamples( switchPauseBetweenSamples.isOn )

    }
    @IBAction func framesPerHrSampleChanged(_ sender: Any) {
        if let fps = framesPerHRSampleTextBox?.text {
            let fpsInt: Int? = Int(fps)
            if( fpsInt != nil ){
                Settings.setFramesPerHeartRateSample( fpsInt!)
            }
        }
    }

    
    @IBAction func filterStartChanged2(_ sender: Any) {
        if let hz = filterStartTextBox?.text {
            let hzDouble: Double? = Double(hz)
            if( hzDouble != nil ){
                Settings.setFilterStart( hzDouble!)
                updateGraph()
            }
        }
    }
    
    @IBAction func filterEndChanged2(_ sender: Any) {
        if let hz = filterEndTextBox?.text {
            let hzDouble: Double? = Double(hz)
            if( hzDouble != nil ){
                Settings.setFilterEnd( hzDouble!)
                updateGraph()
            }
        }

    }
    override func viewDidLoad() {
        print("SettingsViewController - viewDidLoad")
        super.viewDidLoad()
        pauseBetweenSamples = Settings.getPauseBetweenSamples()
        switchPauseBetweenSamples.setOn(pauseBetweenSamples, animated: true )
        framesPerHRSampleTextBox.text = String( Settings.getFramesPerHeartRateSample() )
        filterStartTextBox.text = String( Settings.getFilterStart() )
        filterEndTextBox.text = String( Settings.getFilterEnd() )

        updateGraph()
    }
    func updateGraph(){
        let temporalFilter: TemporalFilter = TemporalFilter()
        let (filterResponse, freqs) = temporalFilter.getFilterResponse(
            fps: 30.0,
            filterStart: Settings.getFilterStart(),
            filterEnd: Settings.getFilterEnd(),
            startFrequency: startFrequency,
            endFrequency: endFrequency )
        
        let data = CombinedChartData()
        addLine(data, filterResponse, freqs, color:[NSUIColor.black], "RMS filter frequency response")
        addFilterBars( data, Settings.getFilterStart(), Settings.getFilterEnd() )
        
        FilterResponse.data = data
        FilterResponse.chartDescription?.text = "Filter response)"

    }
    func addLine( _ chartData:CombinedChartData, _ yData:[Double], _ xData:[Double], color:[NSUIColor], _ name:String) {
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        for i in 0..<yData.count {
            let value = ChartDataEntry(x: xData[i], y: yData[i])
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: name) //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        line1.colors = color
        chartData.lineData = LineChartData(dataSet: line1)
    }
    func addFilterBars( _ chartData:CombinedChartData, _ filterStart:Double, _ filterEnd:Double ) {
        let start = BarChartDataEntry(x: filterStart, y: 1.0)
        let end = BarChartDataEntry(x: filterEnd, y: 1.0)
        let filterBars:[BarChartDataEntry] = [start, end]
        
        let set = BarChartDataSet(entries: filterBars, label: "Filter band")
        set.setColor(NSUIColor.red)

        let data = BarChartData(dataSets: [set])
        data.barWidth = 0.05
        chartData.barData = data
    }

}

