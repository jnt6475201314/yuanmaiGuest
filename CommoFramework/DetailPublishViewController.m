//
//  DetailPublishViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/3.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "DetailPublishViewController.h"

@interface DetailPublishViewController ()<UIWebViewDelegate>
{
    UIButton * _actionButton;   // 操作按钮
}
@property (nonatomic, strong) UIWebView * webView;

@end

@implementation DetailPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showBackBtn];
    self.titleLabel.text = @"发布详情";
    [self configUI];
}

- (void)configUI
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 110)];
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_PushlishDetailWithGid(self.publishModel.gid)]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    [self showHUD:@"数据加载中，请稍候。。。" isDim:YES];
    
    _actionButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2 - 60, screen_height - 42, 120, 40) title:@"删除发布信息" image:@"" target:self action:@selector(actionButtonEvent:)];
    _actionButton.backgroundColor = red_color;
    _actionButton.layer.cornerRadius = 10;
    _actionButton.clipsToBounds = YES;
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_actionButton];
}

- (void)actionButtonEvent:(UIButton *)actionBtn
{
    NSDictionary * params = @{@"gid":self.publishModel.gid, @"uid":GETUID};
    NSLog(@"%@?oid=%@", API_DeletePublishInfo_URL, self.publishModel.gid);
    [NetRequest postDataWithUrlString:API_DeletePublishInfo_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:data[@"message"]];
            [UIView animateWithDuration:0.3 animations:^{
                
                [_actionButton setTitle:@"删除信息成功" forState:UIControlStateNormal];
                _actionButton.backgroundColor = [UIColor lightGrayColor];
                _actionButton.enabled = NO;
            }];
        }else if([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:data[@"message"]];
        }
        NSLog(@"删除该信息成功！");
    } fail:^(id errorDes) {
        NSLog(@"删除信息失败！ 失败原因：%@", errorDes);
        [self showTipView:@"删除发布信息失败！请检查网络状态或稍后重试。"];
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


#warning 这里也要改过了
#if 0
- (void)configUI{
    
    [self showBackBtn];
    self.titleLabel.text = @"发布详情";
    
    [self setUpTopView1];  // 顶部视图1
    [self setUpBottomView3];  // 底部视图3
    
    _repeatButton = [UIButton buttonWithFrame:CGRectMake(40, screen_height - 80*heightScale, 100*widthScale, 40*heightScale) title:@"重发" image:nil target:self action:@selector(repeatButtonEvent)];
    _repeatButton.backgroundColor = color(74, 144, 226, 1);
    [_repeatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _repeatButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _repeatButton.layer.cornerRadius = 10;
    [self.view addSubview:_repeatButton];
    
    _deleteButton = [UIButton buttonWithFrame:CGRectMake(screen_width - 40 - 100*widthScale, screen_height - 80*heightScale, 100*widthScale, 40*heightScale) title:@"删除" image:nil target:self action:@selector(deleteButtonEvent)];
    _deleteButton.backgroundColor = color(215, 4, 24, 1);
    _deleteButton.alpha = 0.7f;
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _deleteButton.layer.cornerRadius = 10;
    [self.view addSubview:_deleteButton];
}

- (void)setUpTopView1{
//    顶部视图背景
     _TopBackView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 74*heightScale, screen_width, 95*heightScale)];
    _TopBackView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_TopBackView1];
    
//    货物基本信息：导航
    UILabel * navLabel = [UILabel labelWithFrame:CGRectMake(10, 8, 140*widthScale, 20*heightScale) text:@"货物基本信息" font:16 textColor:[UIColor darkTextColor]];
    navLabel.font = [UIFont boldSystemFontOfSize:16];
    [_TopBackView1 addSubview:navLabel];
    
    NSString * currentTimeStr = [MYFactoryManager getCurrentTime];
    NSString * addtime = [MYFactoryManager counttIntervalOfCurrentTime:currentTimeStr AndPastTime:self.publishModel.add_time];
//    发布距离现在时间
    UILabel * pubTimeLabel = [UILabel labelWithFrame:CGRectMake(screen_width - 130*widthScale, 8, 120*widthScale, 20*heightScale) text:addtime font:15 textColor:color(131, 107, 31, 1)];
    pubTimeLabel.textAlignment = NSTextAlignmentRight;
    [_TopBackView1 addSubview:pubTimeLabel];
    
//    间隔线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(8, navLabel.bottom+8*heightScale, screen_width - 8, 1)];
    line.backgroundColor = navBar_color;
    [_TopBackView1 addSubview:line];
    
//    货物信息lab
    UILabel * goodsInfoLabel = [UILabel labelWithFrame:CGRectMake(20, line.bottom+4*heightScale, screen_width - 30, 20*heightScale) text:[NSString stringWithFormat:@"类型:%@ / 体积:%@ / 重量:%@", self.publishModel.goods_type, self.publishModel.cube, self.publishModel.total_weight] font:15 textColor:[UIColor darkGrayColor]];
    [_TopBackView1 addSubview:goodsInfoLabel];
    
//    装货时间lab
    UILabel * addGoodsTimeLabel = [UILabel labelWithFrame:CGRectMake(20, goodsInfoLabel.bottom+5*heightScale, screen_width - 30, 20) text:[NSString stringWithFormat:@"装货时间:%@",self.publishModel.planned_time] font:15 textColor:[UIColor darkGrayColor]];
    [_TopBackView1 addSubview:addGoodsTimeLabel];
}


- (void)setUpBottomView3{
    _BottomBackView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _TopBackView1.bottom+10*heightScale, screen_width, 264 * heightScale)];
    _BottomBackView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_BottomBackView3];
    
//    发货人／收货人基本信息：导航lab
    UILabel * navLabel = [UILabel labelWithFrame:CGRectMake(10, 8, screen_width - 40, 20*heightScale) text:@"发货人／收货人基本信息" font:16 textColor:[UIColor darkTextColor]];
    navLabel.font = [UIFont boldSystemFontOfSize:16];
    [_BottomBackView3 addSubview:navLabel];
    
    //    间隔线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(8, navLabel.bottom+8*heightScale, screen_width - 8, 1)];
    line.backgroundColor = color(67, 117, 5, 1);
    [_BottomBackView3 addSubview:line];
    
//    出发地地址图标
    UIImageView * startImgView = [UIImageView imageViewWithFrame:CGRectMake(10*widthScale,line.bottom + 6*heightScale, 17*widthScale, 21*widthScale) image:@"pub_detail_startImg"];
    [_BottomBackView3 addSubview:startImgView];
    
//    出发地地址
    UILabel * startingLabel = [UILabel labelWithFrame:CGRectMake(startImgView.right + 2*widthScale,line.bottom + 8*heightScale, screen_width/2 - 35*widthScale, 20*heightScale) text:self.publishModel.send font:15 textColor:[UIColor darkTextColor]];
    startingLabel.textAlignment = NSTextAlignmentCenter;
    [_BottomBackView3 addSubview:startingLabel];
    
//    至图标
    UIImageView * toImgView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2 - 10*widthScale, line.bottom + 13*heightScale, 19*widthScale, 6*heightScale) image:@"pub_detail_toImg"];
    [_BottomBackView3 addSubview:toImgView];
    
    //    目的地地址图标
    UIImageView * destinationImgView = [UIImageView imageViewWithFrame:CGRectMake(toImgView.right + 10*widthScale,line.bottom + 6*heightScale, 17*widthScale, 21*widthScale) image:@"pub_detail_destionation"];
    [_BottomBackView3 addSubview:destinationImgView];
    
    //    目的地地址
    UILabel * destinationLabel = [UILabel labelWithFrame:CGRectMake(destinationImgView.right + 2*widthScale,line.bottom + 8*heightScale, screen_width/2 - 35*widthScale, 20*heightScale) text:self.publishModel.arrival_address font:15 textColor:[UIColor darkTextColor]];
    destinationLabel.textAlignment = NSTextAlignmentCenter;
    [_BottomBackView3 addSubview:destinationLabel];
    
    NSArray * getterTitleArray = @[@"收货人", @"联系方式", @"公司名称"];
    NSArray * getterTextArray = @[self.publishModel.consignee_name, self.publishModel.consignee_tel, self.publishModel.receiving_unit];
    for (int i = 0; i < 3; i++) {
        UITextField * getterInfoTF = [MYFactoryManager createTextField:CGRectMake(20*widthScale, startImgView.bottom+8*heightScale+i*24.2, screen_width - 40*widthScale, 20*heightScale) withPlaceholder:nil withLeftViewTitle:getterTitleArray[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:80*widthScale withDelegate:self];
        getterInfoTF.text = getterTextArray[i];
        getterInfoTF.enabled = NO;
        [_BottomBackView3 addSubview:getterInfoTF];
    }
    
    NSArray * senderTitleArray = @[@"发货人", @"联系方式", @"公司名称"];
    NSArray * senderTextArray = @[self.publishModel.deliver_name, self.publishModel.deliver_tel, self.publishModel.forwarding_unit];
    for (int i = 0; i < 3; i++) {
        UITextField * getterInfoTF = [MYFactoryManager createTextField:CGRectMake(20*widthScale, startImgView.bottom+100*heightScale+i*24.2, screen_width - 40*widthScale, 20*heightScale) withPlaceholder:nil withLeftViewTitle:senderTitleArray[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:80*widthScale withDelegate:self];
        getterInfoTF.text = senderTextArray[i];
        getterInfoTF.enabled = NO;
        [_BottomBackView3 addSubview:getterInfoTF];
    }
}


#pragma mark - Event Handle
- (void)repeatButtonEvent{
    NSLog(@"重发");
    
    CGPoint point =  CGPointMake(_repeatButton.centerX, _repeatButton.centerY);
    _repeatButton.center = CGPointMake(_repeatButton.centerX - 20*widthScale, _repeatButton.centerY);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _repeatButton.center = point;
        
    } completion:^(BOOL finished) {
        
        [self repeatPublishInfoEvnetWithPublishModel:_publishModel];
    }];
}

- (void)deleteButtonEvent{
    NSLog(@"删除");
    
    CGPoint point =  CGPointMake(_deleteButton.centerX, _deleteButton.centerY);
    _deleteButton.center = CGPointMake(_deleteButton.centerX - 20*widthScale, _deleteButton.centerY);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _deleteButton.center = point;
        
    } completion:^(BOOL finished) {
        
        [self deletePublishInfoEventWithPublishModel:_publishModel];
    }];
}


// 删除发布信息的网络请求
- (void)deletePublishInfoEventWithPublishModel:(PublishLishModel *)infoModel
{
    NSLog(@"删除发布信息");
    [self hideHUD];
    [self showHUD:@"正在删除发布信息，请稍候。。。" isDim:YES];
    
//    NSString * urlStr = [URLHEAD stringByAppendingString:@"release_delete.html"];
    NSString * oidStr = [NSString stringWithFormat:@"%@", infoModel.oid];
    NSDictionary * params = @{@"oid":oidStr};
    NSLog(@"%@?oid=%@", API_DeletePublishInfo_URL, oidStr);
    [NetRequest getDataWithUrlString:API_DeletePublishInfo_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {

            [self hideHUD];
            [self showTipView:data[@"message"]];
            [NSThread sleepForTimeInterval:1.0]; // 设置延迟时间
            [self.navigationController popViewControllerAnimated:YES];
        }else if([data[@"code"] isEqualToString:@"2"]){
            
        }
        NSLog(@"删除该信息成功！");
    } fail:^(id errorDes) {
        NSLog(@"删除信息失败！ 失败原因：%@", errorDes);
    }];
}

// 重新发布信息的网络请求
- (void)repeatPublishInfoEvnetWithPublishModel:(PublishLishModel *)infoModel{
    
    NSLog(@"重新发布信息");
    [self showHUD:@"正在重新发布货源信息，请稍候。。。" isDim:YES];
    
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Apporder/orders.html";
    
    NSDictionary * params = @{
                              @"uid":GETUID,
                              @"forwarding_unit":infoModel.forwarding_unit,
                              @"deliver_name":infoModel.deliver_name,
                              @"deliver_tel":infoModel.deliver_tel,
                              @"f_address":infoModel.address_f,
                              @"consignee_name":infoModel.consignee_name,
                              @"consignee_tel":infoModel.consignee_tel,
                              @"s_address":infoModel.address_s,
                              @"receiving_unit":infoModel.receiving_unit,
                              @"goods_type":infoModel.goods_type,
                              @"goods_load":infoModel.goods_load,
                              @"goods_size":infoModel.goods_size,
                              @"delivery_time":infoModel.delivery_time
                              };
    
    NSLog(@"%@?%@", urlStr, params);
    [NetRequest postDataWithUrlString:urlStr withParams:params success:^(id data) {
        
        NSLog(@"data : %@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            // 重新发布信息成功，将原来的该条信息删除
            [self deletePublishInfoEventWithPublishModel:infoModel];
            [self showTipView:data[@"message"]];
        }else if ([data[@"code"] isEqualToString:@"2"]){
            NSLog(@"发布信息失败");
        }
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
        [self hideHUD];
    }];
    
}


#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
