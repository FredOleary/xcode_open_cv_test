//
//  ViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/18/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit
//import OpenCVWrapper

class ViewController: UIViewController {

    @IBOutlet weak var labelFred: UILabel!
    @IBOutlet weak var buttonFred: UIButton!
    @IBOutlet weak var imageFred: UIImageView!
    
    @IBAction func sendFred(_ sender: Any) {
        labelFred.text = OpenCVWrapper.openCVVersionString()
//        let chat = UIImage(named: "seama-sales-2-mock")
//        imageFred.image = chat
        imageFred.image = OpenCVWrapper.loadImage("seama-sales-2-mock");
        buttonFred.setTitle("Yipeee", for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("\(OpenCVWrapper.openCVVersionString())")
    }


}

