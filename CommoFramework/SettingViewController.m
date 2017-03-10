//
//  SettingViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/9.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableView.h"

@interface SettingViewController ()<TableViewSelectedEvent>

@property (nonatomic, strong) SettingTableView * tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"设置";
    [self showBackBtn];
    
    [self configUI];
}

- (void)configUI
{
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] initWithArray:@[@"消息通知", @"异地登录", @"分享给好友"]];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - TableViewSelectedEvent
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellTitle = self.tableView.tabViewDataSource[indexPath.section];
    if ([cellTitle isEqualToString:@"分享给好友"]) {
        [self shareAppToGoodFriends];
    }
}

- (NSString *)applicationDocumentsDirectoryFile{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths firstObject];
    NSString * filePath = [documentDirectory stringByAppendingPathComponent:@"/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"%@", filePath);
    return filePath;
}

- (void)shareAppToGoodFriends
{
    [self shareQQAndWechat:SHAREAPP_URL];
    [self shareSheetView:@"远迈物流 客户版 App下载" withImage:@"shareAppIcon"];
}


#pragma mark - Getter
-(SettingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStyleGrouped cellHeight:44];
        _tableView.tableViewEventDelegate = self;
        [_tableView.mj_header removeFromSuperview];
        [_tableView.mj_footer removeFromSuperview];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIde"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
