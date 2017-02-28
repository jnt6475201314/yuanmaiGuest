//
//  RegisterViewController.h
//  Working
//
//  Created by 姜宁桃 on 16/7/25.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "PresentBaseViewController.h"

@protocol registerDelegate <NSObject>

- (void)getRegisterTelNumber:(NSString *)user_name;

@end

@interface RegisterViewController : PresentBaseViewController

@property (nonatomic, strong) id<registerDelegate>delegate;

@end
