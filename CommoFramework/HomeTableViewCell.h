//
//  HomeTableViewCell.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/19.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *home_headImageView;
@property (weak, nonatomic) IBOutlet UILabel *home_startLabel;
@property (weak, nonatomic) IBOutlet UILabel *home_desinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *home_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *home_carInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *home_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *home_tradeLabel;
@property (weak, nonatomic) IBOutlet UIButton *home_callPhoneButton;

@end
