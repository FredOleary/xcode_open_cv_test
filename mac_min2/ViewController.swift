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
    
    @IBOutlet weak var buttonVideo: UIButton!
    @IBOutlet weak var labelFred: UILabel!
    @IBOutlet weak var buttonFred: UIButton!
    @IBOutlet weak var imageFred: UIImageView!
    @IBOutlet weak var imageOpenCV: UIImageView!
    
    @IBAction func sendFred(_ sender: Any) {
        labelFred.text = OpenCVWrapper.openCVVersionString()
//        let chat = UIImage(named: "seama-sales-2-mock")
//        imageFred.image = chat
        imageFred.image = OpenCVWrapper.loadImage("seama-sales-2-mock");
        buttonFred.setTitle("Yipeee", for: .normal)
    }
    
    @IBAction func startVideo(_ sender: Any) {
        if( !cameraRunning ){
            cameraRunning = true;
            OpenCVWrapper.startCamera();
            buttonVideo.setTitle("Stop Video", for: .normal)
        }else{
            cameraRunning = false;
            OpenCVWrapper.stopCamera();
            buttonVideo.setTitle("Start Video", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("\(OpenCVWrapper.openCVVersionString())")
        OpenCVWrapper.initializeCamera(imageFred, imageOpenCV);
    }


}

