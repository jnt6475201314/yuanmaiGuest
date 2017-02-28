//
//  HomeTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/19.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "HomeTableView.h"
#import "HomeTableViewCell.h"
#import "HomeListModel.h"

@implementation HomeTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
//    NSLog(@"%@", self.tabViewDataSource);
    if (self.tabViewDataSource.count > 0) {
        HomeListModel * model = self.tabViewDataSource[indexPath.section];
        
        NSString * photoStr = [NSString stringWithFormat:@"http://202.91.248.43/project/Public/Uploads/driver_id/%@", model.photo];
        [cell.home_headImageView sd_setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:[UIImage imageNamed:@"cell_girl"]];
        cell.home_nameLabel.text = model.name;
        cell.home_startLabel.text = model.departure_place;
        cell.home_desinationLabel.text = model.destination;
        cell.home_carInfoLabel.text = [NSString stringWithFormat:@"车长:%@ / 车型:%@", model.vehicle_length_c, model.models_c];
        
        NSString * currentTimeStr = [MYFactoryManager getCurrentTime];
        NSString * addtime = [MYFactoryManager counttIntervalOfCurrentTime:currentTimeStr AndPastTime:model.departure_time];
        
        cell.home_timeLabel.text = addtime;
        cell.home_callPhoneButton.tag = 20 + indexPath.row;
        cell.home_callPhoneButton.hidden = YES;
        [cell.home_callPhoneButton addTarget:self action:@selector(cellPhoneBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
        backBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [backBtn addTarget:self action:@selector(nanduBackBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * titleLabel = [UILabel labelWithFrame:CGRectMake(10, 0, screen_width - 20, 40) text:[NSString stringWithFormat:@" 司机列表：%lu条", (unsigned long)[self.tabViewDataSource count]] font:17 textColor:[UIColor blackColor]];
        titleLabel.textColor = [UIColor brownColor];
        
        UIImageView * arrowImgView = [[UIImageView alloc] init];
        // 判断是否折叠
//        if ([[self.flagArray objectAtIndex:section] boolValue]) {
//            // 当前没有折叠
//            arrowImgView.frame = CGRectMake(backBtn.width - 28, (40-22)/2, 14, 22);
//            arrowImgView.image = [UIImage imageNamed:@"nandu_arrow_right"];
//        }else{
//            arrowImgView.frame = CGRectMake(backBtn.width - 33, (40-14)/2, 22, 14);
//            arrowImgView.image = [UIImage imageNamed:@"nandu_arrow_down"];
//        }
        backBtn.tag = 200 + section;
        [backBtn addSubview:arrowImgView];
        [backBtn addSubview:titleLabel];
        return backBtn;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else
    {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)cellPhoneBtnEvent:(UIButton *)sender{
    NSInteger index = sender.tag - 20;
    HomeListModel * model = self.tabViewDataSource[index];
    NSLog(@"打电话给%@", model.tel);
}


@end
