//
//  CommentTableViewCell.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/31.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Comment_OrderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *Comment_OrderStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *Comment_startingLabel;
@property (weak, nonatomic) IBOutlet UILabel *Comment_destinationLabel;


@property (weak, nonatomic) IBOutlet UILabel *Comment_goodsWeight;
@property (weak, nonatomic) IBOutlet UILabel *Comment_goodSize;
@property (weak, nonatomic) IBOutlet UILabel *Comment_goodsType;

@property (weak, nonatomic) IBOutlet UILabel *Comment_arriveTime;


@end
