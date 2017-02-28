//
//  ViewController.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/11.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol btnCliekDelegate <NSObject>

- (void)btnhaveClicked;

@end

@interface ViewController : UIViewController

@property (nonatomic, weak)id<btnCliekDelegate> clickDelegate;

@end

