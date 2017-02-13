//
//  FaceWrapper.h
//  OpenCVToy
//
//  Created by Jingwei Wu on 10/02/2017.
//  Copyright © 2017 jingweiwu. All rights reserved.
//

#ifndef FaceWrapper_h
#define FaceWrapper_h

#import <Foundation/Foundation.h>

#endif /* FaceWrapper_h */

@interface FaceWrapper : NSObject

@property (readonly) int x;
@property (readonly) int y;
@property (readonly) int width;
@property (readonly) int height;
    
- (instancetype)initWithX:(int) x
                        Y:(int) y
                    Width:(int) width
                   Height:(int) height;
@end
