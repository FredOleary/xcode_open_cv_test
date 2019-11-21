//
//  ViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/18/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
//import OpenCVCamera

class ViewController: UIViewController {
//    var foo = "ffoo";
//    var xfoo:String = "xxx";

    var cameraRunning:Bool = false;
    
    var openCVWrapper:OpenCVWrapper = OpenCVWrapper();
    
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var buttonVideo: UIButton!
    @IBOutlet weak var labelFred: UILabel!
    @IBOutlet weak var buttonFred: UIButton!
    @IBOutlet weak var imageFred: UIImageView!
    @IBOutlet weak var imageOpenCV: UIImageView!
    
    @IBAction func sendFred(_ sender: Any) {
        labelFred.text = openCVWrapper.openCVVersionString()
//        let chat = UIImage(named: "seama-sales-2-mock")
//        imageFred.image = chat
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
        openCVWrapper.initializeCamera(imageFred, imageOpenCV, heartRateLabel);
    }


}

