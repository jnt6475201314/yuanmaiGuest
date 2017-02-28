//
//  BrowerView.m
//  DigWork
//
//  Created by fwios001 on 16/3/15.
//  Copyright © 2016年 feiwei. All rights reserved.
//

#import "BrowerView.h"

@interface BrowerView()

@property(strong,nonatomic) UIImageView *browerView;

@end

@implementation BrowerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    // 浏览器 brower
    _browerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self addSubview:_browerView];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    
}

- (void)setImageData:(UIImage *)imageData {
    if (_imageData != imageData) {
        _imageData = imageData;
    }
//    self.imageData.size
    CGSize picSize;
    picSize = imageData.size;
    //图片的长宽比
    float dPicAspectRatio = picSize.width/picSize.height;
    float picH = screen_width/dPicAspectRatio;
    _browerView.frame = CGRectMake(screen_width, (screen_height-50-64-picH)/2, screen_width, picH);
    _browerView.image = _imageData;
}

- (void)tapView:(UITapGestureRecognizer *)tap{
    //    [UIView animateWithDuration:0.5 animations:^{
    //        [self removeFromSuperview];
    //    }];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
    [self.layer.superlayer addAnimation:transition forKey:nil];
    [self.layer addAnimation:transition forKey:nil];
    [self removeFromSuperview];
    
}

@end
