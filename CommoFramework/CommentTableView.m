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
    
    if (model.state && [model.state isEqualToString:@"1"]) {
        cell.Comment_OrderStateLabel.text = @"已评价";
        cell.Comment_OrderStateLabel.textColor = [UIColor orangeColor];
    }else
    {
        cell.Comment_OrderStateLabel.text = @"待评价";
    }
    
    
    NSString * photoStr = [NSString stringWithFormat:@"http://202.91.248.43/project/Public/Uploads/driver_id/%@", model.photo];
    [cell.Comment_HeadImageView sd_setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:[UIImage imageNamed:@"个人中心 (1)"]];
    cell.Comment_startingLabel.text = model.address_f;
    cell.Comment_destinationLabel.text = model.address_s;
    cell.comment_nameOfDriverLabel.text = model.name;
    cell.comment_infoOfTruckLabel.text = [NSString stringWithFormat:@"车长:%@ / 车型:%@", model.vehicle_length, model.models];
    cell.comment_publishDateLabel.text = [NSString stringWithFormat:@"发货日期：%@", model.delivery_time];
//    cell.comment_arriveDateLabel.text = [NSString stringWithFormat:@"到货日期：%@", model.];  // 到达日期

    
    return cell;
}



@end
