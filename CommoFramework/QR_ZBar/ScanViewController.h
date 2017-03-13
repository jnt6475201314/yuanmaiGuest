//
//  ScanViewController.h
//  QRCode
//
//  Created by Apple on 16/5/9.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol returnOrderNumDelegate <NSObject>

- (void)returnOrderNum:(NSString *)orderNum;

@end

@interface ScanViewController : UIViewController

@property (nonatomic,copy)void (^QRUrlBlock)(NSString *url);
@property (nonatomic, strong) id<returnOrderNumDelegate>Odelegate;

@property (nonatomic, copy) NSString * upVCTitle;

@end
