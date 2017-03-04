//
//  ViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2016/12/30.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "ViewController.h"
#import <SDCycleScrollView.h>

@interface ViewController ()<UITextFieldDelegate, UIScrollViewDelegate, SDCycleScrollViewDelegate>
{
    UIScrollView * scrollView;
    UIPageControl *_pageControl;
}
@property (nonatomic, strong) UIButton * startButton;
@property (nonatomic, strong) NSMutableArray * guideImageArray;
@property (nonatomic, strong) SDCycleScrollView * guideScrollView;

@end

@implementation ViewController
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self Net_loadImageView];
    
}

- (void)Net_loadImageView{
    
    NSLog(@"%@", API_GETGUIDANCEIMAGE_URL);
    [NetRequest postDataWithUrlString:API_GETGUIDANCEIMAGE_URL withParams:nil success:^(id data) {
        
        NSString * guideheadImgUrl = data[@"aa"];
        NSLog(@"%@", data);
        for (NSDictionary * dict in data[@"data"]) {
            NSString * urlStr = [guideheadImgUrl stringByAppendingString:dict[@"guide1"]];
            [self.guideImageArray addObject:urlStr];
        }
        
        NSLog(@"guideImageArray_count:%ld, guideImageArray_data:%@", self.guideImageArray.count, self.guideImageArray);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.guideScrollView.imageURLStringsGroup = self.guideImageArray;
        [self.view addSubview:self.guideScrollView];
    } fail:^(NSString *errorDes) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"ViewController_GetImageArray_Error:%@", errorDes);
        [self loadImageView];
    }];
    
}

#pragma mark - SDCycleScrollViewDelegate
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"图片滚动回调:%ld", index);
    if (index == 2) {
        [UIView animateWithDuration:0.5 animations:^{
            self.startButton.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            self.startButton.alpha = 0;
        }];
    }
}


- (void)loadImageView{
    NSArray *picArr = @[@"ic_guide1",@"ic_guide2",@"ic_guide3"];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*(int)picArr.count, self.view.frame.size.height);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(screen_width/2 - 60, screen_height - 50, 120, 30)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [_pageControl addTarget:self action:@selector(actionCotrolPage:) forControlEvents:UIControlEventValueChanged];
    
    for (int i=0; i<(int)picArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = [UIImage imageNamed:[picArr objectAtIndex:i]];
        [scrollView addSubview:imageView];
        if (i == (int)picArr.count-1) {
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:self.startButton];
        }
    }
    
    //添加视图
    [self.view addSubview:scrollView];
    [self.view addSubview:_pageControl];
}

- (void)actionCotrolPage:(id)sender
{
    [scrollView setContentOffset:CGPointMake(_pageControl.currentPage * screen_width, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/screen_width;
    NSInteger index = (long)_pageControl.currentPage;
    if (index == 2) {
        [UIView animateWithDuration:0.5 animations:^{
            self.startButton.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            self.startButton.alpha = 0;
        }];
    }
}

- (void)btnClick:(UIButton *)button{
    button.center = CGPointMake(screen_width/2-40, button.center.y);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.center = CGPointMake(screen_width/2, button.center.y);
    } completion:^(BOOL finished) {
        if ([self.clickDelegate respondsToSelector:@selector(btnhaveClicked)]) {
            [self.clickDelegate btnhaveClicked];
        }
    }];
}

#pragma mark - Getter
-(NSMutableArray *)guideImageArray
{
    if (_guideImageArray == nil) {
        _guideImageArray = [[NSMutableArray alloc] init];
    }
    return _guideImageArray;
}

-(SDCycleScrollView *)guideScrollView
{
    if (!_guideScrollView) {
        _guideScrollView = [SDCycleScrollView cycleScrollViewWithFrame:screen_bounds delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _guideScrollView.currentPageDotColor = color(100, 192, 242, 1);
        [_guideScrollView adjustWhenControllerViewWillAppera];
        _guideScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _guideScrollView.autoScroll = NO;
        _guideScrollView.infiniteLoop = NO;
        _guideScrollView.backgroundColor = [UIColor blackColor];
        _guideScrollView.pageControlDotSize = CGSizeMake(15, 15);
        [_guideScrollView addSubview:self.startButton];
    }
    return _guideScrollView;
}

-(UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake((screen_width-150)/2, screen_height-100, 150, 40);
        [_startButton setTitle:@"开始体验" forState:UIControlStateNormal];
        _startButton.layer.cornerRadius = 5;
        _startButton.backgroundColor = [UIColor colorWithRed:90/255.0 green:192/255.0 blue:242/255.0 alpha:0.6];
        [_startButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _startButton.alpha = 0;
    }
    return _startButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
