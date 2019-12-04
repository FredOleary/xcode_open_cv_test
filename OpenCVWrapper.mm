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
#import <opencv2/videoio/cap_ios.h>
#import "OpenCVImageProcessor.h"
#import <UIKit/UIKit.h>

//CvVideoCamera* videoCamera;
//OpenCVImageProcessor* imageProcessor;


@implementation OpenCVWrapper{
    CvVideoCamera* videoCamera;
    OpenCVImageProcessor* imageProcessor;
    NSMutableArray* redPixels;
    NSMutableArray* greenPixels;
    NSMutableArray* bluePixels;
}

- (id) init {
    NSLog(@"OpenCVWrapper - Init");
    return self;
}

- (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

- (UIImage *)loadImage: (NSString *)imageName{

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
- (BOOL)initializeCamera: (UIImageView *)imageView :(UIImageView *)imageOpenCV :(UILabel*)heartRateLabel{

    imageProcessor = [[OpenCVImageProcessor alloc] initWithOpenCVView:imageOpenCV:heartRateLabel :256 :self];
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    videoCamera.delegate = imageProcessor;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    return true;
}

- (void) startCamera{
    NSLog(@"Video Started---");
    [videoCamera start];
}
- (void) stopCamera{
    NSLog(@"Video Stopped---");
    [videoCamera stop];
}


- (void)framesProcessed:(int)frameCount :(NSMutableArray*) redPixelsIn :(NSMutableArray*) greenPixelsIn :(NSMutableArray*) bluePixelsIn
{
    NSLog(@"OpenCVWrapper:framesProcessed -%d, frames", frameCount);

    redPixels = [[NSMutableArray alloc] initWithArray:redPixelsIn copyItems:YES];
    greenPixels = [[NSMutableArray alloc] initWithArray:greenPixelsIn copyItems:YES];
    bluePixels = [[NSMutableArray alloc] initWithArray:bluePixelsIn copyItems:YES];
    [redPixelsIn removeAllObjects];
    [greenPixelsIn removeAllObjects];
    [bluePixelsIn removeAllObjects];
}
    
@end
