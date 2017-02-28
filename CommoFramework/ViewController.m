//
//  ViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/11.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIScrollView * scrollView;
    UIPageControl * _pageControl;
}

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self loadImageView];
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
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((self.view.frame.size.width-150)/2, self.view.frame.size.height-100, 150, 40);
            [button setTitle:@"开始体验" forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.backgroundColor = [UIColor colorWithRed:90/255.0 green:192/255.0 blue:242/255.0 alpha:0.5];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:button];
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
}

- (void)btnClick:(UIButton *)button{
    if ([self.clickDelegate respondsToSelector:@selector(btnhaveClicked)]) {
        [self.clickDelegate btnhaveClicked];
    }
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
