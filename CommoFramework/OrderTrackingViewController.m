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
    [self ConfigMapView];
}

- (void)ConfigMapView{
    _mapView = [[MapView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64)];
    [self.view addSubview:_mapView];
    
    Place * p1 = [[Place alloc] init];
    p1.name = self.orderModel.address_f;
    p1.description = @"出发地";
    
    Place * p2 = [[Place alloc] init];
    p2.name = self.orderModel.address_s;
    p2.description = @"目的地";
    
    
    Place * p3 = [[Place alloc] init];
    p3.name = self.orderModel.address_s;
    p3.description = @"司机位置";
    
    
    [_mapView showRouteFrom:p1 to:p2 driverPlace:p3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
