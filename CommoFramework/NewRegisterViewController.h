//
//  NewRegisterViewController.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2017/2/27.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"

@protocol registerDelegate <NSObject>

- (void)getRegisterTelNumber:(NSString *)user_name;

@end

@interface NewRegisterViewController : BaseViewController

@property (nonatomic, strong) id<registerDelegate>delegate;

@end
