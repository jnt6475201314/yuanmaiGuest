//
//  PublishLishModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PublishLishModel : JSONModel

@property (nonatomic, copy) NSString<Optional> * send; // 发货地址
@property (nonatomic, copy) NSString<Optional> * arrival_address; // 收货地址
@property (nonatomic, copy) NSString<Optional> * del; //
@property (nonatomic, copy) NSString<Optional> * total_weight;  // 货物重量
@property (nonatomic, copy) NSString<Optional> * cube;  // 货物体积
@property (nonatomic, copy) NSString<Optional> * goods_type;  // 货物类型
@property (nonatomic, copy) NSString<Optional> * order_number;  // 单号
@property (nonatomic, copy) NSString<Optional> * state;  // 货单状态
@property (nonatomic, copy) NSString<Optional> * uid;  //
@property (nonatomic, copy) NSString<Optional> * planned_time; // 装货时间
@property (nonatomic, copy) NSString<Optional> * driver_id;  // 司机id
@property (nonatomic, copy) NSString<Optional> * gid; // 收货单位
@property (nonatomic, copy) NSString<Optional> * add_time;  // 发布货源信息的时间

@end
