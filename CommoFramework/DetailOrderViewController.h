//
//  DetailOrderViewController.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/3.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderListModel.h"
#import "DriverInfoModel.h"

@interface DetailOrderViewController : BaseViewController

@property (nonatomic, strong) OrderListModel * orderModel;  // 运单模型
@property (nonatomic, strong) DriverInfoModel * driverModel;  // 司机信息模型

@end
