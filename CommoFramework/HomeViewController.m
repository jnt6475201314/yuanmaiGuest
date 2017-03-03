//
//  HomeViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "HomeViewController.h"
#import "XWDragCellCollectionView.h"
#import "CollectionViewCell.h"
#import "ScanViewController.h"
#import "HomeTableViewCell.h"
#import "HomeTableView.h"
#import "HomeListModel.h"

#import "MessagesViewController.h"  // 信息
#import "LookingForViewController.h"   // 找车
#import "CommentsViewController.h"  // 评价
//#import "ServeViewController.h"  // 服务
#import "DriverListDetailViewController.h"   // 司机列表详情界面
#import "NavigationViewController.h"   // 导航


@interface HomeViewController ()<XWDragCellCollectionViewDataSource, XWDragCellCollectionViewDelegate, TableViewSelectedEvent>
{
    NSInteger _page;
}
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSArray * data;
@property (nonatomic, weak) XWDragCellCollectionView *mainView;
@property (nonatomic, strong) HomeTableView * tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self headerRefreshingEvent];
    [self configUI];
    
    [self uploadPushInfoToServer];  // 上传推送数据到后台
}

- (void)uploadPushInfoToServer
{
    if (GETDeviceToken) {
        NSLog(@"%@?%@", API_GetPushStr_URL, @{@"uid":GETUID, @"device_token":GETDeviceToken});
        [NetRequest postDataWithUrlString:API_GetPushStr_URL withParams:@{@"uid":GETUID, @"device_token":GETDeviceToken} success:^(id data) {
            
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"1"]) {
                NSString * tags = data[@"data"][@"tags"];   // 别名
                NSLog(@"uploadPushInfoToServer data: %@, tags:%@", data, tags);
                // 向极光和后台发送别名
                [JPUSHService setTags:[NSSet setWithObject:@"yuanmaiClient"] alias:tags fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    
                    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
                }];
            }else
            {
                
            }
        } fail:^(NSString *errorDes) {
            
            NSLog(@"获取别名失败");
        }];
    }else
    {
        NSLog(@"tokenStr不存在");
    }
    
}


- (void)configUI{
    self.navView.backgroundColor = navBar_color;//color(67, 89, 224, 1);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"远迈物流";
    [self showRightBtn:CGRectMake(self.navView.width - 45*widthScale, 24, 40*widthScale, 36) withImage:@"nav_message_white" withImageWidth:24];
    self.dataSource = [[NSMutableArray alloc] init];
    
    UIButton * leftNavBtn = [UIButton buttonWithFrame:CGRectMake(10, 26, 30, 30) title:nil image:@"personal_img" target:self action:@selector(leftNavBtnClicked)];
    [self.navView addSubview:leftNavBtn];
    
    
    [self addSwipeRightGesture];
    
    // 添加上方轮播图
    
    // 本地加载 --- 创建不带标题的图片轮播器
    _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 320*widthScale, 137*heightScale) delegate:self placeholderImage:[UIImage imageNamed:@"placeHolderImg"]];
    // 情景二： 网络接口获取图片
    // 情景二： 网络接口获取图片
    NSMutableArray * imgStrData = [[NSMutableArray alloc] init]; ;
    [NetRequest postDataWithUrlString:API_HOME_GETCYCLEIMG_URL withParams:nil success:^(id data) {
        
        NSLog(@"%@", data);
        NSString * headUrl = @"http://202.91.248.43/Public/Uploads/carousel_figure/";
        for (NSDictionary * dict in data[@"data"]) {
            NSString * urlStr = [headUrl stringByAppendingString:dict[@"img"]];
            [imgStrData addObject:urlStr];
        }
        
        if (imgStrData.count > 0) {
            _headerView.imageURLStringsGroup = [NSArray arrayWithArray:imgStrData];
        }
    } fail:^(NSString *errorDes) {
        
        NSLog(@"获取轮播图数据出错，Reason：%@", errorDes);
    }];
    
    _headerView.pageControlDotSize = CGSizeMake(8*widthScale, 8*widthScale);
    _headerView.currentPageDotColor = [UIColor whiteColor];
    _headerView.backgroundColor = [UIColor lightGrayColor];
    _headerView.delegate = self;
    [_headerView adjustWhenControllerViewWillAppera];
    _headerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    
    _cellArray = [NSMutableArray arrayWithObjects:@"h_scanIcon", @"h_share",@"h_comments",@"h_services", nil];
    [self configDragCollectionView];
    
    [self configTableView];
}


- (void)configDragCollectionView{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //    layout.itemSize = CGSizeMake(80, 80);
    //    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // 定义每个UICollectionView 的大小
    layout.itemSize = CGSizeMake(70*widthScale, 92.5*heightScale);
    // 定义每个UICollectionView 横向的间距
    layout.minimumLineSpacing = 5*widthScale;
    // 定义每个UICollectionView 的纵向间距
    layout.minimumInteritemSpacing = 5*heightScale;
    // 定义每个UICollectionView 的边距
    layout.sectionInset = UIEdgeInsetsMake(5*heightScale, 5*widthScale, 5*heightScale, 5*widthScale); // 上左下右
    XWDragCellCollectionView *mainView = [[XWDragCellCollectionView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, screen_width, 100 * heightScale) collectionViewLayout:layout];
    _mainView = mainView;
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.shakeLevel = 3.0f;
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.showsHorizontalScrollIndicator = YES;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}

- (void)configTableView{
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _mainView.height + _headerView.height)];
        [view addSubview:_headerView];
        [view addSubview:_mainView];
        view;
    });
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
}

-(BaseTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 63, screen_width, screen_height - 110) style:UITableViewStyleGrouped cellHeight:100];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableViewIdentifier];
        _tableView.tableViewEventDelegate = self;
    }
    return _tableView;
}

-(NSArray *)data{
    if (!_data) {
//        _data = @[@"扫描", @"找车", @"评价", @"服务", @"常用地址", @"常用司机", @"消息", @"个人中心"];
        _data = @[@"扫描", @"分享", @"评价", @"服务"];
    }
    return _data;
}
#pragma mark - <XWDragCellCollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //    return self.data.count;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    NSArray *sec = _data[section];
    //    return sec.count;
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"cell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    
    NSArray * textArray = @[@"扫描", @"分享", @"评价", @"服务"];
    cell.imgView.image = [UIImage imageNamed:_cellArray[indexPath.item]];
    cell.text.text = textArray[indexPath.item];
    //按钮事件就不实现了……
    return cell;
}


- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    return _data;
}

#pragma mark - <XWDragCellCollectionViewDelegate>

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    _data = newDataArray;
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath{
    //拖动时候最后禁用掉编辑按钮的点击
    //    _editButton.enabled = NO;
}

- (void)dragCellCollectionViewCellEndMoving:(XWDragCellCollectionView *)collectionView{
    //    _editButton.enabled = YES;
}

#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    @[@"扫描", @"找车", @"评价", @"服务", @"常用地址", @"常用司机", @"消息", @"个人中心"]
    NSString * title = _data[indexPath.item];
    if ([title isEqualToString:@"扫描"]) {
        // 扫描订单
        [self scanBtnEvent];
    }else if ([title isEqualToString:@"找车"]) {
        // 找车
        LookingForViewController * LookingForVC = [[LookingForViewController alloc] init];
        [self.navigationController pushViewController:LookingForVC animated:YES];
    }else if ([title isEqualToString:@"评价"]) {
        // 评价
        CommentsViewController * commentVC = [[CommentsViewController alloc] init];
        [self.navigationController pushViewController:commentVC animated:YES];
    }else if ([title isEqualToString:@"服务"]) {
        // 服务
//        ServeViewController * serveVC = [[ServeViewController alloc] init];
//        [self.navigationController pushViewController:serveVC animated:YES];
        NavigationViewController * navigationVC = [[NavigationViewController alloc] init];
        [self.navigationController pushViewController:navigationVC animated:YES];
    }else if ([title isEqualToString:@"常用地址"]) {
        // 常用地址
        
    }else if ([title isEqualToString:@"常用司机"]) {
        // 常用司机列表
        
    }else if ([title isEqualToString:@"消息"]) {
        // 消息
//        [self messageBtnEvent];
    }else if ([title isEqualToString:@"个人中心"]){
        // 个人中心
        [self leftNavBtnClicked];
    }else if ([title isEqualToString:@"分享"]){
        [self shareBtnEvent];
    }
}

- (void)shareBtnEvent
{
    [self shareQQAndWechat:SHAREAPP_URL];
//    [self shareSheetView:@"远迈物流 司机版 App下载" withImage:@"shareAppIcon"];
    [self shareController:@"远迈物流 客户版 App下载" withImage:@"shareAppIcon"];
}

#pragma mark - SDCycleScrollViewDelegate
/** 图片滚动回调 */
- (void)_headerView:(SDCycleScrollView *)_headerView didScrollToIndex:(NSInteger)index
{
    
}
/** 点击图片回调 */
- (void)_headerView:(SDCycleScrollView *)_headerView didSelectItemAtIndex:(NSInteger)index
{
    
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
    
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Apporder/driver_list.html";
    NSDictionary * params = @{@"p":[NSString stringWithFormat:@"%ld", _page]};
    NSLog(@"%@?%@", urlStr, params);
    [NetRequest getDataWithUrlString:urlStr withParams:params success:^(id data) {
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
    NSDictionary * params = @{@"p":[NSString stringWithFormat:@"%ld", _page]};
    [NetRequest getDataWithUrlString:urlStr withParams:params success:^(id data) {
        
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



#pragma mark - Event Handler
- (void)leftNavBtnClicked
{
    JVFloatingDrawerViewController *drawer = [AppDelegateInstance drawerViewController];
    [drawer toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:nil];
    
}

- (void)navRightBtnClick:(UIButton *)button
{
    MessagesViewController * messageVC = [[MessagesViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

- (void)scanBtnEvent
{
    ScanViewController * scanVC = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}


#pragma mark -  SwipeGestureEvent
// 向右轻扫手势所做的事
- (void)addSwipeGestureRightEvent:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        //向右轻扫做的事情
        [self leftNavBtnClicked];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        //向左轻扫做的事情
        JVFloatingDrawerViewController *drawer = [AppDelegateInstance drawerViewController];
        [drawer closeDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
