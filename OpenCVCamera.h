//
//  OpenCVCamera.h
//  mac_min2
//
//  Created by Fred OLeary on 11/19/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

//#import <opencv2/videoio/cap_ios.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVCamera : NSObject
//    @property (nonatomic, retain)  CvVideoCamera* videoCamera;
    - (BOOL)initialize: (UIImageView *)imageView;


@end

NS_ASSUME_NONNULL_END
