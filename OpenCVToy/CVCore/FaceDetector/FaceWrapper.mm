//
//  FaceWrapper.m
//  OpenCVToy
//
//  Created by Jingwei Wu on 10/02/2017.
//  Copyright © 2017 jingweiwu. All rights reserved.
//

#import "FaceWrapper.h"

@implementation FaceWrapper

- (instancetype)initWithX:(int) x
                        Y:(int) y
                    Width:(int) width
                   Height:(int) height {
    
    if (self = [super init]) {
        _x = x;
        _y = y;
        _width = width;
        _height = height;
    }
    return self;
}

@end
