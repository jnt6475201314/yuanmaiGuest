//
//  ScanOrderViewController.h
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/4.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"

@protocol returnOrderNumDelegate <NSObject>

- (void)returnOrderNum:(NSString *)orderNum;

@end

@interface ScanOrderViewController : BaseViewController

@property (nonatomic,copy)void (^QRUrlBlock)(NSString *url);
@property (nonatomic, strong) id<returnOrderNumDelegate>Odelegate;

@property (nonatomic, copy) NSString * vcTitle;

@end
