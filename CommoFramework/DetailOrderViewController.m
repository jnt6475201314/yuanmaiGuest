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
@property (nonatomic, strong) UIWebView * webView;
//{
//    UIView * _topView;
//    UIImageView * _driverHeadImgView;
//    UIImageView * _identityImgView; // 认证图片
//    
//    UIView * _middleView;
//    
//    UIView * _bottomView;
//    
//    UIButton * _leftButton;
//    UIButton * _rightButton;
//}

@end

@implementation DetailOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    [self showBackBtn];
    
    self.titleLabel.text = @"订单详情";
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64)];
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_PushlishDetailWithGid(self.orderModel.gid)]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    [self showHUD:@"数据加载中，请稍候。。。" isDim:YES];
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


#if 0
- (void)configUI{
    [self showBackBtn];
    
    self.titleLabel.text = @"订单详情";
    
    [self configTopView];
    [self configMiddleView];
    [self configBottomView];
    
    _leftButton = [UIButton buttonWithFrame:CGRectMake(40, screen_height - 80*heightScale, 100*widthScale, 40*heightScale) title:nil image:nil target:self action:@selector(leftButtonEvent:)];
    _leftButton.backgroundColor = color(74, 144, 226, 1);
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _leftButton.layer.cornerRadius = 10;
    [self.view addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithFrame:CGRectMake(screen_width - 40 - 100*widthScale, screen_height - 80*heightScale, 100*widthScale, 40*heightScale) title:nil image:nil target:self action:@selector(rightButtonEvent:)];
    _rightButton.backgroundColor = color(30, 198, 188, 1);
    _rightButton.alpha = 0.7f;
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _rightButton.layer.cornerRadius = 10;
    [self.view addSubview:_rightButton];
    
    if ([self.orderModel.order_state isEqualToString:@"待装车"]) {
        [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_rightButton setTitle:@"确认接单" forState:UIControlStateNormal];
    }else if ([self.orderModel.order_state isEqualToString:@"运输中"]){
        [_leftButton setTitle:@"订单追踪" forState:UIControlStateNormal];
        [_rightButton setTitle:@"确认到达" forState:UIControlStateNormal];
    }else if ([self.orderModel.order_state isEqualToString:@"已到达"]){
        [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [_rightButton setTitle:@"确认完成" forState:UIControlStateNormal];
    }
}

- (void)configTopView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, 120*heightScale)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    // 司机头像
    _driverHeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20*widthScale, 20*widthScale, 70*widthScale, 70*widthScale)];
    NSString * _HeadImgUrlStr = [NSString stringWithFormat:@"http://202.91.248.43/project/Public/Uploads/driver_id/%@", self.driverModel.photo];
    NSURL * _headImgUrl = [NSURL URLWithString:_HeadImgUrlStr];
    [_driverHeadImgView sd_setImageWithURL:_headImgUrl placeholderImage:[UIImage imageNamed:@"Detail_person_default"]];
    [_topView addSubview:_driverHeadImgView];
    
    // 认证图片
    _identityImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21*widthScale, 22*widthScale)];
    _identityImgView.image = [UIImage imageNamed:@"cell_ identificationed"];
    [_driverHeadImgView addSubview:_identityImgView];
    
    
    UILabel * nameLab = [UILabel labelWithFrame:CGRectMake(_driverHeadImgView.right + 5*widthScale, 20*heightScale, 60*widthScale, 20*heightScale) text:self.driverModel.name font:15 textColor:[UIColor darkTextColor]];
    [_topView addSubview:nameLab];
    
    // 信用星级数
    for (int i = 0; i < 5; i++) {
        UIImageView * starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_driverHeadImgView.right +5*widthScale+ i*(22*widthScale), nameLab.bottom+3*heightScale, 20*widthScale, 20*widthScale)];
        if (i == 0) {
            starImgView.image = [UIImage imageNamed:@"detail_star_fill"];
        }else
            starImgView.image = [UIImage imageNamed:@"detail_star_empty"];
        [_topView addSubview:starImgView];
    }
    
    UIImageView * phoneImgView = [UIImageView imageViewWithFrame:CGRectMake(_driverHeadImgView.right + 5*widthScale, nameLab.bottom + 26*heightScale, 19*widthScale, 19*widthScale) image:@"detail_phone"];
    [_topView addSubview:phoneImgView];
    
    UILabel * telLab = [UILabel labelWithFrame:CGRectMake(phoneImgView.right + 5*widthScale, nameLab.bottom + 26*heightScale, 100 * widthScale, 20*heightScale) text:self.driverModel.tel font:15 textColor:[UIColor darkTextColor]];
    [_topView addSubview:telLab];
}

- (void)configMiddleView{
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bottom+10*heightScale, screen_width, 120*heightScale)];
    _middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_middleView];
    
    //    出发地地址图标
    UIImageView * startImgView = [UIImageView imageViewWithFrame:CGRectMake(10*widthScale,10*heightScale, 17*widthScale, 21*widthScale) image:@"pub_detail_startImg"];
    [_middleView addSubview:startImgView];
    
    //    出发地地址
    UILabel * startingLabel = [UILabel labelWithFrame:CGRectMake(startImgView.right + 2*widthScale,11*heightScale, screen_width/2 - 35*widthScale, 20*heightScale) text:self.orderModel.address_f font:15 textColor:[UIColor darkTextColor]];
    startingLabel.textAlignment = NSTextAlignmentCenter;
    [_middleView addSubview:startingLabel];
    
    //    至图标
    UIImageView * toImgView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2 - 10*widthScale, 16*heightScale, 19*widthScale, 6*heightScale) image:@"pub_detail_toImg"];
    [_middleView addSubview:toImgView];
    
    //    目的地地址图标
    UIImageView * destinationImgView = [UIImageView imageViewWithFrame:CGRectMake(toImgView.right + 10*widthScale,10*heightScale, 17*widthScale, 21*widthScale) image:@"pub_detail_destionation"];
    [_middleView addSubview:destinationImgView];
    
    //    目的地地址
    UILabel * destinationLabel = [UILabel labelWithFrame:CGRectMake(destinationImgView.right + 2*widthScale,11*heightScale, screen_width/2 - 35*widthScale, 20*heightScale) text:self.orderModel.address_s font:15 textColor:[UIColor darkTextColor]];
    destinationLabel.textAlignment = NSTextAlignmentCenter;
    [_middleView addSubview:destinationLabel];
    
    NSArray * getterTitleArray = @[@"收货人", @"联系方式", @"货物类型"];
    NSString * goodsInfo = [NSString stringWithFormat:@"%@ / 体积:%@ / 重量:%@", self.orderModel.goods_type, self.orderModel.goods_size, self.orderModel.goods_load];
    NSArray * getterTextArray = @[self.orderModel.consignee_name, self.orderModel.consignee_tel, goodsInfo];
    for (int i = 0; i < 3; i++) {
        UITextField * getterInfoTF = [MYFactoryManager createTextField:CGRectMake(20*widthScale, startImgView.bottom+8*heightScale+i*24.2, screen_width - 40*widthScale, 20*heightScale) withPlaceholder:nil withLeftViewTitle:getterTitleArray[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:80*widthScale withDelegate:self];
        getterInfoTF.text = getterTextArray[i];
        getterInfoTF.enabled = NO;
        [_middleView addSubview:getterInfoTF];
    }
}

- (void)configBottomView{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _middleView.bottom + 10*heightScale, screen_width, 120*heightScale)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    

    
    NSArray * getterTitleArray = @[@"目前状态", @"订单编号", @"发布日期", @"到达时间"];
    NSArray * getterTextArray = @[self.orderModel.order_state, self.orderModel.order_number, self.orderModel.delivery_time];
    for (int i = 0; i < getterTitleArray.count; i++) {
        UITextField * getterInfoTF = [MYFactoryManager createTextField:CGRectMake(20*widthScale, 15*heightScale+i*24.2, screen_width - 40*widthScale, 20*heightScale) withPlaceholder:nil withLeftViewTitle:getterTitleArray[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:80*widthScale withDelegate:self];
        if (i !=3) {
            getterInfoTF.text = getterTextArray[i];
        }else
        {
            if (self.orderModel.complete_time) {
                getterInfoTF.text = self.orderModel.complete_time;
            }else
            {
                getterInfoTF.text = @"订单尚未到达目的地";
            }
        }
        getterInfoTF.enabled = NO;
        [_bottomView addSubview:getterInfoTF];
    }
    
}

#pragma mark - Event Hander
- (void)leftButtonEvent:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"订单追踪"]) {
        NSLog(@"订单追踪");
        OrderTrackingViewController * orderTrakingVC = [[OrderTrackingViewController alloc] init];
        orderTrakingVC.orderModel = self.orderModel;
        [self.navigationController pushViewController:orderTrakingVC animated:YES];
    }
}

- (void)rightButtonEvent:(UIButton *)btn{
    
}

#endif


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
