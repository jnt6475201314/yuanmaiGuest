//
//  PublishInfoModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/26.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishInfoModel : NSObject

// 发货人基本信息
@property (nonatomic, copy) NSString * sender_company;
@property (nonatomic, copy) NSString * sender_name;
@property (nonatomic, copy) NSString * sender_tel;
@property (nonatomic, copy) NSString * sender_address;

// 收货人基本信息
@property (nonatomic, copy) NSString * getter_company;
@property (nonatomic, copy) NSString * getter_name;
@property (nonatomic, copy) NSString * getter_tel;
@property (nonatomic, copy) NSString * getter_address;

// 货物基本信息
@property (nonatomic, copy) NSString * goods_volume;
@property (nonatomic, copy) NSString * goods_loads;
@property (nonatomic, copy) NSString * goods_type;
@property (nonatomic, copy) NSString * goods_time;

@end
