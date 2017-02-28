//
//  PicShowView.h
//  One_Snatch
//
//  Created by 小浩 on 16/5/25.
//  Copyright © 2016年 feiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

@interface PicShowView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *picView;
//分页视图
@property (nonatomic,strong)UIView *pageView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *mainPageCtrl;
@property (nonatomic,strong)UIPageControl *pageCon;

@property (nonatomic,strong)NSArray *picArr;

- (instancetype)initWithFrame:(CGRect)frame withPicHeight:(float)picHeight;

@end
