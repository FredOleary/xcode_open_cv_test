//
//  ViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/18/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
//import OpenCVCamera

class ViewController: UIViewController, OpenCVWrapperDelegate {

    var cameraRunning:Bool = false;
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
        if( !cameraRunning ){
            cameraRunning = true;
            openCVWrapper.startCamera();
            buttonVideo.setTitle("Stop Video", for: .normal)
        }else{
            cameraRunning = false;
            openCVWrapper.stopCamera();
            buttonVideo.setTitle("Start Video", for: .normal)
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
        let rgbSampleData = RGBSampleData()
        let (hrSampleRed, hrSampleGreen, hrSampleBlue) = rgbSampleData.getRGBData()
        // Determine what the segue destination is
        if segue.destination is RawDataViewController
        {
            let (redPixels, greenPixels, bluePixels, timeSeries) = getRawData()
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
            let fft = FFT()
            var (fftSpectrum, timeSeries, maxFrequency) = fft.calculate( hrSampleRed, fps: 30.0)
            FFTDataVC?.redAmplitude = fftSpectrum
            FFTDataVC?.redMaxFrequency = maxFrequency
            
            (fftSpectrum, timeSeries, maxFrequency) = fft.calculate( hrSampleGreen, fps: 30.0)
            FFTDataVC?.greenAmplitude = fftSpectrum
            FFTDataVC?.greenMaxFrequency = maxFrequency

            (fftSpectrum, timeSeries, maxFrequency) = fft.calculate( hrSampleBlue, fps: 30.0)
            FFTDataVC?.blueAmplitude = fftSpectrum
            FFTDataVC?.blueMaxFrequency = maxFrequency

            FFTDataVC?.timeSeries = timeSeries
            
            print("FFTDataVC")

        }
    }
    func framesReady() {
        print("++++++++++++++++++++++++++framesReady")
    }
    func getRawData() -> (redPixels: [Double], greenPixels:[Double], bluePixels:[Double], timeSeries:[Double]){
        if( useConstRGBData ){
            let rgbSampleData = RGBSampleData()
            let (hrSampleRed, hrSampleGreen, hrSampleBlue) = rgbSampleData.getRGBData()
            let timeSeries = testAccelerate.makeTimeSeries()
            return (hrSampleRed, hrSampleGreen, hrSampleBlue, timeSeries )
        }else{
            let timeSeries = testAccelerate.makeTimeSeries()
            if let redPixels = openCVWrapper.getRedPixels() as NSArray as? [Double]{
                if let greenPixels = openCVWrapper.getGreenPixels() as NSArray as? [Double]{
                    if let bluePixels = openCVWrapper.getBluePixels() as NSArray as? [Double]{
                        return (redPixels, greenPixels, bluePixels, timeSeries)
                    }
                }

            }
            return ([Double](), [Double](), [Double](), [Double]())
        }
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let rawDataVC = segue.destination as? RawDataViewController,
            let index = (Int)1
            else {
                return
        }
        rawDataVC.numbers = [1,2,3]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("foo")
        print("Id \(segue.identifier)")
        guard let rawDataVC = segue.destination as! RawDataViewController
            print("bar")
        else{
            return
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController,
            let index = tableView.indexPathForSelectedRow?.row
            else {
                return
        }
        detailViewController.contact = contacts[index]
    }
 */
}

