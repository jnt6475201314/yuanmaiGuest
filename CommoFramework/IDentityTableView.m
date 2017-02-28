//
//  IDentityTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/21.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "IDentityTableView.h"
#import "IDentityTableViewCell.h"

@implementation IDentityTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDentityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
    
    cell.IDentity_titleLabel.text = @"请上传清晰的头像";
    cell.IDentity_uploadButton.tag = 20 + indexPath.row;
    [cell.IDentity_uploadButton addTarget:self action:@selector(cellPhoneBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.IDentity_sampleImgView.image = [UIImage imageNamed:@"test"];
    
    return cell;
}

- (void)cellPhoneBtnEvent:(UIButton *)sender{
    NSInteger index = sender.tag - 20;
//    HomeListModel * model = self.tabViewDataSource[index];
//    NSLog(@"打电话给%@", model.tel);
}


@end
