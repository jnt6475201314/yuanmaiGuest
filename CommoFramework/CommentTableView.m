//
//  CommentTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/31.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "CommentTableView.h"

@implementation CommentTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
    CommentInfoModel * model = self.tabViewDataSource[indexPath.section];
    
    cell.Comment_OrderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", model.order_number];
    
    if ([model.comment_state isEqualToString:@"1"]) {
        cell.Comment_OrderStateLabel.text = @"已评价";
        cell.Comment_OrderStateLabel.textColor = [UIColor orangeColor];
    }else
    {
        cell.Comment_OrderStateLabel.text = @"待评价";
    }
    
    cell.Comment_goodSize.text = model.cube;
    cell.Comment_goodsType.text = model.goods_type;
    cell.Comment_goodsWeight.text = model.total_weight;
    cell.Comment_arriveTime.text = [NSString stringWithFormat:@"到达时间：%@", model.state_time];
    
    return cell;
}



@end
