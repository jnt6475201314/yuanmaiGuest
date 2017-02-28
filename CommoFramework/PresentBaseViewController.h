//
//  PresentBaseViewController.h
//  Working
//
//  Created by 姜宁桃 on 16/7/21.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "BaseViewController.h"

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

@interface PresentBaseViewController : BaseViewController

// ------添加向右轻扫手势------
- (void)addSwipeRightGesture;

/**
 *  添加翻页动画
 *
 *  @param type      翻页类型
 *  @param direction 翻页反向
 */
- (void)addAnimationWithType:(NSString *)type Derection:(NSString *)direction;

@end
