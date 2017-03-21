//
//  OrderTrackingViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/9.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "OrderTrackingViewController.h"
#import "MapView.h"

@interface OrderTrackingViewController ()
{
    MapView * _mapView;
}

@end

@implementation OrderTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    [self showBackBtn];
    
    self.titleLabel.text = @"订单追踪";
    
    [self showRightBtn:CGRectMake(screen_width-75, 24, 70, 36) withFont:systemFont(16) withTitle:@"刷新位置" withTitleColor:[UIColor whiteColor]];
    [self ConfigMapViewStartP:self.orderModel.send DestinationP:self.orderModel.arrival_address CurrentAddr:self.currentAddress UpdateTime:self.updateTime];
    
}

- (void)ConfigMapViewStartP:(NSString *)startPlace DestinationP:(NSString *)arriveAddress CurrentAddr:(NSString *)currentAddr UpdateTime:(NSString *)updateTime{
    _mapView = [[MapView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64)];
    [self.view addSubview:_mapView];
    
    NSLog(@"send:%@, arrived:%@", self.orderModel.send, self.orderModel.arrival_address);
    Place * p1 = [[Place alloc] init];
    p1.name = startPlace;
    p1.description = @"出发地";
    
    Place * p2 = [[Place alloc] init];
    p2.name = arriveAddress;
    p2.description = @"目的地";
    
    
    Place * p3 = [[Place alloc] init];
    if (_currentAddress) {
        p3.name = _currentAddress;
    }else
    {
        [self showTipView:@"获取司机位置失败！司机可能关机或不在服务区。"];
    }
    p3.description = @"司机位置";
    _mapView.distansTime = [MYFactoryManager counttIntervalOfCurrentTime:[MYFactoryManager getCurrentTime] AndPastTime:updateTime];
    
    [_mapView showRouteFrom:p1 to:p2 driverPlace:p3];
}

- (void)navRightBtnClick:(UIButton *)button
{
    [NetRequest postDataWithUrlString:API_DriverCurrentLocation_URL withParams:@{@"driver_id":self.orderModel.driver_id} success:^(id data) {
        
        NSLog(@"获取位置 data：%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:@"刷新位置成功！"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self ConfigMapViewStartP:self.orderModel.send DestinationP:self.orderModel.arrival_address CurrentAddr:data[@"data"][@"position"] UpdateTime:data[@"data"][@"add_time"]];
            });
        }else if ([data[@"code"] isEqualToString:@"2"])
        {
            [self showTipView:data[@"message"]];
        }
    } fail:^(NSString *errorDes) {
        NSLog(@"获取位置失败 error：%@", errorDes);
        [self showTipView:@"刷新位置失败！"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
