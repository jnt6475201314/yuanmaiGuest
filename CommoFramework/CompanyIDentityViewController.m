//
//  CompanyIDentityViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/25.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "CompanyIDentityViewController.h"
#import "UIViewController+XHPhoto.h"
#import "ImageCollectionViewCell.h"
#import "CompanyIDentityModel.h"

@interface CompanyIDentityViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CellDelegate, STPickerAreaDelegate>
{
    UITextField * _nameTF;
    UITextField * _addressTF;
    UITextField * _detailAddressTF;
    UITextField * _telTF;
    UIButton * sendBtn;
    
    BOOL deleteBtnFlag;
    BOOL rotateAniFlag;
    
    STPickerArea * _addressArea;
    NSMutableDictionary * _params;
}
@property (nonatomic, strong) CompanyIDentityModel * companyModel;
@property (nonatomic, strong) UICollectionView * imageCollectionView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation CompanyIDentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deleteBtnFlag = YES;
    rotateAniFlag = YES;
    [self addDoubleTapGesture];
    [self configUI];
}
- (void)configUI{
    self.titleLabel.text = @"公司认证";
    [self showBackBtn];
    
    _params = [[NSMutableDictionary alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200.0f * heightScale)];
        UILabel * label = [UILabel labelWithFrame:CGRectMake(10, 0, screen_width - 20, 40) text:@"填写公司信息" font:16 textColor:[UIColor blackColor]];
        [view addSubview:label];
        
        NSArray * titleArr = @[@"  公司名称", @"  公司地址", @"", @"  固定电话"];
        NSArray * phArr = @[@"请输入公司名称", @"请选择城市", @"请输入公司详细地址", @"请输入公司联系方式"];
        
        for (int i = 0; i < 4; i++) {
            UITextField * tf = [MYFactoryManager createTextField:CGRectMake(0, label.bottom + i*41, screen_width, 44) withPlaceholder:phArr[i] withLeftViewTitle:titleArr[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:100 withDelegate:self];
            if (i == 1) {
                _addressTF = tf;
                _addressTF.text = _companyModel.address;
            }else if (i == 0){
                _nameTF = tf;
                _nameTF.text = _companyModel.name;
            }else if (i == 2){
                _detailAddressTF = tf;
                _detailAddressTF.text = _companyModel.detailAddress;
            }else if (i == 3){
                _telTF = tf;
                _telTF.text = _companyModel.tel;
            }
            [view addSubview:tf];
        }
        view;
    });

    self.companyModel = [CompanyIDentityModel new];
    sendBtn = [UIButton buttonWithFrame:CGRectMake(0, screen_height - 40, screen_width, 40) title:@"提交认证信息" image:nil target:self action:@selector(sendBtnEvent:)];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self judgeValueOfCompanyModel];
    [self.view addSubview:sendBtn];
}

#pragma mark - Event Hander
-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendBtnEvent:(UIButton *)sender{
    
    NSString * uid = GETUID;
    [_params setValue:uid forKey:@"uid"];
    [_params setValue:self.IDentityModel.name forKey:@"name"];
    [_params setValue:self.IDentityModel.ID forKey:@"identity_id"];
    [_params setValue:self.companyModel.name forKey:@"company_name"];
    [_params setValue:self.companyModel.tel forKey:@"company_tel"];
    [_params setValue:self.companyModel.address forKey:@"company_address"];
    [_params setValue:self.companyModel.detailAddress forKey:@"address_particular"];
    
    UIImage * image = self.IDentityModel.headImg;
    NSData * imgData = UIImageJPEGRepresentation(image, 0.3f);
    NSString * headImg = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_params setObject:headImg forKey:@"photo"];
    
    UIImage * image1 = self.IDentityModel.IDFrontImg;
    NSData * imgData1 = UIImageJPEGRepresentation(image1, 0.3f);
    NSString * headImg1 = [imgData1 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_params setObject:headImg1 forKey:@"frontal"];
    
    
    UIImage * image2 = self.IDentityModel.headImg;
    NSData * imgData2 = UIImageJPEGRepresentation(image2, 0.3f);
    NSString * headImg2 = [imgData2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_params setObject:headImg2 forKey:@"photo_frontal"];
    
    UIImage * image3 = self.IDentityModel.IDFrontImg;
    NSData * imgData3 = UIImageJPEGRepresentation(image3, 0.3f);
    NSString * headImg3 = [imgData3 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_params setObject:headImg3 forKey:@"frontal_b"];
    
    for (int i = 1; i < 4; i++) {
        UIImage * img = self.imageArray[i];
        NSData * imgdata = UIImageJPEGRepresentation(img, 0.3f);
        NSString * imgStr = [imgdata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        if (i == 1) {
            _companyModel.company_photo = imgStr;
            [_params setObject:imgStr forKey:@"company_photo"];
        }else if(i == 2){
            _companyModel.men_photo = imgStr;
            [_params setObject:imgStr forKey:@"men_photo"];
        }else if (i == 3){
            _companyModel.yinye_photo = imgStr;
            [_params setObject:imgStr forKey:@"yinye_photo"];
        }
    }
    
    [self NetWorkOfIDentityInfomation];
}

- (void)NetWorkOfIDentityInfomation{
    [self showHUD:@"正在上传，请稍候" isDim:YES];
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/App/user_info";
    NSLog(@"%@?%@", urlStr, _params);
    [NetRequest postDataWithUrlString:urlStr withParams:_params success:^(id data) {
        [self hideHUD];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:data[@"message"]];
            
        }else if ([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:data[@"message"]];
        }
    } fail:^(NSString *errorDes) {
        NSLog(@"%@", errorDes);
        [self hideHUD];
    }];
}

- (void)judgeValueOfCompanyModel{
    if (_companyModel.name.length > 0 && _companyModel.address.length > 0 && _companyModel.detailAddress.length > 0 && _companyModel.tel.length > 0 && self.imageArray.count == 4) {
        [sendBtn setBackgroundColor:navBar_color];
        sendBtn.enabled = YES;
        
    }else
    {
        [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
        sendBtn.enabled = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _nameTF) {
        _companyModel.name = _nameTF.text;
    }else if (textField == _detailAddressTF){
        _companyModel.detailAddress = _detailAddressTF.text;
    }else if (textField == _telTF){
        _companyModel.tel = _telTF.text;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _addressTF) {
        [self.view endEditing:YES];
        _addressArea = [[STPickerArea alloc] init];
        _addressArea.delegate = self;
        [_addressArea show];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self judgeValueOfCompanyModel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - STPickerAreaDelegate
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    //        self.textArea.text = text;
    if ([pickerArea isEqual:_addressArea]) {
        UITextField * tf = (UITextField *)[self.tableView viewWithTag:53];
        tf.text = text;
        self.companyModel.address = text;
        _addressTF.text = text;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"上传公司营业执照、公司门头照／门面照、营业执照+本人合影";

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel * label = [UILabel labelWithFrame:CGRectMake(10, 0, screen_width - 60, 40) text:@"上传公司资质证明（共3张）" font:15 textColor:[UIColor orangeColor]];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:self.imageCollectionView];
        
    UILabel * adlabel = [UILabel labelWithFrame:CGRectMake(10, self.imageCollectionView.bottom, screen_width - 20, 30) text:@"长按图片可进入编辑状态、双击屏幕退出编辑" font:14 textColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:adlabel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString * content = [NSString stringWithFormat:@"为了更快通过审核，请尽可能上传以下信息：\n1.有法律效力的公司资质证明，营业执照\n2.公司门头照/门面照\n3.营业执照+本人合影\n以上资料信息需与注册信息一致\n"];
    return content;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"imageCollectionView";
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.imgView.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
        //        cell.userInteractionEnabled = NO;
        cell.deleteBtn.hidden = YES;
    }else{
        cell.indexPath = indexPath;
        cell.deleteBtn.hidden = deleteBtnFlag?YES:NO;
        cell.delegate = self;
        if (!rotateAniFlag) {
            [MyAnimation vibrateAnimation:cell];
        }else{
            [cell.layer removeAnimationForKey:@"shake"];
        }
        cell.imgView.image = self.imageArray[indexPath.item];
    }
    return cell;
}

// 点击每个cell触发的事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        // 点击了添加相片按钮
        NSLog(@"点击了添加相片按钮");
        [self.view endEditing:YES];
        if (self.imageArray.count < 4) {
            [self hideAllDeleteBtn];
            [self showCanEdit:YES photo:^(UIImage *photo) {
                [self.imageArray addObject:photo];
                [self.imageCollectionView reloadData];
                [self judgeValueOfCompanyModel];
            }];
        }else{
            [self showTipView:@"公司资质证明只需3张就够了哟😯"];
            [self judgeValueOfCompanyModel];
        }
        
    }
    
}

#pragma mark - CellDelegate
-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath cellView:(ImageCollectionViewCell *)cell{
    if (self.imageArray.count < 1) {
        [self hideAllDeleteBtn];
        return;
    }
    
    [self.imageCollectionView performBatchUpdates:^{
        cell.imgView.image = nil;
        cell.deleteBtn.hidden = YES;
        
        [MyAnimation fadeAnimation:cell];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ULL * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            // 延时1s执行， 下面这两行执行删除cell的操作，包括移除数据源和删除item， 如果你用到数据库或者coreData
            // 要先删掉数据库里的内容，再执行移除数据源和删除item
            [self.imageArray removeObjectAtIndex:indexPath.row];
            [self.imageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        });
    } completion:^(BOOL finished) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ULL * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            [self.imageCollectionView reloadData];
            [self judgeValueOfCompanyModel];
        });
    }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *) gestureRecognizer
{
    [self hideAllDeleteBtn];
}

-(void)addDoubleTapGesture{
    UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubletap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubletap];
}

-(void)hideAllDeleteBtn{
    if (!deleteBtnFlag) {
        deleteBtnFlag = YES;
        rotateAniFlag = YES;
        [self.imageCollectionView reloadData];
    }
}

-(void)showAllDeleteBtn{
    deleteBtnFlag = NO;
    rotateAniFlag = NO;
    [self.imageCollectionView reloadData];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(UICollectionView *)imageCollectionView{
    if (_imageCollectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //        flowLayout.headerReferenceSize = CGSizeMake(screen_width, screen_height/4);
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 50, screen_width - 40, 70) collectionViewLayout:flowLayout];
        
        // 定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(60, 60);
        // 定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 10;
        // 定义每个UICollectionView 的纵向间距
        flowLayout.minimumInteritemSpacing = 0;
        // 定义每个UICollectionView 的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8); // 上左下右
        
        //注册cell和ReusableView（相当于头部）
        [_imageCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCollectionView"];
        
        //设置代理
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        
        //背景颜色
        _imageCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _imageCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageCollectionView;
}

-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] initWithObjects:@"add_images", nil];
    }
    return _imageArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
