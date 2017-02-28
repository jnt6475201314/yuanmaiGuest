//
//  ServeViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/31.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "ServeViewController.h"

@interface ServeViewController ()

@end

@implementation ServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    self.titleLabel.text = @"服务";
    [self showBackBtn];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
