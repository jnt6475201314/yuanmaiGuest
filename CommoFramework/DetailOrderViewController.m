//
//  DetailOrderViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/3.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "DetailOrderViewController.h"
#import "OrderTrackingViewController.h"  // 订单追踪

@interface DetailOrderViewController ()<UIWebViewDelegate>
{
    UIButton * _actionButton;   // 操作按钮
}
@property (nonatomic, strong) UIWebView * webView;

@end

@implementation DetailOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    [self showBackBtn];
    
    self.titleLabel.text = @"订单详情";
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 110)];
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_PushlishDetailWithGid(self.orderModel.gid)]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    [self showHUD:@"数据加载中，请稍候。。。" isDim:YES];
    
    _actionButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2 - 60, screen_height - 42, 120, 40) title:@"" image:@"" target:self action:@selector(actionButtonEvent:)];
    _actionButton.backgroundColor = red_color;
    _actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _actionButton.layer.cornerRadius = 10;
    _actionButton.clipsToBounds = YES;
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_actionButton];
    
    if ([self.orderModel.state isEqualToString:@"运输中"]) {
        [_actionButton setTitle:@"确认到达" forState:UIControlStateNormal];
        _actionButton.backgroundColor = [UIColor blueColor];
        
        [self showRightBtn:CGRectMake(screen_width-75, 24, 70, 36) withFont:systemFont(16) withTitle:@"订单追踪" withTitleColor:[UIColor whiteColor]];
    }else if ([self.orderModel.state isEqualToString:@"已到达"]) {
        [_actionButton setTitle:@"删除订单" forState:UIControlStateNormal];
//        [_params setObject:@"13" forKey:@"state"];
    }
    [self getDriverAddressAction];
}

- (void)navRightBtnClick:(UIButton *)button
{
    OrderTrackingViewController * orderTrackingVC = [[OrderTrackingViewController alloc] init];
    orderTrackingVC.orderModel = self.orderModel;
    [self showHUD:@"正在加载，请稍候。。。" isDim:YES];
    NSLog(@"%@?%@", API_DriverCurrentLocation_URL, @{@"driver_id":self.orderModel.driver_id});
    [NetRequest postDataWithUrlString:API_DriverCurrentLocation_URL withParams:@{@"driver_id":self.orderModel.driver_id} success:^(id data) {
        
        [self hideHUD];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            orderTrackingVC.currentAddress = data[@"data"][@"position"];
            orderTrackingVC.updateTime = data[@"data"][@"add_time"];
            [self.navigationController pushViewController:orderTrackingVC animated:YES];
        }else
        {
            [self showTipView:data[@"message"]];
            NSLog(@"请求司机位置失败，message：%@", data[@"message"]);
            [self.navigationController pushViewController:orderTrackingVC animated:YES];
        }
    } fail:^(NSString *errorDes) {
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"获取司机当前位置失败！请稍候重试。"];
        });
        NSLog(@"%@", errorDes);
    }];
    
}

- (void)getDriverAddressAction
{
    [NetRequest postDataWithUrlString:API_DriverCurrentLocation_URL withParams:@{@"driver_id":self.orderModel.driver_id} success:^(id data) {
        
        NSLog(@"获取位置 data：%@", data);
    } fail:^(NSString *errorDes) {
        NSLog(@"获取位置失败 error：%@", errorDes);
    }];
}

- (void)actionButtonEvent:(UIButton *)actionBtn
{
    if ([self.orderModel.state isEqualToString:@"运输中"]) {
        // 确认到达操作
        [self sureArrivedDestinationActionNetwork];
    }else if ([self.orderModel.state isEqualToString:@"已到达"]) {
        // 删除订单操作
        [self deleteOrderInfoActionNetwork];
    }
        
}

- (void)sureArrivedDestinationActionNetwork
{
    NSDictionary * params = @{@"gid":self.orderModel.gid, @"uid":GETUID};
    NSLog(@"%@?gid=%@", API_OrderAffirmArrivedAction_URL, self.orderModel.gid);
    [NetRequest postDataWithUrlString:API_OrderAffirmArrivedAction_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        NSLog(@"code:%@, message:%@", data[@"code"], data[@"message"]);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:data[@"message"]];
            [UIView animateWithDuration:0.3 animations:^{
                
                [_actionButton setTitle:@"已确认到达" forState:UIControlStateNormal];
                _actionButton.backgroundColor = [UIColor lightGrayColor];
                _actionButton.enabled = NO;
            }];
            NSLog(@"修改该信息状态成功！");
        }else if([data[@"code"] isEqualToString:@"2"]){
            NSLog(@"修改订单信息失败！");
            [self showTipView:data[@"message"]];
        }
    } fail:^(id errorDes) {
        NSLog(@"修改订单信息失败！ 失败原因：%@", errorDes);
        [self showTipView:@"修改订单信息失败！请检查网络状态或稍后再试。"];
    }];
}

- (void)deleteOrderInfoActionNetwork
{
    NSLog(@"删除发布信息");
    NSDictionary * params = @{@"gid":self.orderModel.gid, @"uid":GETUID};
    NSLog(@"%@?%@", API_DeletePublishInfo_URL, params);
    [NetRequest postDataWithUrlString:API_DeletePublishInfo_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:data[@"message"]];
            [UIView animateWithDuration:0.3 animations:^{
                
                [_actionButton setTitle:@"订单删除成功" forState:UIControlStateNormal];
                _actionButton.backgroundColor = [UIColor lightGrayColor];
                _actionButton.enabled = NO;
            }];
            NSLog(@"删除该信息成功！");
        }else if([data[@"code"] isEqualToString:@"2"]){
            NSLog(@"删除该信息失败！");
            [self showTipView:data[@"message"]];
        }
    } fail:^(id errorDes) {
        NSLog(@"删除信息失败！ 失败原因：%@", errorDes);
        [self showTipView:@"删除该信息失败！请检查网络状态或稍后再试。"];
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showTipView:[NSString stringWithFormat:@"数据请求出错，错误信息：%@", error]];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
