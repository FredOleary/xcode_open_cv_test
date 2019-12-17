//
//  Settings.swift
//  mac_min2
//
//  Created by Fred OLeary on 12/17/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import Foundation
class Settings {
    static var framesPerHeartRateSample = 300
    
    struct settingsKeys {
        static let pauseBetweenSamples = "pauseBetweenSamples"
        static let framesPerHeartRateSample = "framesPerHeartRateSample"
    }

    static func getFramesPerHeartRateSample() -> Int {
        let defaults = UserDefaults.standard
        if self.checkIfKeyExists(settingsKeys.framesPerHeartRateSample){
            return defaults.integer(forKey: settingsKeys.framesPerHeartRateSample)
        }
        return framesPerHeartRateSample
    }
    static func setFramesPerHeartRateSample( _ fps:Int) {
        let defaults = UserDefaults.standard
        defaults.set(fps, forKey: settingsKeys.framesPerHeartRateSample)
    }

    static func getPauseBetweenSamples() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: settingsKeys.pauseBetweenSamples)
    }
    static func setPauseBetweenSamples( _ pause:Bool) {
        let defaults = UserDefaults.standard
        defaults.set(pause, forKey: settingsKeys.pauseBetweenSamples )
    }
    
    static private func checkIfKeyExists( _ key:String) -> Bool {
        if (UserDefaults.standard.object(forKey:key) != nil ){
            return true
        }
        return false
    }

}
