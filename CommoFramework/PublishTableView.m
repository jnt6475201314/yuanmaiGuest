//
//  PublishTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "PublishTableView.h"
#import "PublishTableViewCell.h"
#import "PublishLishModel.h"

@implementation PublishTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PublishTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
    PublishLishModel * model = self.tabViewDataSource[indexPath.section];
    
    cell.pub_startAddrLabel.text = model.send;
    cell.pub_destinationLabel.text = model.arrival_address;
    cell.pub_goodsInfoLabel.text = [NSString stringWithFormat:@"货物类型:%@/体积:%@/重量:%@", model.goods_type, model.cube, model.total_weight];
    cell.pub_timeLabel.text = [NSString stringWithFormat:@"装货时间:%@", model.planned_time];
    
    [cell.pub_deleteButton addTarget:self action:@selector(cellDeleteBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.pub_deleteButton.tag = 20 + indexPath.section;
    
    [cell.pub_repeatButton addTarget:self action:@selector(cellRepeatBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.pub_repeatButton.tag = 200 + indexPath.section;
    cell.pub_repeatButton.hidden = YES;
    
    NSString * currentTimeStr = [MYFactoryManager getCurrentTime];
    NSString * addtime = [MYFactoryManager counttIntervalOfCurrentTime:currentTimeStr AndPastTime:model.add_time];
    
    cell.pub_addTimeLabel.text = addtime;
    cell.pub_addTimeLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)cellDeleteBtnEvent:(UIButton *)deleteBtn{
    NSInteger index = deleteBtn.tag - 20;
    PublishLishModel * model = self.tabViewDataSource[index];
    
    // 删除发布信息
    [self deletePublishInfoEventWithIndex:index PublishModel:model];
    
}

// 删除发布信息的网络请求
- (void)deletePublishInfoEventWithIndex:(NSInteger)index PublishModel:(PublishLishModel *)infoModel
{
    NSLog(@"删除发布信息");
    
//    NSString * urlStr = [URLHEAD stringByAppendingString:@"release_delete.html"];
    
    NSString * oidStr = [NSString stringWithFormat:@"%@", infoModel.gid];
    NSDictionary * params = @{@"gid":oidStr, @"uid":GETUID};
    NSLog(@"%@?oid=%@", API_DeletePublishInfo_URL, oidStr);
    [NetRequest postDataWithUrlString:API_DeletePublishInfo_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
//            [self showTipView:data[@"message"]];
            [self.tabViewDataSource removeObjectAtIndex:index];
            [self reloadData];
            [self.mj_header beginRefreshing];
        }else if([data[@"code"] isEqualToString:@"2"]){
//            [self showTipView:data[@"message"]];
        }
        NSLog(@"删除该信息成功！");
    } fail:^(id errorDes) {
        NSLog(@"删除信息失败！ 失败原因：%@", errorDes);
    }];
    [self reloadData];
}

- (void)cellRepeatBtnEvent:(UIButton *)repeatBtn{
    NSInteger index = repeatBtn.tag - 200;
    PublishLishModel * model = self.tabViewDataSource[index];
    
//    重新发布信息
    [self repeatPublishInfoEvnetWithIndex:index PublishModel:model];
}

// 重新发布信息的网络请求
- (void)repeatPublishInfoEvnetWithIndex:(NSInteger)index PublishModel:(PublishLishModel *)infoModel{
#warning 要重新写过了
#if 0
    NSLog(@"重新发布信息");
    
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Apporder/orders.html";
    
    NSDictionary * params = @{
                              @"uid":GETUID,
                              @"forwarding_unit":infoModel.forwarding_unit,
                              @"deliver_name":infoModel.deliver_name,
                              @"deliver_tel":infoModel.deliver_tel,
                              @"f_address":infoModel.address_f,
                              @"consignee_name":infoModel.consignee_name,
                              @"consignee_tel":infoModel.consignee_tel,
                              @"s_address":infoModel.address_s,
                              @"receiving_unit":infoModel.receiving_unit,
                              @"goods_type":infoModel.goods_type,
                              @"goods_load":infoModel.goods_load,
                              @"goods_size":infoModel.goods_size,
                              @"delivery_time":infoModel.delivery_time
                              };
    
    NSLog(@"%@?%@", urlStr, params);
    [NetRequest postDataWithUrlString:urlStr withParams:params success:^(id data) {
        
        NSLog(@"data : %@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            // 重新发布信息成功，将原来的该条信息删除
            [self deletePublishInfoEventWithIndex:index PublishModel:infoModel];
        }else if ([data[@"code"] isEqualToString:@"2"]){
            NSLog(@"发布信息失败");
        }
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
    }];
    
    [self reloadData];
#endif
}




@end
