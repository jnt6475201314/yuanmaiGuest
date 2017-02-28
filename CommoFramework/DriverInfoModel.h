//
//  DriverInfoModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/9.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DriverInfoModel : JSONModel

@property (nonatomic, copy) NSString<Optional> * models;  // 车型
@property (nonatomic, copy) NSString<Optional> * name; // 姓名
@property (nonatomic, copy) NSString<Optional> * photo;  // 照片
@property (nonatomic, copy) NSString<Optional> * tel; // 电话
@property (nonatomic, copy) NSString<Optional> * vehicle_length; // 车长
@property (nonatomic, copy) NSString<Optional> * vehicle_load; // 载重

@end
