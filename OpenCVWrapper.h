//
//  OpenCVWrapper.h
//  mac_min2
//
//  Created by Fred OLeary on 11/18/19.
//  Copyright © 2019 Fred OLeary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
+ (NSString *)openCVVersionString;
+ (UIImage *)loadImage: (NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
