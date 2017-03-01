//
//  CommentsViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/21.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableView.h"
#import "CommentTableViewCell.h"
#import "CommentInfoModel.h"

#import "CommentsDetailViewController.h"

@interface CommentsViewController ()<TableViewSelectedEvent>
{
    NSInteger _page;
    UIButton * _publishButton;
}
@property (nonatomic, strong) CommentTableView * tableView;
@property (nonatomic, strong) CommentInfoModel * commentModel;

@end

@implementation CommentsViewController
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
    self.titleLabel.text = @"评价司机";
    [self showBackBtn];
    
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableViewSelectedEvent
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsDetailViewController * commentDetailVC = [[CommentsDetailViewController alloc] init];
    commentDetailVC.commentModel = self.tableView.tabViewDataSource[indexPath.section];
    [self.navigationController pushViewController:commentDetailVC animated:YES];
}

-(void)headerRefreshingEvent
{
    _page = 1;
    [self showHUD:@"数据加载中，请稍候。。" isDim:YES];
    
    NSDictionary * params = @{@"uid":GETUID, @"p":[NSString stringWithFormat:@"%ld", _page]};
    NSLog(@"%@?uid=%@", API_CommentList_URL, GETUID);
    [NetRequest postDataWithUrlString:API_CommentList_URL withParams:params success:^(id data) {
        [self.tableView.tabViewDataSource removeAllObjects];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 获取发布信息列表成功
            if ([data[@"data"] count] > 0) {
                for (NSDictionary * dict in data[@"data"]) {
                    NSError * error = [[NSError alloc] init];
                    _commentModel = [[CommentInfoModel alloc] initWithDictionary:dict error:&error];
                    [self.tableView.tabViewDataSource addObject:_commentModel];
                }
                [self.tableView.mj_header endRefreshing];
                
            }
        }else if([data[@"code"] isEqualToString:@"2"]){
            if ([data[@"message"] isEqualToString:@"查询数据失败"]) {
                [self showTipView:@"暂无评价数据"];
            }
            [self showTipView:data[@"message"]];
            [self.tableView.mj_header endRefreshing];
        }
        [self hideHUD];
        [self.tableView reloadData];
    } fail:^(id errorDes) {
        
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self showTipView:@"数据请求出错！"];
        NSLog(@"%@", errorDes);
    }];

}

-(void)footerRefreshingEvent{
    _page++;
    
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Apporder/comment_query.html";
    NSDictionary * params = @{@"uid":GETUID, @"p":[NSString stringWithFormat:@"%ld", _page]};
    NSLog(@"%@?uid=%@", urlStr, GETUID);
    [NetRequest getDataWithUrlString:urlStr withParams:params success:^(id data) {
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 获取发布信息列表成功
            if ([data[@"data"] count] > 0) {
                for (NSDictionary * dict in data[@"data"]) {
                    _commentModel = [[CommentInfoModel alloc] initWithDictionary:dict error:nil];
                    [self.tableView.tabViewDataSource addObject:_commentModel];
                }
            }
        }else if([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:@"暂无更多评价信息"];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
    }];
}

#pragma mark - Getter
-(CommentTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStyleGrouped cellHeight:110];
        _tableView.tableViewEventDelegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableViewIdentifier];
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
