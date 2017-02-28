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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width*0.618, 184.0f * heightScale)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width/2-(136*widthScale*0.618)/2, 40*heightScale, 136*widthScale*0.618, 96*heightScale*0.618)];
        imageView.image = [UIImage imageNamed:@"yuanmaiLogo"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10*heightScale, screen_width*0.618, 60)];
        label.text = [NSString stringWithFormat:@"%@\n%@", userData[@"nickname"], userData[@"user_name"]];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = arc_Color;//[UIColor lightGrayColor];
        label.numberOfLines=2;
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });

}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.textColor = [UIColor groupTableViewBackgroundColor];
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
    //    if (sectionIndex == 0)
    return nil;
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    //    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    //    label.text = @"Friends Online";
    //    label.font = [UIFont systemFontOfSize:15];
    //    label.textColor = [UIColor whiteColor];
    //    label.backgroundColor = [UIColor clearColor];
    //    [label sizeToFit];
    //    [view addSubview:label];
    //    
    //    return view;
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
    
    NSArray *titles = @[@"我的信息", @"联系客服", @"意见反馈",@"安全设置", @"退出登录"];
    cell.textLabel.text = titles[indexPath.section];
    
//    NSArray * images = @[@"per_myInfo", @"per_servicer", @"per_update", @"per_suggest", @"per_safe",@"per_logOut"];
//    cell.imageView.image = [UIImage imageNamed:images[indexPath.section]];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
