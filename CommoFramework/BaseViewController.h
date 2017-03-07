//
//  BaseViewController.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define TAnimationFade kCATransitionFade  //淡入淡出
#define TAnimationPush kCATransitionPush  //推挤
#define TAnimationReveal kCATransitionReveal  //揭开
#define TAnimationMoveIn kCATransitionMoveIn //覆盖
#define TAnimationPageUnCurl @"pageUnCurl" // 反翻页
#define TAnimationPageCurl @"pageCurl" // 翻页
#define TAnimationCube @"cube" // 立方体
#define TAnimationSuckEffect @"suckEffect" // 吮吸
#define TAnimationOglFlip @"oglFlip" // 翻转
#define TAnimationRippleEffect @"rippleEffect" // 波纹
#define TAnimationCameraIrisHollowOpen @"cameraIrisHollowOpen" // 开镜头
#define TAnimationCameraIrisHollowClose @"cameraIrisHollowClose" // 关镜头

#define FAnimationFromRight kCATransitionFromRight  // 右边
#define FAnimationFromLeft kCATransitionFromLeft  // 左边
#define FAnimationFromTop kCATransitionFromTop  // 上边
#define FAnimationFromBottom kCATransitionFromBottom  // 下边

@interface BaseViewController : UIViewController

@property (nonatomic,strong)UIView *navView;
@property (nonatomic,strong)UIView *sepView;
@property (nonatomic,strong)UIImageView *backImageView;
//按钮
@property (nonatomic,strong)MyPicButton *backButton;
@property (nonatomic,strong)MyPicButton *rightButton;
@property (nonatomic,strong)MyPicButton *otherButton;
// 手势
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeRightGesture;

// 手势左
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeleftGesture;
//标题
@property (nonatomic,strong)UIImageView *titleView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)MBProgressHUD *hud;
//显示加载提示
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
//显示加载完成提示
- (void)showHUDComplete:(NSString *)title;
//隐藏加载提示
- (void)hideHUD;

//自定义提示框
- (void)showTipView:(NSString *)tipStr;
//------默认的右边按钮-------
- (void)showRightBtn;
//------自定义的右边按钮(图片)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth;
//------自定义的右边按钮(文字)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor;
//------默认的返回按钮-------
- (void)showBackBtn;
//------自定义的返回按钮(图片)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth;
//------自定义的返回按钮(文字)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor;
//------默认的其他按钮-------
- (void)showOtherBtn;
// ------添加向右轻扫手势------
- (void)addSwipeRightGesture;
// 向右轻扫手势所做的事
- (void)addSwipeGestureRightEvent:(UISwipeGestureRecognizer *)swipe;
// 添加向左轻扫手势
- (void)addSwipeLeftGesture;
// 向左轻扫手势所做的事
//- (void)addSwipeGestureLeftEvent:(UISwipeGestureRecognizer *)swipe;

//按钮事件
- (void)navRightBtnClick:(UIButton *)button;
- (void)backClick:(UIButton *)button;
- (void)navOtherBtnClick:(UIButton *)button;

//分享
- (void)shareQQAndWechat:(NSString *)urlStr;
- (void)shareController:(NSString *)shareText withImage:(NSString *)shareImage;
- (void)shareSheetView:(NSString *)shareText withImage:(NSString *)shareImage;

// 异地登录检测
- (void)checkLoginEvnet;


@end
