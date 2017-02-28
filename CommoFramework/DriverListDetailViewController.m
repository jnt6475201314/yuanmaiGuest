//
//  DriverListDetailViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/1.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "DriverListDetailViewController.h"

@interface DriverListDetailViewController ()
{
    UIView * _detailView;  // 青色背景
    UIImageView * _identityImgView; // 认证图片
    UIImageView * _driverHeadImgView;  // 司机头像
    UIImageView * _whitebgImageView;  // 白色背景
    
    UILabel * _nameLabel;  // 姓名
    MyPicButton * _callButton;  // 打电话按钮
}
@property (nonatomic, strong) UIAlertController * alertController;

@end

@implementation DriverListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
}

- (void)configUI{
    
    [self showBackBtn];
    self.titleLabel.text = @"司机详情";
    // 详情背景view
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, screen_height - 63)];
    _detailView.backgroundColor = color(23, 199, 189, 1);
    [self.view addSubview:_detailView];
    
    // 白色背景图片
    _whitebgImageView = [UIImageView imageViewWithFrame:CGRectMake((screen_width - 280*widthScale)/2, 46*heightScale, 280*widthScale, 350*heightScale) image:@"白色底"];
    [_detailView addSubview:_whitebgImageView];
    
    // 司机头像
    _driverHeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(50*widthScale, 80*widthScale, 70*widthScale, 70*widthScale)];
    NSString * _HeadImgUrlStr = [NSString stringWithFormat:@"http://202.91.248.43/project/Public/Uploads/driver_id/%@", self.driverModel.photo];
    NSURL * _headImgUrl = [NSURL URLWithString:_HeadImgUrlStr];
    [_driverHeadImgView sd_setImageWithURL:_headImgUrl placeholderImage:[UIImage imageNamed:@"Detail_person_default"]];
    [_detailView addSubview:_driverHeadImgView];
    
    // 认证图片
    _identityImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21*widthScale, 22*widthScale)];
    _identityImgView.image = [UIImage imageNamed:@"cell_ identificationed"];
    [_driverHeadImgView addSubview:_identityImgView];
    
    _nameLabel = [UILabel labelWithFrame:CGRectMake(_driverHeadImgView.right, 50*heightScale, 120*widthScale, 20) text:self.driverModel.name font:17 textColor:[UIColor darkTextColor]];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [_whitebgImageView addSubview:_nameLabel];
    
    // 信用星级数
    for (int i = 0; i < 5; i++) {
        UIImageView * starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_driverHeadImgView.right + i*(22*widthScale), _nameLabel.bottom+8*widthScale, 20*widthScale, 20*widthScale)];
        if (i == 0) {
            starImgView.image = [UIImage imageNamed:@"detail_star_fill"];
        }else
        starImgView.image = [UIImage imageNamed:@"detail_star_empty"];
        [_whitebgImageView addSubview:starImgView];
    }
    
    NSArray * leftTitleArray = @[@"出发地", @"目的地", @"预计里程", @"货物信息", @"发布时间"];
    NSArray * rightInfoArray = @[self.driverModel.departure_place, self.driverModel.destination, @"1005", [NSString stringWithFormat:@"车长:%@／车型:%@", self.driverModel.vehicle_length_c, self.driverModel.models_c], self.driverModel.departure_time];
    NSLog(@"%@", rightInfoArray);
    
//    获物基本信息
    for (int i = 0; i < 5; i++) {
        UITextField * _InfoTF = [MYFactoryManager createTextField:CGRectMake(30*widthScale, _driverHeadImgView.bottom + (i-1)*25*heightScale, _whitebgImageView.width - 30*widthScale - 20, 20*heightScale) withPlaceholder:nil withLeftViewTitle:leftTitleArray[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:70*widthScale withDelegate:self];
        _InfoTF.text = rightInfoArray[i];
        _InfoTF.enabled = NO;
        [_whitebgImageView addSubview:_InfoTF];
    }
    
    NSLog(@"%f", _whitebgImageView.bottom);
    _callButton = [[MyPicButton alloc] initWithFrame:CGRectMake(30*widthScale, _whitebgImageView.bottom - 125*heightScale, _whitebgImageView.width - 30*widthScale*2, 45*heightScale)];
    _callButton.backgroundColor = [UIColor blackColor];
    [_callButton setBtnViewWithImage:@"电话" withImageWidth:17*widthScale withTitle:@"电话咨询" withTitleColor:[UIColor whiteColor] withFont:boldSystemFont(20)];
    [_callButton setContentCenter];
    [_callButton addTarget:self action:@selector(callButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    _callButton.enabled = YES;
    [_callButton setBtnselectImage:nil withselectTitleColor:[UIColor yellowColor]];
    _whitebgImageView.userInteractionEnabled = YES;
    [_whitebgImageView addSubview:_callButton];
}

#pragma mark - Event Hander
- (void)callButtonEvent{
    NSLog(@"打电话给%@ %@", self.driverModel.name,self.driverModel.tel);
    
    CGPoint point =  CGPointMake(_callButton.centerX, _callButton.centerY);
    _callButton.center = CGPointMake(_callButton.centerX - 30, _callButton.centerY);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _callButton.center = point;
        
    } completion:^(BOOL finished) {
        
        [self telephoBtnEvent];
    }];
}

#pragma mark - － 打电话给远迈 － －
- (void)telephoBtnEvent
{
    _alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"打电话给：%@", self.driverModel.name] message:[NSString stringWithFormat:@"电话号码：%@", self.driverModel.tel] preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:self.alertController animated:YES completion:nil];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [_alertController addAction:cancelAction];
    UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self callServer];
    }];
    [self.alertController addAction:callAction];
}

- (void)callServer
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://057187680706"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.driverModel.tel]] options:nil completionHandler:^(BOOL success) {
        
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
