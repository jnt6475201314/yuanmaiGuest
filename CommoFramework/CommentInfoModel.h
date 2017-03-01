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
@property (nonatomic, copy) NSString<Optional> * state;  // 订单状态
@property (nonatomic, copy) NSString<Optional> * comment;  // 评论星级
@property (nonatomic, copy) NSString<Optional> * comment_state;  //  是否已经评价  已评价就有值且为1，未评价无值

@property (nonatomic, copy) NSString<Optional> * send;  // 出发地
@property (nonatomic, copy) NSString<Optional> * planned_time; // 目的地
@property (nonatomic, copy) NSString<Optional> * delivery_time; // 发布时间
@property (nonatomic, copy) NSString<Optional> * driver_id; // 司机id
@property (nonatomic, copy) NSString<Optional> * add_time; // 发布时间

@property (nonatomic, copy) NSString<Optional> * total_weight;  // 货物重量
@property (nonatomic, copy) NSString<Optional> * cube; // 货物体积
@property (nonatomic, copy) NSString<Optional> * goods_type; // 货物类型
@property (nonatomic, copy) NSString<Optional> * gid; // 订单id

@property (nonatomic, copy) NSString<Optional> * uid;  // 头像
@property (nonatomic, copy) NSString<Optional> * pid; //    评论的id


@property (nonatomic, copy) NSString<Optional> * stars;  // 评价星级
@property (nonatomic, copy) NSString<Optional> * content;  // 评价内容

// 少了审核通过状态、到达日期、交易情况：交易量和发货量

@end
