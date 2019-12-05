//
//  ViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/18/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
//import OpenCVCamera

enum cameraState {
    case stopped
    case running
    case paused
}
class ViewController: UIViewController, OpenCVWrapperDelegate {
    

    var cameraRunning = cameraState.stopped;
    var showingMenu = false;
    var useConstRGBData = false;
    
    var openCVWrapper:OpenCVWrapper = OpenCVWrapper();
    let testAccelerate = TestAccelerate()
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var buttonVideo: UIButton!
    @IBOutlet weak var labelFred: UILabel!
    @IBOutlet weak var buttonFred: UIButton!
    @IBOutlet weak var imageFred: UIImageView!
    @IBOutlet weak var imageOpenCV: UIImageView!
    
    @IBAction func sendFred(_ sender: Any) {
        labelFred.text = openCVWrapper.openCVVersionString()
        imageOpenCV.image = openCVWrapper.loadImage("seama-sales-2-mock");
        imageFred.image = openCVWrapper.loadImage("seama-sales-2-mock");
        buttonFred.setTitle("Yipeee", for: .normal)
    }
    
    @IBAction func startVideo(_ sender: Any) {
        if( cameraRunning == cameraState.stopped ){
            cameraRunning = cameraState.running;
            openCVWrapper.startCamera();
            buttonVideo.setTitle("Stop Video", for: .normal)
        }else if( cameraRunning == cameraState.running ){
            cameraRunning = cameraState.stopped;
            openCVWrapper.stopCamera();
            buttonVideo.setTitle("Start Video", for: .normal)
        }else if( cameraRunning == cameraState.paused ){
            cameraRunning = cameraState.running;
            openCVWrapper.resumeCamera();
            buttonVideo.setTitle("Stop Video", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("\(openCVWrapper.openCVVersionString())")
        openCVWrapper.delegate = self
        openCVWrapper.initializeCamera(imageFred, imageOpenCV, heartRateLabel);
        
        LeadingConstraint.constant = -250
    }

    @IBAction func openMenu(_ sender: Any) {
        if(showingMenu){
            LeadingConstraint.constant = -250
        }else{
            LeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay:0.0, options: .curveEaseIn, animations:{
                self.view.layoutIfNeeded()
            })
        }
        showingMenu = !showingMenu
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let (redPixels, greenPixels, bluePixels, timeSeries) = getRawData()
        // Determine what the segue destination is

        if segue.destination is RawDataViewController
        {
            let rawDataVC = segue.destination as? RawDataViewController
            rawDataVC?.redAmplitude = redPixels
            rawDataVC?.greenAmplitude = greenPixels
            rawDataVC?.blueAmplitude = bluePixels
            rawDataVC?.timeSeries = timeSeries
            print("rawDataVC")

        }
        if segue.destination is FFTDataViewController
        {
            let FFTDataVC = segue.destination as? FFTDataViewController
            if( redPixels.count > 0){
                let fft = FFT()
                var (fftSpectrum, timeSeries, maxFrequency) = fft.calculate( redPixels, fps: 30.0)
                FFTDataVC?.redAmplitude = fftSpectrum
                FFTDataVC?.redMaxFrequency = maxFrequency
                
                (fftSpectrum, timeSeries, maxFrequency) = fft.calculate( greenPixels, fps: 30.0)
                FFTDataVC?.greenAmplitude = fftSpectrum
                FFTDataVC?.greenMaxFrequency = maxFrequency

                (fftSpectrum, timeSeries, maxFrequency) = fft.calculate( bluePixels, fps: 30.0)
                FFTDataVC?.blueAmplitude = fftSpectrum
                FFTDataVC?.blueMaxFrequency = maxFrequency

                FFTDataVC?.timeSeries = timeSeries
                
                print("FFTDataVC")
            }

        }
    }
//    func framesReady(_ videoProcessingPaused: Any) {
//        <#code#>
//    }

    func framesReady(_ videoProcessingPaused: Bool ) {
        print("ViewController: framesReady videoProcessingPaused: ", videoProcessingPaused)
        if( videoProcessingPaused){
            DispatchQueue.main.async {
                self.buttonVideo.setTitle("Resume Video", for: .normal)
                self.cameraRunning = cameraState.paused
            }
        }
    }
    
    
    func getRawData() -> (redPixels: [Double], greenPixels:[Double], bluePixels:[Double], timeSeries:[Double]){
        if( useConstRGBData ){
            let rgbSampleData = RGBSampleData()
            let (hrSampleRed, hrSampleGreen, hrSampleBlue) = rgbSampleData.getRGBData()
            let timeSeries = testAccelerate.makeTimeSeries()
            return (normalizePixels(hrSampleRed), normalizePixels(hrSampleGreen), normalizePixels(hrSampleBlue), timeSeries )
        }else{
            let timeSeries = testAccelerate.makeTimeSeries()
            if let redPixels = openCVWrapper.getRedPixels() as NSArray as? [Double]{
                if let greenPixels = openCVWrapper.getGreenPixels() as NSArray as? [Double]{
                    if let bluePixels = openCVWrapper.getBluePixels() as NSArray as? [Double]{
                        return (normalizePixels(redPixels), normalizePixels(greenPixels), normalizePixels(bluePixels), timeSeries)
                    }
                }

            }
            return ([Double](), [Double](), [Double](), [Double]())
        }
        
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

