//
//  PublishGoodsViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/27.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "PublishGoodsViewController.h"
#import "PublishInfoModel.h"
#import "TFTableViewCell.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"

#define SENDERTITLEARRAY @"senderTitleArr"  // 发货左边标题数组
#define SENDERPHARRAY @"senderPhArr"   // 发货placeholder 数组
#define GETTERTITLEARRAY @"getterTitleArr"  // 收货左边标题数组
#define GETTERPHARRAY @"getterPhArr"   // 收货placeholder 数组
#define GOODSTITLEARRAY @"goodsTitleArr"  // 货物左边标题数组
#define GOODSPHARRAY @"goodsPhArr"   // 货物placeholder 数组

@interface PublishGoodsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, STPickerAreaDelegate, UIScrollViewDelegate, STPickerSingleDelegate, STPickerDateDelegate>
{
    UIScrollView * scrollView;
    UIPageControl * _pageControl;
    
    UIButton * _button;
    STPickerArea * _senderAddressArea;
    STPickerArea * _getterAddressArea;
    STPickerSingle * _goodsTypePicker; // 货物类型选择器
    STPickerDate * _datePicker;  // 发货日期选择器
    
    UIView * view;
    UIView * _picBtnView; // 放按钮的view
    MyPicButton * _goodsWeightBtn; // 货物类型按钮
    NSString * _unitOfWeight;
    
    UITableView * _tableView0;
    UITableView * _tableView1;
    UITableView * _tableView2;
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) PublishInfoModel * publishModel;
@property (nonatomic, strong) NSMutableDictionary * dataDict;
@property (nonatomic, strong) NSArray * leftTitleArray;
@property (nonatomic, strong) NSArray * phArray;

@end


@implementation PublishGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
    [self configUI];
}

- (void)getData{
    self.publishModel = [PublishInfoModel new];
    
    self.titleLabel.text = @"填写发货人信息";
    NSArray * senderTitleArr = @[@"发货单位", @"姓名", @"联系方式", @"发货地址"];
    NSArray * senderPhArr = @[@"请填写发货单位", @"请填写发货人姓名", @"请填写联系方式", @"请选择发货地址", @"请完善发货人信息"];
    NSArray * getterTitleArr = @[@"收货单位", @"姓名", @"联系方式", @"收货地址"];
    NSArray * getterPhArr = @[@"请填写收货单位", @"请填写收货人姓名", @"请填写联系方式", @"请选择收货地址", @"请完善收货人信息"];
    NSArray * goodsTitleArr = @[@"货物体积", @"货物重量", @"货物类型", @"发货时间"];
    NSArray * goodsPhArr = @[@"请填写货物大概体积", @"请输入货物大概重量", @"请选择货物基本类型", @"请选择发货时间", @"请完善货物基本信息"];
    [self.dataDict setObject:senderTitleArr forKey:SENDERTITLEARRAY];
    [self.dataDict setObject:senderPhArr forKey:SENDERPHARRAY];
    
    [self.dataDict setObject:getterTitleArr forKey:GETTERTITLEARRAY];
    [self.dataDict setObject:getterPhArr forKey:GETTERPHARRAY];
    
    [self.dataDict setObject:goodsTitleArr forKey:GOODSTITLEARRAY];
    [self.dataDict setObject:goodsPhArr forKey:GOODSPHARRAY];
    
    
    
    self.leftTitleArray = senderTitleArr;
    self.phArray = senderPhArr;
}

- (void)configUI{
    [self loadImageView];
    [self showBackBtn];
}

- (void)loadImageView{
    NSArray *picArr = @[@"ic_guide",@"ic_guide",@"ic_guide"];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 63, screen_width, screen_height - 63)];
    scrollView.contentSize = CGSizeMake(screen_width*(int)picArr.count, screen_height - 63);
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOfEndEditingEvent:)];
    [scrollView addGestureRecognizer:tap];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(screen_width/2 - 60, screen_height - 30, 120, 30)];
    _pageControl.numberOfPages = picArr.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [_pageControl addTarget:self action:@selector(actionCotrolPage:) forControlEvents:UIControlEventValueChanged];
    
    for (int i=0; i<(int)picArr.count; i++) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(screen_width*i, 0, screen_width, scrollView.height)];
        view.backgroundColor = arc_Color;
        
        UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 226) style:UITableViewStylePlain];
        [table registerNib:[UINib nibWithNibName:@"TFTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableViewIdentifier];
        table.dataSource = self;
        table.delegate = self;
        
        if (i == 0) {
            _tableView0 = table;
            [view addSubview:_tableView0];
        }else if (i == 1){
            _tableView1 = table;
            [view addSubview:_tableView1];
        }else if (i == 2){
            _tableView2 = table;
            [view addSubview:_tableView2];
            
            _button = [UIButton buttonWithFrame:CGRectMake(60, table.bottom + 100, screen_width - 120, 40) title:@"确认发布" image:nil target:self action:@selector(publishInfoButtonEvent)];
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _button.backgroundColor = [UIColor grayColor];
            _button.enabled = NO;
            _button.layer.cornerRadius = 5;
            _button.clipsToBounds = YES;
            [view addSubview:_button];
        }
        [scrollView addSubview:view];
        
    }
    
    self.tableView = _tableView0;
    
    //添加视图
    [self.view addSubview:scrollView];
    [self.view addSubview:_pageControl];
    
    _picBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 136, 40)];
    NSArray * titleArr = @[@"吨", @"公斤"];
    _unitOfWeight = @"吨";
    for (int i = 0; i < 2; i++) {
        _goodsWeightBtn = [[MyPicButton alloc] initWithFrame:CGRectMake(   i * 68, 0, 68, 40)];
        [_goodsWeightBtn setBtnViewWithImage:@"circle_o" withImageWidth:20 withTitle:titleArr[i] withTitleColor:[UIColor grayColor] withFont:systemFont(16)];
        if (i == 0) {
            [_goodsWeightBtn setMyBtnSelected:YES];
        }else
        {
            [_goodsWeightBtn setMyBtnSelected:NO];
        }
        [_goodsWeightBtn setBtnNomalImage:@"circle_o" withNomalTitle:titleArr[i] withNomalTitleColor:[UIColor grayColor]];
        [_goodsWeightBtn setBtnselectImage:@"dot_circle_o" withselectTitleColor:[UIColor blackColor]];
        _goodsWeightBtn.tag = 10 + i;
        [_goodsWeightBtn addTarget:self action:@selector(selectGoodsWeightEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [_picBtnView addSubview:_goodsWeightBtn];
    }

}

- (void)actionCotrolPage:(id)sender
{
    [scrollView setContentOffset:CGPointMake(_pageControl.currentPage * screen_width, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    _pageControl.currentPage = scrollView.contentOffset.x/screen_width;
    switch (_pageControl.currentPage) {
        case 0:
            self.titleLabel.text = @"填写发货人信息";
            self.tableView = _tableView0;
            [self reloadTableViewWithDataTitleStr:SENDERTITLEARRAY PhStr:SENDERPHARRAY];
            break;
        case 1:
            self.titleLabel.text = @"填写收货人信息";
            self.tableView = _tableView1;
            [self reloadTableViewWithDataTitleStr:GETTERTITLEARRAY PhStr:GETTERPHARRAY];
            break;
        case 2:
            self.titleLabel.text = @"填写货物基本信息";
            self.tableView = _tableView2;
            [self reloadTableViewWithDataTitleStr:GOODSTITLEARRAY PhStr:GOODSPHARRAY];
            break;
        case 3:
            self.titleLabel.text = @"确认发布信息";
            break;
        default:
            break;
    }
}

- (void)reloadTableViewWithDataTitleStr:(NSString *)titleStr PhStr:(NSString *)phStr{
    self.leftTitleArray = [self.dataDict objectForKey:titleStr];
    self.phArray = [self.dataDict objectForKey:phStr];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.leftTitleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.leftTitleArray[indexPath.row];
    cell.textField.placeholder = self.phArray[indexPath.row];
    cell.textField.delegate = self;
    
    if (self.tableView == _tableView0) {
        cell.textField.tag = 20 + indexPath.row;
    }else if (self.tableView == _tableView1){
        cell.textField.tag = 30 + indexPath.row;
    }else if (self.tableView == _tableView2){
        cell.textField.tag = 40 + indexPath.row;
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        if (indexPath.row == 0) {
            cell.textField.rightView =  _picBtnView;
            cell.textField.rightViewMode = UITextFieldViewModeAlways;
        }else if (indexPath.row == 1){
            UILabel * lab = [UILabel labelWithFrame:CGRectMake(0, 0, 25, 40) text:@"方" font:16 textColor:[UIColor blackColor]];
            cell.textField.rightView = lab;
            cell.textField.rightViewMode = UITextFieldViewModeAlways;
        }
    }
    
    if (self.tableView == _tableView0 || self.tableView == _tableView1) {
        if (indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2){
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
    }else if (self.tableView == _tableView2){
        if (indexPath.row == 2 || indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 23 || textField.tag == 33 || textField.tag == 42 || textField.tag == 43) {
        switch (textField.tag) {
            case 23:
                // 显示选择发货地址 选择器
                [self.view endEditing:YES];
                _senderAddressArea = [[STPickerArea alloc] init];
                _senderAddressArea.delegate = self;
                [_senderAddressArea show];
                break;
            case 33:
                // 显示选择收货地址 选择器
                [self.view endEditing:YES];
                _getterAddressArea = [[STPickerArea alloc] init];
                _getterAddressArea.delegate = self;
                [_getterAddressArea show];
                break;
            case 42:
                //
                // 选择类型
                [self.view endEditing:YES];
                _goodsTypePicker = [[STPickerSingle alloc] init];
                _goodsTypePicker.delegate = self;
                //        [_goodsTypePicker setContentMode:STPickerContentModeCenter];
                [_goodsTypePicker setArrayData:[[NSMutableArray alloc] initWithArray:@[@"食品", @"矿产", @"建材", @"蔬菜", @"生鲜", @"药品", @"化工", @"木材", @"纺织品", @"家畜", @"农副产品", @"日用品", @"电子电器", @"其它类型"]]];
                [_goodsTypePicker show];
                break;
            case 43:
                //
                // 选择时间
                [self.view endEditing:YES];
                _datePicker = [[STPickerDate alloc] init];
                //        [_datePicker setContentMode:STPickerContentModeCenter];
                _datePicker.delegate = self;
                [_datePicker show];
                break;
                
            default:
                break;
        }
        
        return NO;
    }
    return YES;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.tableView == _tableView0) {
        // 发货人基本信息
        switch (textField.tag) {
            case 20:
                //
                self.publishModel.sender_company = textField.text;
                break;
            case 21:
                //
                self.publishModel.sender_name = textField.text;
                break;
            case 22:
                //
                self.publishModel.sender_tel = textField.text;
                break;
                
            default:
                break;
        }
    }else if (self.tableView == _tableView1) {
        // 发货人基本信息
        switch (textField.tag) {
            case 30:
                //
                self.publishModel.getter_company = textField.text;
                break;
            case 31:
                //
                self.publishModel.getter_name = textField.text;
                break;
            case 32:
                //
                self.publishModel.getter_tel = textField.text;
                break;
                
            default:
                break;
        }
    }else if (self.tableView == _tableView2) {
        // 发货人基本信息
        switch (textField.tag) {
            case 40:
                //
                if (textField.text.length != 0) {
                    self.publishModel.goods_volume = [NSString stringWithFormat:@"%@%@", textField.text, _unitOfWeight];
                }else
                {
                    self.publishModel.goods_volume = nil;
                }
                break;
            case 41:
                //
                if (textField.text.length != 0) {
                    self.publishModel.goods_loads = [NSString stringWithFormat:@"%@方", textField.text];
                }else{
                    self.publishModel.goods_loads = nil;
                }
                break;
            
            default:
                break;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 判断手机号内容是否正确
    if (textField.tag == 22 || textField.tag == 32) {
        if ([MYFactoryManager phoneNum:textField.text]) {
            // 手机号正确
//            [self showTipView:@"手机号码格式是正确的"];
            NSLog(@"手机号码格式是正确的");
        }else
        {
            [self showTipView:@"请检查手机号码格式是否正确"];
        }
    }
    
    // 判断model里面的数据是否完整
    [self judgePublishInfoisOK];
}

- (void)judgePublishInfoisOK{
    // 判断数据是否完整、正确
    if (self.publishModel.sender_tel.length == 0 || self.publishModel.sender_name.length == 0 || self.publishModel.sender_address.length == 0 || self.publishModel.sender_company.length == 0 || self.publishModel.getter_tel.length == 0 || self.publishModel.getter_name.length == 0 || self.publishModel.getter_address.length == 0 || self.publishModel.getter_company.length == 0 || self.publishModel.goods_time.length == 0 || self.publishModel.goods_type.length == 0 || self.publishModel.goods_loads.length == 0 || self.publishModel.goods_volume.length == 0) {
        //  存在数据为空, failed
        _button.backgroundColor = [UIColor grayColor];
        _button.enabled = NO;
        
    }else
    {
        // 数据都不为空， success
        _button.backgroundColor = navBar_color;
        _button.enabled = YES;
    }
    
    // 打印发布的信息
//    NSLog(@"sender: %@ %@ %@ %@  \n getter:%@ %@ %@ %@ \n goods: %@ %@ %@ %@", self.publishModel.sender_company, self.publishModel.sender_address, self.publishModel.sender_name, self.publishModel.sender_tel, self.publishModel.getter_company, self.publishModel.getter_address, self.publishModel.getter_name, self.publishModel.getter_tel,self.publishModel.goods_volume, self.publishModel.goods_loads, self.publishModel.goods_type, self.publishModel.goods_time);
}

//判断是否是数字，不是的话就输入失败
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 40 || textField.tag == 41) {
        
            // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
            // 设置限制长度
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
            
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        return canChange && newLength <= 6?canChange:NO;
        
    }else if (textField.tag == 22 || textField.tag == 32){
        // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        return newLength <= 11;

    }else if(textField.tag == 20 || textField.tag == 30){
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        return newLength <= 15;
    }else if(textField.tag == 21 || textField.tag == 31)
    {
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        return newLength <= 10;
    }
    return YES;
}

#pragma mark - STPickerAreaDelegate
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    if ([pickerArea isEqual:_senderAddressArea]) {
        UITextField * tf = [self.tableView viewWithTag:23];
        tf.text = text;
        self.publishModel.sender_address = text;
    }else if ([pickerArea isEqual:_getterAddressArea]){
        UITextField * tf = [self.tableView viewWithTag:33];
        tf.text = text;
        self.publishModel.getter_address = text;
    }
    
    [self judgePublishInfoisOK];
}

#pragma mark - STPickerDateDelegate, STPickerSingleDelegate
-(void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    if (pickerDate == _datePicker) {
        UITextField * tf = [self.tableView viewWithTag:43];
        tf.text = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
        self.publishModel.goods_time = tf.text;
    }
    
    [self judgePublishInfoisOK];
}

-(void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    if (pickerSingle == _goodsTypePicker) {
        UITextField * tf = [self.tableView viewWithTag:42];
        tf.text = selectedTitle;
        self.publishModel.goods_type = tf.text;
    }
    
    [self judgePublishInfoisOK];
}


#pragma mark - Event Hander
- (void)publishInfoButtonEvent{
    
    // 检查发布信息内容是否有误
    
    
    // 发布货源
    NSLog(@"publish info");
    [self publishNetWork];
}

- (void)publishNetWork{
    
    NSDictionary * params = @{
                              @"uid":GETUID,
                              @"forwarding_unit":self.publishModel.sender_company,
                              @"deliver_name":self.publishModel.sender_name,
                              @"deliver_tel":self.publishModel.sender_tel,
                              @"address_f":self.publishModel.sender_address,
                              @"consignee_name":self.publishModel.getter_name,
                              @"consignee_tel":self.publishModel.getter_tel,
                              @"address_s":self.publishModel.getter_address,
                              @"receiving_unit":self.publishModel.getter_company,
                              @"goods_type":self.publishModel.goods_type,
                              @"goods_load":self.publishModel.goods_loads,
                              @"goods_size":self.publishModel.goods_volume,
                              @"delivery_time":self.publishModel.goods_time
                              };
    
    NSLog(@"%@?%@", API_PublishOrderInfo_URL, params);
    [self showHUD:@"正在发布，请稍候。。。" isDim:YES];
    [NetRequest postDataWithUrlString:API_PublishOrderInfo_URL withParams:params success:^(id data) {
        
        NSLog(@"data : %@", data);
        NSLog(@"code:%@ message:%@", data[@"code"], data[@"message"]);
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([data[@"code"] isEqualToString:@"1"]) {
                [self showTipView:data[@"message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }else if ([data[@"code"] isEqualToString:@"2"]){
                [self showTipView:data[@"message"]];
            }
        });
    } fail:^(id errorDes) {
        [self hideHUD];
        NSLog(@"%@", errorDes);
    }];
}
// 选择货物重量类型
- (void)selectGoodsWeightEvent:(MyPicButton *)weightTypeBtn
{
    [weightTypeBtn setMyBtnSelected:YES];
    if (weightTypeBtn.tag == 10) {
        _unitOfWeight = @"吨";
        MyPicButton * btn = (MyPicButton *)[self.tableView viewWithTag:11];
        [btn setMyBtnSelected:NO];
    }else if (weightTypeBtn.tag == 11)
    {
        _unitOfWeight = @"公斤";
        MyPicButton * btn = (MyPicButton *)[self.tableView viewWithTag:10];
        [btn setMyBtnSelected:NO];
    }
    
    UITextField * textField = [_tableView2 viewWithTag:40];
    if (textField.text.length != 0) {
        self.publishModel.goods_volume = [NSString stringWithFormat:@"%@%@", textField.text, _unitOfWeight];
    }
    
    NSLog(@"%@", self.publishModel.goods_volume);
}

- (void)tapGestureOfEndEditingEvent:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}


#pragma mark - Getter
-(NSMutableDictionary *)dataDict
{
    if (_dataDict == nil) {
        _dataDict = [[NSMutableDictionary alloc] init];
    }
    return _dataDict;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
