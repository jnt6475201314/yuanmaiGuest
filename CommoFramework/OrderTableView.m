//
//  OrderTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "OrderTableView.h"
#import "OrderTableViewCell.h"
#import "PublishLishModel.h"

@implementation OrderTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
    
    PublishLishModel * model = self.tabViewDataSource[indexPath.section];
    cell.order_stateLabel.text = model.state;
    cell.order_startingLabel.text = model.send;
    cell.order_destinationLabel.text = model.arrival_address;
    cell.order_numberLabel.text = [NSString stringWithFormat:@"订单号：%@", model.order_number];
    cell.Order_timeLabel.text = [NSString stringWithFormat:@"发布时间：%@", model.add_time];
    
    cell.order_button_right.titleLabel.adjustsFontSizeToFitWidth = YES;
    if ([model.state isEqualToString:@"已到达"]){
        cell.order_button_right.layer.borderWidth = 1;
        cell.order_button_right.layer.borderColor = [UIColor redColor].CGColor;
        [cell.order_button_right setTitle:@"删除订单" forState:UIControlStateNormal];
        cell.order_button_right.tag = 200 + indexPath.section;
        [cell.order_button_right addTarget:self action:@selector(deleteOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([model.state isEqualToString:@"运输中"]){
        cell.order_button_right.layer.borderWidth = 1;
        cell.order_button_right.layer.borderColor = [UIColor blueColor].CGColor;
        [cell.order_button_right setTitle:@"确认到达" forState:UIControlStateNormal];
        cell.order_button_right.tag = 900 + indexPath.section;
        [cell.order_button_right addTarget:self action:@selector(verifyOrderArrivedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}
// 删除订单
- (void)deleteOrderButtonClicked:(UIButton *)deleteBtn
{
    NSInteger index = deleteBtn.tag - 200;
    PublishLishModel * model = self.tabViewDataSource[index];
    
    NSLog(@"删除发布信息");
    NSDictionary * params = @{@"gid":model.gid, @"uid":GETUID};
    NSLog(@"%@?%@", API_DeletePublishInfo_URL, params);
    [NetRequest postDataWithUrlString:API_DeletePublishInfo_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self.tabViewDataSource removeObjectAtIndex:index];
            [self reloadData];
            [self.mj_header beginRefreshing];
            NSLog(@"删除该信息成功！");
        }else if([data[@"code"] isEqualToString:@"2"]){
            NSLog(@"删除该信息失败！");
        }
    } fail:^(id errorDes) {
        NSLog(@"删除信息失败！ 失败原因：%@", errorDes);
    }];
    [self reloadData];
}

// 确认到达
- (void)verifyOrderArrivedButtonClicked:(UIButton *)arrivedBtn
{
    NSInteger index = arrivedBtn.tag - 900;
    PublishLishModel * model = self.tabViewDataSource[index];
    
    NSDictionary * params = @{@"gid":model.gid, @"uid":GETUID};
    NSLog(@"%@?gid=%@", API_OrderAffirmArrivedAction_URL, model.gid);
    [NetRequest postDataWithUrlString:API_OrderAffirmArrivedAction_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self.tabViewDataSource removeObjectAtIndex:index];
            [self reloadData];
            [self.mj_header beginRefreshing];
        }else if([data[@"code"] isEqualToString:@"2"]){
            
        }
        NSLog(@"code:%@, message:%@", data[@"code"], data[@"message"]);
        NSLog(@"删除该信息成功！");
    } fail:^(id errorDes) {
        NSLog(@"删除信息失败！ 失败原因：%@", errorDes);
    }];
    [self reloadData];
}



@end
