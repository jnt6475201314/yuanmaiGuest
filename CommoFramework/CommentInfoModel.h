//
//  CommentInfoModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/31.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommentInfoModel : JSONModel


@property (nonatomic, copy) NSString<Optional> * order_number;  // 订单号
@property (nonatomic, copy) NSString<Optional> * order_state;  // 订单状态
@property (nonatomic, copy) NSString<Optional> * comment;  // 评论星级
@property (nonatomic, copy) NSString<Optional> * state;  //  是否已经评价  已评价就有值且为1，未评价无值

@property (nonatomic, copy) NSString<Optional> * address_f;  // 出发地
@property (nonatomic, copy) NSString<Optional> * address_s; // 目的地
@property (nonatomic, copy) NSString<Optional> * delivery_time; // 发布时间
@property (nonatomic, copy) NSString<Optional> * driver_id; // 司机id
@property (nonatomic, copy) NSString<Optional> * name; // 姓名

@property (nonatomic, copy) NSString<Optional> * goods_load;  // 货物重量
@property (nonatomic, copy) NSString<Optional> * goods_size; // 货物体积
@property (nonatomic, copy) NSString<Optional> * goods_type; // 货物类型
@property (nonatomic, copy) NSString<Optional> * oid; // 订单id

@property (nonatomic, copy) NSString<Optional> * photo;  // 头像地址
@property (nonatomic, copy) NSString<Optional> * tel; // 电话
@property (nonatomic, copy) NSString<Optional> * vehicle_length; //  车长
@property (nonatomic, copy) NSString<Optional> * vehicle_load; //  车重
@property (nonatomic, copy) NSString<Optional> * models; // 车型

@property (nonatomic, copy) NSString<Optional> * stars;  // 评价星级
@property (nonatomic, copy) NSString<Optional> * content;  // 评价内容

// 少了审核通过状态、到达日期、交易情况：交易量和发货量

@end
