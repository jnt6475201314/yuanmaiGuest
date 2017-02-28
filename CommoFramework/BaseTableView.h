//
//  BaseTableView.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewSelectedEvent <NSObject>

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
/*下拉刷新数据请求*/
- (void)headerRefreshingEvent;
/*上拉加载更多数据请求*/
- (void)footerRefreshingEvent;

@end

@interface BaseTableView : UITableView<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger cellHeight;
}

@property (nonatomic, weak) id<TableViewSelectedEvent>tableViewEventDelegate;

@property (nonatomic, strong) NSMutableArray * tabViewDataSource;

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellHeight:(NSInteger)height;

/*下拉刷新数据请求*/
- (void)headerRefreshingEvent;
/*上拉加载更多数据请求*/
- (void)footerRefreshingEvent;

@end
