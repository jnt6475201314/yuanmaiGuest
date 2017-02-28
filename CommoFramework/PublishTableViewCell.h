//
//  PublishTableViewCell.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pub_startAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *pub_destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pub_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pub_goodsInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *pub_deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *pub_repeatButton;
@property (weak, nonatomic) IBOutlet UILabel *pub_addTimeLabel;

@end
