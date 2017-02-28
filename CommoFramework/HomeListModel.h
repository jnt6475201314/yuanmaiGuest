//
//  HomeListModel.h
//  Working
//
//  Created by 姜宁桃 on 16/8/28.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HomeListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> * departure_place;  // 出发地
@property (nonatomic, copy) NSString<Optional> * departure_time; // 发布车源信息的时间
@property (nonatomic, copy) NSString<Optional> * destination; // 目的地
@property (nonatomic, copy) NSString<Optional> * name; //  姓名
@property (nonatomic, copy) NSString<Optional> * photo;  // 司机头像
@property (nonatomic, copy) NSString<Optional> * tel;  // 司机电话
@property (nonatomic, copy) NSString<Optional> * models_c; //  车型
@property (nonatomic, copy) NSString<Optional> * vehicle_length_c; //  车长

@end
