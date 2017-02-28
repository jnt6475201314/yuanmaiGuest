//
//  Place.h
//  TheDemo
//
//  Created by 姜宁桃 on 16/8/2.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject{
    NSString * name;
    NSString * description;
    double latitude;
    double longitude;
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * description;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
