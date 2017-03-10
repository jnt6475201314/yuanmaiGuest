//
//  AppQrCodeViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/9.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "AppQrCodeViewController.h"

@interface AppQrCodeViewController ()
{
    UIImageView * _qrImageView;
}

@end

@implementation AppQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showBackBtn];
    self.titleLabel.text = @"我的二维码";
    
    [self configUI];
}

- (void)configUI
{
    _qrImageView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2-143, screen_height/2-160, 286, 320) image:@"downApp_QrCode"];
    [self.view addSubview:_qrImageView];
    
    [self showRightBtn:CGRectMake(screen_width-45, 30, 40, 24) withImage:@"app_shareImg" withImageWidth:24];
    [self showRightBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navRightBtnClick:(UIButton *)button
{
    NSLog(@"shareButtonEvent");
    [self shareQQAndWechat:SHAREAPP_URL];
    [self shareSheetView:@"远迈物流 客户版 App下载" withImage:@"shareAppIcon"];
}

- (void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
