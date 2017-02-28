//
//  BrowsePicView.h
//  CarSpider
//
//  Created by feiwei on 16/1/30.
//  Copyright © 2016年 fwios001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowsePicView : UIView

//图片数组
@property(nonatomic,strong) NSArray *imageArray;
//点击图片的下标
@property(nonatomic,assign) NSInteger picIndex;


@end
