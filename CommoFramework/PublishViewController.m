//
//  PublishViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "PublishViewController.h"
#import "PublishTableView.h"
#import "PublishTableViewCell.h"
#import "PublishLishModel.h"
#import "PublishGoodsViewController.h"
#import "DetailPublishViewController.h"

@interface PublishViewController ()<TableViewSelectedEvent>
{
    NSInteger _page;
    UIButton * _publishButton;
}
@property (nonatomic, strong) PublishTableView * tableView;
@property (nonatomic, strong) PublishLishModel * publishModel;

@end

@implementation PublishViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    self.titleLabel.text = @"我的发布";
    [self showRightBtn:CGRectMake(self.navView.width - 45*widthScale, 24, 40*widthScale, 36) withFont:systemFont(16) withTitle:@"发布" withTitleColor:[UIColor whiteColor]];
    
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
    
    _publishButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2 - (80*widthScale)/2, screen_height - 100*heightScale, 80*widthScale, 35*heightScale) title:@"发布" image:nil target:self action:@selector(publishButtonEvent)];
    _publishButton.backgroundColor = navBar_color;// [UIColor orangeColor];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _publishButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _publishButton.layer.cornerRadius = 10;
    [self.view addSubview:_publishButton];
    

}

#pragma mark - Event Hander
- (void)publishButtonEvent{
    NSLog(@"发布");
    PublishGoodsViewController * pubGoodsVC = [[PublishGoodsViewController alloc] init];
    [self.navigationController pushViewController:pubGoodsVC animated:YES];
}

-(void)navRightBtnClick:(UIButton *)button{
    // 发布消息
    [self publishButtonEvent];
}

#pragma mark - TableViewSelectedEvent
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailPublishViewController * detailPublishVC = [[DetailPublishViewController alloc] init];
    detailPublishVC.publishModel = self.tableView.tabViewDataSource[indexPath.section];
    [self.navigationController pushViewController:detailPublishVC animated:YES];
}

-(void)headerRefreshingEvent
{
    _page = 1;
    [self showHUD:@"数据加载中，请稍候。。" isDim:YES];
    
    NSDictionary * params = @{@"uid":GETUID, @"p":[NSString stringWithFormat:@"%ld", _page]};
    NSLog(@"%@?uid=%@", API_PublishOrderList_URL, GETUID);
    [NetRequest postDataWithUrlString:API_PublishOrderList_URL withParams:params success:^(id data) {
        [self.tableView.tabViewDataSource removeAllObjects];
        NSLog(@"%@", data);
        [self hideHUD];
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 获取发布信息列表成功
            if ([data[@"data"] count] > 0) {
                for (NSDictionary * dict in data[@"data"]) {
                    _publishModel = [[PublishLishModel alloc] initWithDictionary:dict error:nil];
                    [self.tableView.tabViewDataSource addObject:_publishModel];
                }
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }
        }else if([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:@"暂无数据，请点击发布按钮发布货源消息"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
        
    } fail:^(id errorDes) {
        
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self showTipView:@"数据请求出错！"];
        NSLog(@"%@", errorDes);
    }];
}

-(void)footerRefreshingEvent{
    _page++;
    
    NSDictionary * params = @{@"uid":GETUID, @"p":[NSString stringWithFormat:@"%ld", _page]};
    NSLog(@"%@?uid=%@", API_PublishOrderList_URL, GETUID);
    [NetRequest postDataWithUrlString:API_PublishOrderList_URL withParams:params success:^(id data) {
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 获取发布信息列表成功
            if ([data[@"data"] count] > 0) {
                for (NSDictionary * dict in data[@"data"]) {
                    _publishModel = [[PublishLishModel alloc] initWithDictionary:dict error:nil];
                    [self.tableView.tabViewDataSource addObject:_publishModel];
                }
            }
        }else if([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:@"点击发布按钮发布更多货源消息"];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
        [self.tableView.mj_footer endRefreshing];
        [self showTipView:@"数据请求出错！"];
    }];
}

#pragma mark - Getter
-(PublishTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[PublishTableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 110) style:UITableViewStyleGrouped cellHeight:90];
        _tableView.tableViewEventDelegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"PublishTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableViewIdentifier];
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
