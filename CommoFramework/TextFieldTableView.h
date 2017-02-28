//
//  TextFieldTableView.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/26.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishInfoModel.h"

@protocol TFTableViewSelectedEvent<NSObject>

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TextFieldTableView : UITableView<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITextField * _nameTF;
    UITextField * _companyTF;
    UITextField * _telTF;
    UITextField * _addressTF;
}
@property (nonatomic, weak) id<TFTableViewSelectedEvent>tableViewEventDelegate;
@property (nonatomic, strong) PublishInfoModel * InfoModel;
@property (nonatomic, strong) NSMutableArray * tfdataArray;

@property (nonatomic, strong) NSArray * leftTitleArray;
@property (nonatomic, strong) NSArray * phArray;

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
