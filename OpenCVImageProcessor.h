//
//  OpenCVImageProcessor.h
//  mac_min2
//
//  Created by Fred OLeary on 11/20/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/videoio/cap_ios.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVImageProcessor : NSObject<CvVideoCameraDelegate>
- (id)initWithOpenCVView:(UIImageView*)openCVView :(UILabel*)heartRateLabel;
- (void)processImage:(cv::Mat&)image;
- (bool)faceDetect: (cv::Mat&) image;
- (void)processImageRect :(cv::Mat&)image :(cv::Rect2d&) rect;

+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+(cv::Rect2d) clipRectToImage: (cv::Rect2d)clipRect :(cv::Mat&)image;

@end

NS_ASSUME_NONNULL_END
