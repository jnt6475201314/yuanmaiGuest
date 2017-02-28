//
//  OnePicSelectView.h
//  BIZCarSpider
//
//  Created by fwios001 on 16/2/19.
//  Copyright © 2016年 feiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OnePicSelectViewDelegate <NSObject>

- (void)didSelectImageView;

@end

@interface OnePicSelectView : UIImageView

@property (nonatomic,assign)BOOL isSelectPic;
@property (nonatomic,strong)NSString *defaultImg;
@property (nonatomic,strong)NSString *imgUrl;
@property(assign,nonatomic) BOOL enEdit;

@property (nonatomic,weak)id<OnePicSelectViewDelegate>selectDelegate;

@end
