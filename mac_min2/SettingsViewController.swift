//
//  SettingsViewController.swift
//  mac_min2
//
//  Created by Fred OLeary on 12/5/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var pauseBetweenSamples : Bool = false
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
    }
}
