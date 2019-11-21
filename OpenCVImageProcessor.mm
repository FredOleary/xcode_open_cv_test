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
#import <UIKit/UIKit.h>

@implementation OpenCVImageProcessor{
    UIImageView* opencvView;
    UILabel* heartrateLabel;
    int frameCount;
}

- (void)processImage:(cv::Mat&)image;
{
    cv::Mat gray;
    cv::cvtColor(image, gray, cv::ColorConversionCodes::COLOR_RGB2GRAY);

//    UIImage* outImage = MatToUIImage(gray);

//    UIImage* outImage = MatToUIImage(image);
    UIImage* outImage = [[self class] UIImageFromCVMat:image];
//    UIImage* outImage = UIImageFromCVMat(image);
//    opencvView.image = outImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->opencvView.image = outImage;
//        self->heartrateLabel.text = @"foobar";
        self->heartrateLabel.text = [NSString stringWithFormat:@"Frame: %d", ++self->frameCount];
    });

    NSLog(@"foo---");
}
- (id)initWithOpenCVView:(UIImageView*)openCVView :(UILabel*)heartRateLabel{
    opencvView = openCVView;
    heartrateLabel = heartRateLabel;
    frameCount = 0;
    return self;
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
