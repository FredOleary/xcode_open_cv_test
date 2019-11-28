//
//  test_accelerate.swift
//  mac_min2
//
//  Created by Fred OLeary on 11/26/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

import Foundation
import Accelerate

class TestAccelerate{
    
//    func makeSineWaveOld() -> [Double] {
//        let sampleSize = 300
//        let stride1: vDSP_Stride = 1
////        let sampleLength = vDSP_Length(sampleSize)
//        var start: Double = 0
//        var increment: Double = 1
//        var ramp = Doubles( n:sampleSize )
//        vDSP_vrampD( &start, &increment, &ramp, stride1, vDSP_Length( sampleSize ) )
//        var data = Doubles(n:sampleSize)
//
//        data = ramp.map( { sin( $0 / 3 ) } )
////        var numbers : [Double] = []
////        numbers.append(10)
////        numbers.append(20)
////        numbers.append(25)
////        numbers.append(15)
////        numbers.append(13)
////
////        return numbers
//        return data
//    }
    func Doubles(n: Int)->[Double] {
        return [Double](repeating:0, count:n)
    }
    
    func makeSineWave() -> [Double]{
        let n = 300 // Should be power of two for the FFT ??
        let frequency1 = 1.0
        let phase1 = 0.0
        let amplitude1 = 1.0
        let seconds = 10.0
        let fps = Double(n)/seconds

        let sineWave = (0..<n).map {
            amplitude1 * sin(2.0 * .pi / fps * Double($0) * frequency1 + phase1)
        }
        return sineWave
    }
}
