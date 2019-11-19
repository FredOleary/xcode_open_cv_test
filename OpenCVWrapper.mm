//
//  OpenCVWrapper.m
//  mac_min2
//
//  Created by Fred OLeary on 11/18/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
#import <opencv2/imgcodecs/ios.h>
#import <UIKit/UIKit.h>

@implementation OpenCVWrapper
+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}
+(UIImage *)loadImage: (NSString *)imageName{

    UIImage* resImage = [UIImage imageNamed:imageName];
    
    cv::Mat cvImage;
    UIImageToMat(resImage, cvImage);
    
    if( cvImage.data == NULL){
        return NULL;
    }else{
        cv::Mat gray;
        cv::cvtColor(cvImage, gray, cv::ColorConversionCodes::COLOR_RGB2GRAY);

        UIImage* outImage = MatToUIImage(gray);
        return outImage;
    }
}

@end
