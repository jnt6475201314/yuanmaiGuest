//
//  HOMEMenuViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/17.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "HOMEMenuViewController.h"

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SuggestionViewController.h"
#import "MyInfoViewController.h"
#import "SafeSettingViewController.h"
#import "AppQrCodeViewController.h"
#import "SettingViewController.h"

@interface HOMEMenuViewController ()

@property (nonatomic, strong) UIAlertController * alertController;

@end

@implementation HOMEMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * userData = GETData;
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.bounces = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width*0.618, 184.0f * heightScale)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width/2-(136*widthScale*0.618)/2, 40*heightScale, 136*widthScale*0.618, 96*heightScale*0.618)];
        imageView.image = [UIImage imageNamed:@"yuanmaiLogo"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 5*heightScale, screen_width*0.618, 60)];
        label.text = [NSString stringWithFormat:@"%@\n%@", userData[@"nickname"], userData[@"user_name"]];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor purpleColor];//[UIColor lightGrayColor];
        label.numberOfLines=2;
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, screen_width, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:lineView];
        view;
    });
    
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height - (self.view.height-self.tableView.tableHeaderView.height-250), screen_width*0.618, screen_height-self.tableView.tableHeaderView.height-250)];
        view.backgroundColor = [UIColor lightGrayColor];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        UIButton * QRCodeBtn = [UIButton buttonWithFrame:CGRectMake(view.width - 45, view.height - 45*heightScale, 40, 40) title:nil image:@"qrCode" target:self action:@selector(QRCodeBtnEvent)];
        
        MyPicButton * _settingButton = [[MyPicButton alloc] initWithFrame:CGRectMake(0, view.height-45*heightScale, view.width - 60, 40)];
        [_settingButton setBtnViewWithImage:@"setting" withImageWidth:40 withTitle:@"设置" withTitleColor:color(18, 150, 220, 1) withFont:boldSystemFont(17)];
        [_settingButton setBtnselectImage:@"setting" withselectTitleColor:color(18, 150, 220, 1)];
        [_settingButton setTitleColor:color(18, 150, 220, 1) forState:UIControlStateHighlighted];
        [_settingButton addTarget:self action:@selector(settingButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_settingButton];
        
        [view addSubview:QRCodeBtn];
        [view addSubview:lineView];
        view;
    });

}

#pragma mark - Event Hander
- (void)settingButtonEvent
{
    NSLog(@"setting");
    SettingViewController * settingVC = [[SettingViewController alloc] init];
    [self presentViewController:settingVC animated:YES completion:nil];
}


- (void)QRCodeBtnEvent
{
    AppQrCodeViewController * QRCodeVC = [[AppQrCodeViewController alloc] init];
    [self presentViewController:QRCodeVC animated:YES completion:nil];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 我的信息
        MyInfoViewController * myInfoVC = [[MyInfoViewController alloc] init];
        [self presentViewController:myInfoVC animated:YES completion:nil];
    }else if (indexPath.section == 1){
        // 联系客服
        [self telephoBtnEvent];
    }else if (indexPath.section == 2){
        // 意见反馈
        SuggestionViewController * suggestionVC = [[SuggestionViewController alloc] init];
        [self presentViewController:suggestionVC animated:YES completion:nil];
    }else if (indexPath.section == 3){
        // 安全设置
        SafeSettingViewController * safeSettingVC = [[SafeSettingViewController alloc] init];
        [self presentViewController:safeSettingVC animated:YES completion:nil];
    }else if (indexPath.section == 4){
        // 退出登录
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        AppDelegateInstance.window.rootViewController = loginVC;
    }
}

#pragma mark - － 打电话给远迈 － －
- (void)telephoBtnEvent
{
    NSLog(@"tel");
    _alertController = [UIAlertController alertControllerWithTitle:@"远迈客服💁" message:@"☎️：0571-28973920" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:self.alertController animated:YES completion:nil];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [_alertController addAction:cancelAction];
    UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://057128973920"]];
    }];
    [self.alertController addAction:callAction];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    
    return nil;
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray * images = @[@"personal", @"connectServer", @"suggestion", @"safeSet", @"logOut"];
    NSArray *titles = @[@"我的信息", @"联系客服", @"意见反馈",@"安全设置", @"退出登录"];
    cell.textLabel.text = titles[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.section]];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
