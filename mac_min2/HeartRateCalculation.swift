//
//  HeartRateCalculation.swift
//  mac_min2
//
//  Created by Fred OLeary on 12/11/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import Foundation

class HeartRateCalculation{
    var openCVWrapper:OpenCVWrapper
    
    // Time Series
    var timeSeries: [Double]?
    
    // Raw data as captured by the image processor
    var rawRedPixels: [Double]?
    var rawGreenPixels: [Double]?
    var rawBluePixels: [Double]?
    
    // Normalized data
    var normalizedRedAmplitude: [Double]?
    var normalizedGreenAmplitude: [Double]?
    var normalizedBlueAmplitude: [Double]?

    // Filtered data
    var filteredRedAmplitude: [Double]?
    var filteredGreenAmplitude: [Double]?
    var filteredBlueAmplitude: [Double]?

    // FFT data
    var FFTRedAmplitude: [Double]?
    var FFTRedFrequency: [Double]?

    var FFTGreenAmplitude: [Double]?
    var FFTGreenFrequency: [Double]?

    var FFTBlueAmplitude: [Double]?
    var FFTBlueFrequency: [Double]?


    // Summary of heart rate calulations
    var heartRateRedFrequency: Double?
    var heartRateGreenFrequency: Double?
    var heartRateBlueFrequency: Double?
    
    // 'Calculated' HR
    var heartRateFrequency: Double?
    
    let testAccelerate = TestAccelerate()
    let fft = FFT()
    let fps = 30.0  // This may need to use calculation!!
    let useConstRGBData = false;
    
    var temporalFilter:TemporalFilter?
    
    init( _ openCVWrapper:OpenCVWrapper ){
        self.openCVWrapper = openCVWrapper
        temporalFilter = TemporalFilter()
    }
    
    func calculateHeartRate(){
        timeSeries = testAccelerate.makeTimeSeries()
        if( useConstRGBData ){
            let rgbSampleData = RGBSampleData()
            (rawRedPixels, rawGreenPixels, rawBluePixels) = rgbSampleData.getRGBData()
        }else{
            if let rawRed = openCVWrapper.getRedPixels() as NSArray as? [Double]{
                if let rawGreen = openCVWrapper.getGreenPixels() as NSArray as? [Double]{
                    if let rawBlue = openCVWrapper.getBluePixels() as NSArray as? [Double]{
                        rawRedPixels = rawRed
                        rawGreenPixels = rawGreen
                        rawBluePixels = rawBlue
                    }
                }
            }
        }
        normalizedRedAmplitude = normalizePixels( rawRedPixels! )
        normalizedGreenAmplitude = normalizePixels( rawGreenPixels! )
        normalizedBlueAmplitude = normalizePixels( rawBluePixels! )
        
        // TODO Fix up fps/fliterLoRate/filterHiRate
        let filterStart = Settings.getFilterStart()
        let filterEnd = Settings.getFilterEnd()
        filteredRedAmplitude = normalizePixels((temporalFilter?.bandpassFilter(dataIn: normalizedRedAmplitude!, sampleRate:fps, filterLoRate: filterStart, filterHiRate: filterEnd))!)
        filteredGreenAmplitude = normalizePixels((temporalFilter?.bandpassFilter(dataIn: normalizedGreenAmplitude!, sampleRate:fps, filterLoRate: filterStart, filterHiRate: filterEnd))!)
        filteredBlueAmplitude = normalizePixels((temporalFilter?.bandpassFilter(dataIn: normalizedBlueAmplitude!, sampleRate:fps, filterLoRate: filterStart, filterHiRate: filterEnd))!)
        
        (FFTRedAmplitude, FFTRedFrequency, heartRateRedFrequency) = fft.calculate( filteredRedAmplitude!, fps: fps)
        (FFTGreenAmplitude, FFTGreenFrequency, heartRateGreenFrequency) = fft.calculate( filteredGreenAmplitude!, fps: fps)
        (FFTBlueAmplitude, FFTBlueFrequency, heartRateBlueFrequency) = fft.calculate( filteredBlueAmplitude!, fps: fps)
        heartRateFrequency = heartRateGreenFrequency // May need fixup
        
   }
    
    func normalizePixels( _ pixels:[Double] ) ->[Double]{
        var xPixels = pixels
        if(pixels.count > 256){
            xPixels = pixels.suffix(256)

        }
        if(pixels.count > 0){
            let min = xPixels.min()!
            let range = xPixels.max()! - min
            return xPixels.map {($0-min)/range}
        }else{
            return pixels
        }

    }

}
