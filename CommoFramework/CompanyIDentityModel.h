//
//  CompanyIDentityModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/26.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyIDentityModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * detailAddress;
@property (nonatomic, copy) NSString * tel;

@property (nonatomic, strong) NSString * company_photo;  // 营业执照
@property (nonatomic, strong) NSString * men_photo;   // 门面照
@property (nonatomic, strong) NSString * yinye_photo;  // 营业执照 + 本人合影

@end
