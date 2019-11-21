//
//  OpenCVWrapper.h
//  mac_min2
//
//  Created by Fred OLeary on 11/18/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
// NO C++ files allowed here ONLY objective C
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#ifdef __cplusplus
//    #import <opencv2/videoio/cap_ios.h>
//#endif

//@protocol CvVideoCameraDelegate <NSObject>
//#ifdef __cplusplus
//// delegate method for processing image frames
//- (void)processImage:(UIImageView *)image;
//#endif
//
//@end

//@class FooCvVideoCamera;
//
//@protocol CvVideoCameraDelegate <NSObject>
//
//#ifdef __cplusplus
//// delegate method for processing image frames
//- (void)processImage:(void*)image;
//#endif
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
//CvVideoCamera* videoCamera;

+ (NSString *)openCVVersionString;
+ (UIImage *)loadImage: (NSString *)imageName;
+ (BOOL)initializeCamera: (UIImageView *)imageView: (UIImageView *)imageOpenCV;
+ (void) startCamera;
+ (void) stopCamera;


@end

NS_ASSUME_NONNULL_END
