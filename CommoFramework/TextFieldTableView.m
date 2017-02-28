//
//  TextFieldTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/26.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "TextFieldTableView.h"
#import "TFTableViewCell.h"

@implementation TextFieldTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        self.InfoModel = [PublishInfoModel new];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tfdataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.leftTitleArray[indexPath.row];
    cell.textField.placeholder = self.phArray[indexPath.row];
    cell.textField.delegate = self;
    cell.tag = 40+indexPath.row;
    if (indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textField.enabled = NO;
        _addressTF = cell.textField;
    }else if (indexPath.row == 0){
        _companyTF = cell.textField;
    }else if (indexPath.row == 1){
        _nameTF = cell.textField;
    }else if (indexPath.row == 2){
        _telTF = cell.textField;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.phArray[4];
}

#pragma mark - TableViewSelectedEvent
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.tableViewEventDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.tableViewEventDelegate didSelectRowAtIndexPath:indexPath];
    }
    
    if (indexPath.row == 3) {
        //
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}


#pragma mark - Getter
- (NSMutableArray *)tfdataArray
{
    if (_tfdataArray == nil) {
        _tfdataArray = [[NSMutableArray alloc] init];
    }
    return _tfdataArray;
}


@end
