//
//  BaseTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellHeight:(NSInteger)height{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        cellHeight = height;
        [self addMJRefresh];
    }
    return self;
}

- (void)addMJRefresh
{
    // 下拉刷新
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //模拟延迟加载数据 （真实开发需移除）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [self.mj_header endRefreshing];
//        });
        
        [self headerRefreshingEvent];
    }];
    
    // 设置自动切换透明度
    self.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [self.mj_footer endRefreshing];
//        });
        
        [self footerRefreshingEvent];
    }];
}

- (void)headerRefreshingEvent{
    if ([self.tableViewEventDelegate respondsToSelector:@selector(headerRefreshingEvent)]) {
        [self.tableViewEventDelegate headerRefreshingEvent];
    }
}

- (void)footerRefreshingEvent{
    if ([self.tableViewEventDelegate respondsToSelector:@selector(footerRefreshingEvent)]) {
        [self.tableViewEventDelegate footerRefreshingEvent];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.tabViewDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier forIndexPath:indexPath];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-  (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - TableViewSelectedEvent
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.tableViewEventDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.tableViewEventDelegate didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - Getter
- (NSMutableArray *)tabViewDataSource
{
    if (_tabViewDataSource == nil) {
        _tabViewDataSource = [[NSMutableArray alloc] init];
    }
    return _tabViewDataSource;
}

@end
