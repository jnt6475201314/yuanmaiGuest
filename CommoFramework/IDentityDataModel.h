//
//  IDentityDataModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/21.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDentityDataModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * ID;

@property (nonatomic, strong) UIImage * headImg;
@property (nonatomic, strong) UIImage * IDFrontImg;
@property (nonatomic, strong) UIImage * IDBackImg;
@property (nonatomic, strong) UIImage * IDPersonImg;

@end
