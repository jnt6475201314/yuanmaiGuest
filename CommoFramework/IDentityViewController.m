//
//  IDentityViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/21.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "IDentityViewController.h"
#import "IDentityTableView.h"
#import "IDentityTableViewCell.h"
#import "UIViewController+XHPhoto.h"
#import "IDentityDataModel.h"
#import "CompanyIDentityViewController.h"

@interface IDentityViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    IDentityDataModel * _model;
    UITextField * _nameTF;
    UITextField * _idTF;
    UIButton * sendBtn;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * cellImageArr;

@end

@implementation IDentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model = [IDentityDataModel new];
    [self configUI];
}

- (void)configUI{
    self.titleLabel.text = @"身份认证";
    [self showBackBtn];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 140.0f * heightScale)];
        UILabel * label = [UILabel labelWithFrame:CGRectMake(10, 0, screen_width - 20, 40) text:@"个人信息和头像" font:16 textColor:[UIColor blackColor]];
        [view addSubview:label];
        
        NSArray * titleArr = @[@"  姓名", @"  身份证"];
        NSArray * phArr = @[@"请输入真实姓名", @"请输入身份证号码"];
        for (int i = 0; i < 2; i++) {
            UITextField * tf = [MYFactoryManager createTextField:CGRectMake(0,  label.bottom + i*41, screen_width, 40) withPlaceholder:phArr[i] withLeftViewTitle:titleArr[i] withLeftViewTitleColor:[UIColor grayColor] withLeftFont:16 withLeftViewWidth:80 withDelegate:self];
            if (i == 0) {
                _nameTF = tf;
            }else if (i == 1){
                _idTF = tf;
            }
            [view addSubview:tf];
        }
        view;
    });

    self.dataSource = (NSMutableArray *)@[@"", @"", @""];
    [self.view addSubview:self.tableView];
    
    sendBtn = [UIButton buttonWithFrame:CGRectMake(0, screen_height - 40, screen_width, 40) title:@"下一步" image:nil target:self action:@selector(nextBtnEvent:)];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_model.name.length > 0 && _model.ID.length > 0 && _model.headImg && _model.IDFrontImg && _model.IDBackImg && _model.IDPersonImg) {
        [sendBtn setBackgroundColor:navBar_color];
        sendBtn.enabled = YES;
        
    }else{
        sendBtn.enabled = NO;
        [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    [self.view addSubview:sendBtn];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_nameTF == textField) {
        _model.name = textField.text;
    }else if (_idTF == textField){
        _model.ID = textField.text;
    }
    
    if (_model.name.length > 0 && _model.ID.length > 0 && _model.headImg && _model.IDFrontImg && _model.IDBackImg && _model.IDPersonImg) {
        [sendBtn setBackgroundColor:navBar_color];
        sendBtn.enabled = YES;
        
    }else{
        sendBtn.enabled = NO;
        [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Event Hander
- (void)nextBtnEvent:(UIButton *)btn
{
    CompanyIDentityViewController * CompanyIDentityVC = [[CompanyIDentityViewController alloc] init];
    CompanyIDentityVC.IDentityModel = _model;
    [self presentViewController:CompanyIDentityVC animated:YES completion:nil];
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDentityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
    NSArray * cellTitleArr = @[@"请上传清晰的头像", @"请上传身份证正面照", @"请上传身份证反面照", @"请上传手持身份证正面照"];
    NSArray * cellSampleArr = @[@"cell_Person_sample", @"cell_ID_sample", @"cell_IDBack_sample", @"cell_IDPerson_sample"];
    cell.IDentity_titleLabel.text = cellTitleArr[indexPath.section];
    cell.IDentity_uploadButton.tag = 20 + indexPath.section;
    [cell.IDentity_uploadButton addTarget:self action:@selector(cellPhoneBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.IDentity_sampleImgView.image = [UIImage imageNamed:cellSampleArr[indexPath.section]];//self.cellImageArr[indexPath.section];
    [cell.IDentity_uploadButton setBackgroundImage:self.cellImageArr[indexPath.section] forState:UIControlStateNormal];
    cell.IDentity_uploadButton.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)cellPhoneBtnEvent:(UIButton *)sender{
    NSInteger index = sender.tag - 20;
    [self.view endEditing:YES];
    
    [self showCanEdit:YES photo:^(UIImage *photo) {
        
        if (index == 0) {
            //
            _model.headImg = photo;
            [self.cellImageArr replaceObjectAtIndex:index withObject:_model.headImg];
            [self.tableView reloadData];
        }else if (index == 1){
            //
            _model.IDFrontImg = photo;
            [self.cellImageArr replaceObjectAtIndex:index withObject:_model.IDFrontImg];
            [self.tableView reloadData];
        }else if (index == 2){
            //
            _model.IDBackImg = photo;
            [self.cellImageArr replaceObjectAtIndex:index withObject:_model.IDBackImg];
            [self.tableView reloadData];
        }else if (index == 3){
            _model.IDPersonImg = photo;
            [self.cellImageArr replaceObjectAtIndex:index withObject:_model.IDPersonImg];
            [self.tableView reloadData];
        }
        
        if (_model.name.length > 0 && _model.ID.length > 0 && _model.headImg && _model.IDFrontImg && _model.IDBackImg && _model.IDPersonImg) {
            [sendBtn setBackgroundColor:navBar_color];
            sendBtn.enabled = YES;
            
        }else{
            sendBtn.enabled = NO;
            [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
        }

        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellImageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

#pragma mark - Getter
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 100) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"IDentityTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableViewIdentifier];
        
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)cellImageArr
{
    if (_cellImageArr == nil) {
        _cellImageArr = [[NSMutableArray alloc] initWithArray:@[[UIImage imageNamed:@"cell_uploadHeadImg"], [UIImage imageNamed:@"cell_uploadIDImg"], [UIImage imageNamed:@"cell_uploadIDImg"], [UIImage imageNamed:@"cell_uploadPhoto"]]];
    }
    return _cellImageArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
