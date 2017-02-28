//
//  UIView+addition.m
//  NewWeibo
//
//  Created by qf on 15/9/17.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "UIView+addition.h"

@implementation UIView (addition)

- (UIViewController *)viewController{
    UIResponder *responder = [self nextResponder];
    do{
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }while (responder!=nil);
    return nil;
}

@end
