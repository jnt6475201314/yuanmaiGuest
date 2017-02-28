//
//  PresentBaseViewController.m
//  Working
//
//  Created by 姜宁桃 on 16/7/21.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "PresentBaseViewController.h"

@interface PresentBaseViewController ()


@end

@implementation PresentBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.backgroundColor = navBar_color;
    [self showBackBtn];

    [self addSwipeRightGesture];
}

// 添加向右轻扫手势
- (void)addSwipeRightGesture
{
    
    UISwipeGestureRecognizer * swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addSwipeGestureRightEvent:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer * swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addSwipeGestureRightEvent:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionDown;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:swipeDownGesture];
    [self.view addGestureRecognizer:swipeRightGesture];
}
// 向右轻扫手势所做的事
- (void)addSwipeGestureRightEvent:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight ){
        //向右轻扫做的事情
        // 向下轻扫所做的事
        [self addAnimationWithType:TAnimationMoveIn Derection:FAnimationFromLeft];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        // 向下轻扫所做的事
        [self addAnimationWithType:TAnimationMoveIn Derection:FAnimationFromBottom];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
/**
 *  添加翻页动画
 *
 *  @param type      翻页类型
 *  @param direction 翻页反向
 */
- (void)addAnimationWithType:(NSString *)type Derection:(NSString *)direction{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = type;
    animation.subtype = direction;
    [self.view.window.layer addAnimation:animation forKey:@"animation"];
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
