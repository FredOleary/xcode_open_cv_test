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
#import <opencv2/tracking.hpp>
#import <UIKit/UIKit.h>

@implementation OpenCVImageProcessor{
    UIImageView* opencvView;
    UILabel* heartrateLabel;
    cv::CascadeClassifier faceDetector;
    int frameCount;
    bool faceDetected;
    cv::Rect faceRect;
    cv::Ptr<cv::Tracker> faceTracker;
}

- (void)processImage:(cv::Mat&)image;
{
    cv::Mat grayImage;
    cv::cvtColor(image, grayImage, cv::ColorConversionCodes::COLOR_RGB2GRAY);
    cv::Rect2d trackRect;
    
    if( faceDetected ){
        bool isfound = faceTracker->update(grayImage,trackRect);
        if( isfound ){
            cv::rectangle( image, trackRect, cv::Scalar( 255, 0, 0 ), 2, 1 );
        }else{
            NSLog(@"Lost tracking");
            faceDetected = false;
        }
    }else{
        faceDetected = [self faceDetect:grayImage];
        cv::TrackerKCF::create();
        faceTracker = cv::TrackerKCF::create();
        faceTracker->init(grayImage,faceRect);
    }
    
    UIImage* outImage = [[self class] UIImageFromCVMat:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->opencvView.image = outImage;
        self->heartrateLabel.text = [NSString stringWithFormat:@"Frame: %d", ++self->frameCount];
    });

}
- (id)initWithOpenCVView:(UIImageView*)openCVView :(UILabel*)heartRateLabel{
    opencvView = openCVView;
    heartrateLabel = heartRateLabel;
    frameCount = 0;
    faceDetected = false;
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default"  ofType:@"xml"];
    const CFIndex CASCADE_NAME_LEN = 2048;
    char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)faceCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    faceDetector.load(CASCADE_NAME);

    return self;
}

- (bool) faceDetect: (cv::Mat&) image {
    std::vector<cv::Rect> faceRects;
    double scalingFactor = 1.1;
    int minNeighbors = 2;
    int flags = 0;
    cv::Size minimumSize(30,30);
    faceDetector.detectMultiScale(image, faceRects,
                                  scalingFactor, minNeighbors, flags,
                                  cv::Size(30, 30) );
    if( faceRects.size() > 0 ){
        faceRect = faceRects[0];
        NSLog(@"Face found");
        return true;
    }else{
        return false;
    }
}
+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];

    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapInfo = kCGBitmapByteOrder32Little | (
            cvMat.elemSize() == 3? kCGImageAlphaNone : kCGImageAlphaNoneSkipFirst
        );
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(
        cvMat.cols,                 //width
        cvMat.rows,                 //height
        8,                          //bits per component
        8 * cvMat.elemSize(),       //bits per pixel
        cvMat.step[0],              //bytesPerRow
        colorSpace,                 //colorspace
        bitmapInfo,                 // bitmap info
        provider,                   //CGDataProviderRef
        NULL,                       //decode
        false,                      //should interpolate
        kCGRenderingIntentDefault   //intent
    );

    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return finalImage;
}
@end
