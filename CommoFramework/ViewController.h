//
//  ViewController.h
//  SpecialLine
//
//  Created by 姜宁桃 on 2016/12/30.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol btnClickDelegate <NSObject>

- (void)btnhaveClicked;

@end

@interface ViewController : UIViewController

@property (nonatomic,weak)id<btnClickDelegate> clickDelegate;

@end

