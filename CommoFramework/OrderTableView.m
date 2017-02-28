//
//  OrderTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "OrderTableView.h"
#import "OrderTableViewCell.h"
#import "OrderListModel.h"

@implementation OrderTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
    
    OrderListModel * model = self.tabViewDataSource[indexPath.section];
    cell.order_stateLabel.text = model.order_state;
    cell.order_startingLabel.text = model.address_f;
    cell.order_destinationLabel.text = model.address_s;
    cell.order_numberLabel.text = [NSString stringWithFormat:@"订单号：%@", model.order_number];
    cell.Order_timeLabel.text = [NSString stringWithFormat:@"发布时间：%@", model.delivery_time];
    
    cell.order_button_left.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.order_button_right.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.order_button_left.layer.borderColor = navBar_color.CGColor;
    cell.order_button_left.layer.borderWidth = 1;
    cell.order_button_right.layer.borderWidth = 1;
    cell.order_button_right.layer.borderColor = [UIColor orangeColor].CGColor;
    
    if ([model.order_state isEqualToString:@"待装车"]) {
        cell.order_stateLabel.textColor = [UIColor purpleColor];
        [cell.order_button_left setTitle:@"取消" forState:UIControlStateNormal];
        [cell.order_button_right setTitle:@"确认接单" forState:UIControlStateNormal];
    }else if ([model.order_state isEqualToString:@"已到达"]){
        cell.order_stateLabel.textColor = [UIColor orangeColor];
        [cell.order_button_left setTitle:@"删除订单" forState:UIControlStateNormal];
        [cell.order_button_right setTitle:@"评价" forState:UIControlStateNormal];
    }else{
        cell.order_stateLabel.textColor = [UIColor brownColor];
        [cell.order_button_left setTitle:@"订单追踪" forState:UIControlStateNormal];
        [cell.order_button_right setTitle:@"确认到达" forState:UIControlStateNormal];
    }
    
    
    return cell;
}

@end
