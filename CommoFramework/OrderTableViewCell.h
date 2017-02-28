//
//  OrderTableViewCell.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_startingLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *Order_timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *order_button_right;
@end
