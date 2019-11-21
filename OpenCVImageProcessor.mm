//
//  OpenCVImageProcessor.m
//  mac_min2
//
//  Created by Fred OLeary on 11/20/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVImageProcessor.h"
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCVImageProcessor{
    UIImageView* opencvView;
}

- (void)processImage:(cv::Mat&)image;
{
    cv::Mat gray;
    cv::cvtColor(image, gray, cv::ColorConversionCodes::COLOR_RGB2GRAY);

    UIImage* outImage = MatToUIImage(gray);
//    opencvView.image = outImage;
    dispatch_async(dispatch_get_main_queue(), ^{
       self->opencvView.image = outImage;
    });

    NSLog(@"foo---");
}
- (id)initWithOpenCVView:(UIImageView*)openCVView{
    opencvView = openCVView;
    return self;
}
@end
