//
//  PicShowView.m
//  One_Snatch
//
//  Created by 小浩 on 16/5/25.
//  Copyright © 2016年 feiwei. All rights reserved.
//

#import "PicShowView.h"

@implementation PicShowView

- (instancetype)initWithFrame:(CGRect)frame withPicHeight:(float)picHeight{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self _initViewWithHeight:picHeight];
    }
    return self;
}

- (void)_initViewWithHeight:(float)picHeight{
    //浏览背景
    _pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64)];
    _pageView.backgroundColor = color(0, 0, 0, 0.7);
    //添加手势
    _pageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureChange:)];
    [_pageView addGestureRecognizer:tapGesture];
    //    _pageView.alpha = 0.5;
    //图片
    _picView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, picHeight)];
    _picView.showsHorizontalScrollIndicator = NO;
    _picView.showsVerticalScrollIndicator = NO;
    _picView.clipsToBounds = NO;
    _picView.pagingEnabled = YES;
    _picView.delegate = self;
    [self addSubview:_picView];
    _mainPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _picView.bottom+10, screen_width, 20)];
    _mainPageCtrl.currentPage = 0;
    _mainPageCtrl.currentPageIndicatorTintColor = color(223, 213, 223, 1);
    _mainPageCtrl.pageIndicatorTintColor = color(235, 235, 242, 1);
    [self addSubview:_mainPageCtrl];
    for (int i=0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width*i, 0, screen_width, picHeight)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tapGesture];
        imageView.tag = 10+i;
        [_picView addSubview:imageView];
    }
    
}

- (void)setPicArr:(NSArray *)picArr {
    if (_picArr != picArr) {
        _picArr = picArr;
    }
    for (int i=0; i<picArr.count; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:10+i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[picArr objectAtIndex:i]]]placeholderImage:[UIImage imageNamed:@"secondCar"]];
        imageView.image = [UIImage imageNamed:[picArr objectAtIndex:i]];
    }
    
    //设置各个空间参数
    _picView.contentSize = CGSizeMake(screen_width*_picArr.count, _picView.height);
    _mainPageCtrl.numberOfPages = _picArr.count;
}

#pragma mark --手势
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    int index = (int)imageView.tag-10;
    //    NSLog(@"%d",index);
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64-100)];
        _scrollView.top = 64+(screen_height-64-_scrollView.height)/2;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(screen_width*_picArr.count, _scrollView.height);
        //加载图片
        for (int i=0; i<_picArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(_scrollView.width*i, 0, _scrollView.width, _scrollView.height);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[_picArr objectAtIndex:i]]]];
            [_scrollView addSubview:imageView];
        }
    }
    if (_pageCon == nil) {
        _pageCon = [[UIPageControl alloc] initWithFrame:CGRectMake(100, _scrollView.bottom-30, screen_width-100*2, 30)];
        _pageCon.numberOfPages = _picArr.count;
        _pageCon.currentPage = 0;
        _pageCon.pageIndicatorTintColor = [UIColor whiteColor];
        _pageCon.currentPageIndicatorTintColor = [UIColor grayColor];
    }
    if (![_pageView superview]) {
        [self.viewController.view addSubview:_pageView];
        [self.viewController.view addSubview:_scrollView];
        [self.viewController.view addSubview:_pageCon];
    }
    _pageCon.currentPage = index;
    _scrollView.contentOffset = CGPointMake(index*_scrollView.width, 0);
}

//缩放图片
- (void)tapGestureChange:(UITapGestureRecognizer *)tapGesture{
    if ([_pageView superview]) {
        [_pageView removeFromSuperview];
        [_scrollView removeFromSuperview];
        [_pageCon removeFromSuperview];
    }
}
#pragma  mark---UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page;
    if (scrollView == _scrollView) {
        page = _scrollView.contentOffset.x / screen_width;
        _pageCon.currentPage = page;
    }else if (scrollView == _picView) {
        page = _picView.contentOffset.x / screen_width;
        _mainPageCtrl.currentPage = page;
    }
    
}


@end
