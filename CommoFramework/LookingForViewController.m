//
//  LookingForViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/21.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "LookingForViewController.h"
#import "JntDropView.h"
#import "LabelCollectionViewCell.h"
#import "HomeTableView.h"
#import "DriverListDetailViewController.h"
#import "HomeTableViewCell.h"
#import "AddressModel.h"

#define AddressUrlStr @"http://202.91.248.43/project/index.php/Admin/Appdriver/linkage"

@interface LookingForViewController ()<MenuViewDelegate, TableViewSelectedEvent, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger _page;
    JntDropView * menu;
    NSArray * provinceArray;
    NSArray * cityArray;
    NSArray * lengthArray;
    NSArray * typeArray;
    
    UIView * collectionBgView;
    UIButton * _upLevelBtn;  // 上一级按钮
    UIButton * _sureBtn;     // 确定按钮
    UIButton * _showBtn;     // 显示按钮
    
    NSString * _showStr;      // 按钮上显示的内容
    
    NSInteger level;          // 级别 基础为1
    NSInteger IndexForLevel2;    // index 角标， 记录选择的城市
    NSInteger menuTag;         // 记录选择menu的内容
    
    NSMutableDictionary * params;  // 获取数据的参数
    NSMutableDictionary * citys;   // 存放所有城市的字典
    NSMutableArray * modelArray;   // 存放模型的数组
}
@property (nonatomic, strong) HomeTableView * tableView;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation LookingForViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerRefreshingEvent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configUI];
}

- (void)configUI{
    self.titleLabel.text = @"找车源";
    [self showBackBtn];
    
    [self dealWithDataSource];
    [self configTableView];
    [self configHeadSelectedView];
}

- (void)configTableView{
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
}

- (void)configHeadSelectedView
{
    menu = [[JntDropView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    menu.delegate = self;
    // 设置属性(可不设置)
    menu.caverAnimationTime = 0.2;             //  增加了展开动画时间设置   不设置默认是  0.15
    menu.hideAnimationTime = 0.2;              //  增加了缩进动画时间设置   不设置默认是  0.15
    menu.menuTitleFont = 12;                   //  设置menuTitle字体大小    不设置默认是  11
    menu.tableTitleFont = 11;                  //  设置tableTitle字体大小   不设置默认是  10
    menu.cellHeight = 38;                      //  设置tableViewcell高度   不设置默认是  40
    menu.menuArrowStyle = menuArrowStyleSolid; //  旋转箭头的样式(空心箭头 or 实心箭头)
    menu.tableViewMaxHeight = 200;             //  tableView的最大高度(超过此高度就可以滑动显示)
    menu.menuButtonTag = 100;                  //  menu定义了一个tag值如果与本页面的其他button的值有冲突重合可以自定义设置
    //    menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
    menu.CarverViewColor = [UIColor clearColor];
    menu.selectedColor = [UIColor redColor];   //  选中的字体颜色
    menu.unSelectedColor = [UIColor grayColor];//  未选中的字体颜色
    
    [menu createMenuViewWithData:@[@"出发地", @"目的地", @"车  长", @"车  型"]];
    
    [self.view addSubview:menu];
    [self configCollectionBgView];
}

- (void)configCollectionBgView{
    
    collectionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, screen_width, 250)];
    collectionBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [collectionBgView addSubview:self.collectionView];
    
    _upLevelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _upLevelBtn.frame = CGRectMake(5, 5, 60, 30);
    _upLevelBtn.layer.cornerRadius = 3;
    _upLevelBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    _upLevelBtn.layer.borderWidth = 1;
    [collectionBgView addSubview:_upLevelBtn];
    [_upLevelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_upLevelBtn addTarget:self action:@selector(upLevelBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
    
    _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showBtn.frame = CGRectMake(70, 5, screen_width - 140, 30);
    [_showBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [collectionBgView addSubview:_showBtn];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _sureBtn.frame = CGRectMake(screen_width - 70, 5, 60, 30);
    _sureBtn.layer.cornerRadius = 3;
    _sureBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    _sureBtn.layer.borderWidth = 1;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [collectionBgView addSubview:_sureBtn];
}

- (void)dealWithDataSource{
    NSString * provincePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    provinceArray = [[NSArray array] initWithContentsOfFile:provincePath];
    NSString * cityPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    cityArray = [NSArray arrayWithContentsOfFile:cityPath];
    lengthArray = @[@"不限", @"4.2米", @"4.5米", @"5米", @"6.2米", @"6.8米", @"7.2米", @"7.7米", @"7.8米", @"8.2米", @"8.6米", @"8.7米", @"9.6米", @"11.7米", @"12.5米", @"13米", @"13.5米", @"14米", @"16米", @"17米", @"17.5米", @"18米"];
    typeArray = @[@"不限", @"平板", @"高栏", @"厢式", @"高低板", @"保温冷藏", @"危险品"];
    
    [self getData];
}

- (void)getData{
    params = [[NSMutableDictionary alloc] init];
    citys = [[NSMutableDictionary alloc] init];
    modelArray = [[NSMutableArray alloc] init];
    
    [self getProvinceAddressData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (AddressModel * model in modelArray) {
            NSString * upid = model.id;
            NSLog(@"%@", upid);
            [params setObject:upid forKey:@"upid"];
            [self getCityAddressDataWithParams:params];
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        NSLog(@"%@", citys.allKeys);
    });
}

- (void)getProvinceAddressData{
    
    [NetRequest postDataWithUrlString:AddressUrlStr withParams:params success:^(id data) {
        
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            for (NSDictionary * dict in data[@"data"]) {
                AddressModel * model = [[AddressModel alloc] initWithDictionary:dict error:nil];
                [modelArray addObject:model];
            }
        }else
        {
            NSLog(@"获取失败！ message %@", data[@"message"]);
        }
        
    } fail:^(NSString *errorDes) {
        
        NSLog(@"error : %@", errorDes);
    }];
}

- (void)getCityAddressDataWithParams:(NSDictionary *)_params{
    
    [NetRequest postDataWithUrlString:AddressUrlStr withParams:_params success:^(id data) {
        
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            for (NSDictionary * dict in data[@"data"]) {
                [citys setObject:dict[@"id"] forKey:dict[@"name"]];
            }
            
        }else{
            NSLog(@"获取城市数据失败！message：%@", data[@"message"]);
        }
        
    } fail:^(NSString *errorDes) {
        
        NSLog(@"error :%@", errorDes);
    }];
    
}

#pragma mark - Event Hander
- (void)upLevelBtnCliked:(UIButton *)btn{
    NSLog(@"level = %ld", level);
    if (level == 2) {
        level = 1;
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        if (menuTag == 200) {
            self.dataSource = [[NSMutableArray alloc] initWithArray:provinceArray];
            [self.collectionView reloadData];
        }else if (menuTag == 201){
            self.dataSource = [[NSMutableArray alloc] initWithArray:provinceArray];
            [self.collectionView reloadData];
        }
    }else if (level == 3){
        level = 2;
        [btn setTitle:@"上一级" forState:UIControlStateNormal];
        if (menuTag == 200) {
            self.dataSource = [[NSMutableArray alloc] initWithArray:cityArray[IndexForLevel2]];
            [self.collectionView reloadData];
        }else if (menuTag == 201){
            self.dataSource= [[NSMutableArray alloc] initWithArray:cityArray[IndexForLevel2]];
            [self.collectionView reloadData];
        }
    }
    
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [collectionBgView removeFromSuperview];
    }
}

- (void)sureBtnClicked:(UIButton *)btn{
    [collectionBgView removeFromSuperview];
    
    UIButton * button = (UIButton *)[menu viewWithTag:menuTag - 100];
    [button setTitle:_showStr forState:UIControlStateNormal];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        
        collectionBgView.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        
        [collectionBgView removeFromSuperview];
    }];
}


#pragma mark - MenuViewDelegate
- (void)MenuClickButton:(UIButton *)button Index:(NSInteger)menuIndex menuTitle:(NSString *)menuTitle
{
    NSLog(@"%ld -- %@", menuIndex, menuTitle);
    level = 1;
    [_upLevelBtn setTitle:@"取消" forState:UIControlStateNormal];
    menuTag = 100 + menuIndex;
    if (menuIndex == 100) {
        self.dataSource = (NSMutableArray *)provinceArray;
        [self.collectionView reloadData];
        
        _showStr = @"全国";
    }else if (menuIndex == 101){
        self.dataSource = (NSMutableArray *)provinceArray;
        [self.collectionView reloadData];
        
        _showStr = @"全国";
    }else if (menuIndex == 102){
        self.dataSource = (NSMutableArray *)lengthArray;
        [self.collectionView reloadData];
        
        _showStr = @"不限";
    }else if (menuIndex == 103){
        self.dataSource = (NSMutableArray *)typeArray;
        [self.collectionView reloadData];
        
        _showStr = @"不限";
    }
    [self.view addSubview:collectionBgView];
    [_showBtn setTitle:_showStr forState:UIControlStateNormal];
}

#pragma mark -  UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"cellIde";
    LabelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.cellLabel.text = self.dataSource[indexPath.item];
    cell.cellLabel.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
    _showStr = self.dataSource[indexPath.item];
    [_showBtn setTitle:_showStr forState:UIControlStateNormal];
    if (level == 1) {
        if (menuTag == 200 || menuTag == 201) {
            NSLog(@"出发地");
            level = 2;
            IndexForLevel2 = indexPath.item;
            [_upLevelBtn setTitle:@"上一级" forState:UIControlStateNormal];
            NSMutableArray * cityArr = [NSMutableArray arrayWithArray:cityArray];
            self.dataSource = cityArr[indexPath.item];
            [self.collectionView reloadData];
        }
    }else if (level == 2){
        [_upLevelBtn setTitle:@"上一级" forState:UIControlStateNormal];
        NSLog(@"item = %@.text = %@", [citys objectForKey:self.dataSource[indexPath.item]],self.dataSource[indexPath.item]);
        NSString * upid = [citys objectForKey:self.dataSource[indexPath.item]];
        if (upid) {
            [params setObject:upid forKey:@"upid"];
            [self getAreaArrayWithParams:params];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }
    NSLog(@"level  %ld", level);
    
}

- (void)getAreaArrayWithParams:(NSMutableDictionary *)_params{
    [NetRequest postDataWithUrlString:AddressUrlStr withParams:_params success:^(id data) {
        
        if ([data[@"code"] isEqualToString:@"1"]) {
            level = 3;
            self.dataSource = [[NSMutableArray alloc] init];
            NSLog(@"%@", data);
            for (NSDictionary * dict in data[@"data"]) {
                [self.dataSource addObject:dict[@"name"]];
            }
            
        }else
        {
            NSLog(@"获取失败！ message %@", data[@"message"]);
        }
        
    } fail:^(NSString *errorDes) {
        
        NSLog(@"error : %@", errorDes);
    }];
}


#pragma mark - TableViewSelectedEvent
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverListDetailViewController * DriverDetailVC = [[DriverListDetailViewController alloc] init];
    DriverDetailVC.driverModel = self.tableView.tabViewDataSource[indexPath.section];
    NSLog(@"%@", DriverDetailVC.driverModel);
    [self.navigationController pushViewController:DriverDetailVC animated:YES];
}

-(void)headerRefreshingEvent{
    NSLog(@"上拉刷新");
    _page = 1;
    [self showHUD:@"数据加载中，请稍候。。" isDim:YES];
    
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Apporder/search_vehicle.html";
    NSDictionary * _params = @{@"p":[NSString stringWithFormat:@"%ld", _page]};
    NSLog(@"%@?%@", urlStr, _params);
    [NetRequest getDataWithUrlString:urlStr withParams:_params success:^(id data) {
        [self.tableView.tabViewDataSource removeAllObjects];
        NSLog(@"dataSource --- %@----", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            for (NSDictionary * dict in data[@"data"]) {
                HomeListModel * model = [[HomeListModel alloc] initWithDictionary:dict error:nil];
                [self.tableView.tabViewDataSource addObject:model];
            }
            [self.tableView reloadData];
        }else if ([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:data[@"message"]];
        }
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
        [self hideHUD];
        [self showTipView:@"数据请求失败，请检查网络设置"];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)footerRefreshingEvent{
    NSLog(@"下拉加载更多");
    _page++;
    [self showHUD:@"正在加载更多数据，请稍候。。" isDim:YES];
    
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Apporder/driver_list.html";
    NSDictionary * _params = @{@"p":[NSString stringWithFormat:@"%ld", _page]};
    [NetRequest getDataWithUrlString:urlStr withParams:_params success:^(id data) {
        
        if ([data[@"code"] isEqualToString:@"1"]) {
            for (NSDictionary * dict in data[@"data"]) {
                HomeListModel * model = [[HomeListModel alloc] initWithDictionary:dict error:nil];
                [self.tableView.tabViewDataSource addObject:model];
            }
        }else if ([data[@"code"] isEqualToString:@"2"]){
            if ([data[@"message"] isEqualToString:@"暂无数据"]) {
                [self showTipView:@"暂无更多车源数据"];
            }
        }
        [self.tableView reloadData];
        [self hideHUD];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
        [self hideHUD];
        [self showTipView:@"数据请求失败，请检查网络设置"];
        [self.tableView.mj_footer endRefreshing];
    }];
}



#pragma mark - Getter
-(BaseTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 103, screen_width, screen_height - 103) style:UITableViewStyleGrouped cellHeight:100];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableViewIdentifier];
        _tableView.tableViewEventDelegate = self;
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


-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, screen_width, 210) collectionViewLayout:flowLayout];
        
        flowLayout.itemSize = CGSizeMake(80, 30);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        [_collectionView registerNib:[UINib nibWithNibName:@"LabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellIde"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _collectionView.layer.borderWidth = 1;
        _collectionView.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    return _collectionView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
