//
//  UIDevice+deviceSystem.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/13.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "UIDevice+deviceSystem.h"

@implementation UIDevice (deviceSystem)

+ (BOOL)isSystemVersioniOS8 {
    //check systemVerson of device
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}

@end
