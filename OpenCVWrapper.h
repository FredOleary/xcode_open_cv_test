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

@protocol OpenCVWrapperDelegate <NSObject>
- (void)framesReady;
@end

@protocol OpenCVImageProcessorDelegate <NSObject>
- (void)framesProcessed:(int)frameCount : (NSMutableArray*) redPixels  :(NSMutableArray*) greenPixelsIn :(NSMutableArray*) bluePixelsIn;
@end

@interface OpenCVWrapper : NSObject<OpenCVImageProcessorDelegate>

@property(nonatomic, weak)id <OpenCVWrapperDelegate> delegate;

- (id) init;

- (NSString *)openCVVersionString;
- (UIImage *)loadImage: (NSString *)imageName;
- (BOOL)initializeCamera: (UIImageView *)imageView
                        : (UIImageView *)imageOpenCV
                        : (UILabel*)heartRateLabel;
- (void) startCamera;
- (void) stopCamera;

- (NSMutableArray*)getRedPixels;
- (NSMutableArray*)getGreenPixels;
- (NSMutableArray*)getBluePixels;


@end

NS_ASSUME_NONNULL_END
