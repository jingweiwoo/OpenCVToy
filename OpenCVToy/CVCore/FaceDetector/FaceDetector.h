//
//  FaceDetector.h
//  OpenCVToy
//
//  Created by Jingwei Wu on 09/02/2017.
//  Copyright © 2017 jingweiwu. All rights reserved.
//

#ifndef FaceDetector_h
#define FaceDetector_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FaceWrapper.h"

#endif /* FaceDetector_h */

@interface FaceDetector: NSObject

- (id)init;

- (NSArray<FaceWrapper *> *)detectFace:(UIImage *)image;

- (UIImage *)drawFrameOnFace:(NSArray<FaceWrapper *> *)wrappedFaces
                   withImage:(UIImage *)image
             imageScaleRatio:(CGFloat)ratio;

@end
