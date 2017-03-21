//
//  OrderTrackingViewController.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/9.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"
#import "PublishLishModel.h"

@interface OrderTrackingViewController : BaseViewController

@property (nonatomic, strong) PublishLishModel * orderModel;
@property (nonatomic, strong) NSString * currentAddress;
@property (nonatomic, strong) NSString * updateTime;    // 更新位置的时间

@end
