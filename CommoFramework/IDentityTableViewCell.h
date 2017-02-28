//
//  IDentityTableViewCell.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/21.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDentityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *IDentity_titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *IDentity_uploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *IDentity_sampleImgView;

@end
