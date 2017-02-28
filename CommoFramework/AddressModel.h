//
//  AddressModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/22.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AddressModel : JSONModel

@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * level;
@property (nonatomic, copy) NSString<Optional> * name;
@property (nonatomic, copy) NSString<Optional> * upid;

@end
