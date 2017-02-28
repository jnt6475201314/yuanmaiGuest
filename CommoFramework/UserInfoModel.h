//
//  UserInfoModel.h
//  Working
//
//  Created by 姜宁桃 on 16/8/19.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserInfoModel : JSONModel

@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString<Optional> * password;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * sex;
//@property (nonatomic, copy) NSString * position;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * user_name;
//@property (nonatomic, copy) NSString * user_time;


@end
