//
//  NavigationViewController.m
//  Working
//
//  Created by 姜宁桃 on 16/7/22.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "NavigationViewController.h"
#import <MapKit/MapKit.h>
#import "MBProgressHUD+MJ.h"
#import "MHTransformCorrdinate.h"

#define MHSafeString(str) (str == nil ? @"" : str)

@interface NavigationViewController ()<UITextFieldDelegate, CLLocationManagerDelegate>
{
    UITextField * _startTF; // 起点
    UITextField * _destinationTF; // 终点🏁
    
    UIButton * _startNavigation; // 获取导航路线的按钮
}

@property (nonatomic, strong) CLLocationManager * locManager;
/*地理编码*/
@property (nonatomic, strong) CLGeocoder * geocoder;


@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"出行导航";
    [self showBackBtn];
    [self addSwipeRightGesture];
    [self configUI];
}

- (void)configUI
{
//    _startTF = [MYFactoryManager createTextField:CGRectMake(20, 100, screen_width - 40, 40) withPlaceholder:@"请输入导航的起点地址" withLeftViewTitle:@"   出发地：" withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:80 withDelegate:self];
    UIButton * myAddrBtn = [UIButton buttonWithFrame:CGRectMake(0, 5, 29, 29) title:nil image:@"map_addr" target:self action:@selector(myAddrBtnEvent)];
    _startTF = [MYFactoryManager createTextField:CGRectMake(20, 100, screen_width - 40, 40) withPlaceholder:@"请输入导航的起点地址" withLeftViewTitle:@"   出发地：" withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:80 withRightView:myAddrBtn withDelegate:self];
    [self.view addSubview:_startTF];
    
    _destinationTF = [MYFactoryManager createTextField:CGRectMake(20, 160, screen_width - 40, 40) withPlaceholder:@"请输入导航的终点地址" withLeftViewTitle:@"   目的地：" withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:80 withDelegate:self];
    [self.view addSubview:_destinationTF];
    
    _startNavigation = [[UIButton alloc] initWithFrame:CGRectMake(20, 240, screen_width - 40, 40)];
    [_startNavigation setTitle:@"开始导航" forState:UIControlStateNormal];
    _startNavigation.backgroundColor = [UIColor orangeColor];
    [_startNavigation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startNavigation addTarget:self action:@selector(startNavigationEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startNavigation];
}

#pragma mark - myAddrBtnEvent
- (void)myAddrBtnEvent
{
    [self.locManager requestAlwaysAuthorization];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        UIAlertView *alvertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"需要您开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways ||
             status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locManager startUpdatingLocation];
    }
    else {
        UIAlertView *alvertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"定位服务授权失败,请检查您的定位设置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}

/**
 *  授权状态发生改变时调用
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
/**
 *  获取到位置信息之后就会调用(调用频率非常高)
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locManager stopUpdatingLocation];
    /*
     location.coordinate; 坐标, 包含经纬度
     location.altitude; 设备海拔高度 单位是米
     location.course; 设置前进方向 0表示北 90东 180南 270西
     location.horizontalAccuracy; 水平精准度
     location.verticalAccuracy; 垂直精准度
     location.timestamp; 定位信息返回的时间
     location.speed; 设备移动速度 单位是米/秒, 适用于行车速度而不太适用于不行
     */
    CLLocation *location = [locations lastObject];
    NSLog(@"经度 = %f, 纬度 = %f, speed = %f, 海拔 = %f", location.coordinate.latitude , location.coordinate.longitude, location.speed, location.altitude);
//    _gLongFeild.text = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
//    _gLatFeild.text = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    [self fanDiLiMianMa:location];
}

- (void)fanDiLiMianMa:(CLLocation *)location
{
    [self.view endEditing:YES];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_gLatFeild.text doubleValue] longitude:[_gLongFeild.text doubleValue]];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            _startTF.text = MHSafeString(@"您确定还在地球上吗?");
        }
        for (CLPlacemark *placemark in placemarks) {
            NSDictionary *dict = placemark.addressDictionary;
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                 MHSafeString(placemark.administrativeArea),
                                 MHSafeString(placemark.subAdministrativeArea),
                                 MHSafeString(placemark.locality),
                                 MHSafeString(placemark.subLocality),
                                 MHSafeString(placemark.thoroughfare),
                                 MHSafeString(placemark.subThoroughfare)];
            
            if (address.length == 0) {
                address = [NSString stringWithFormat:@"%@%@",
                           [dict objectForKey:@"Country"],
                           [dict objectForKey:@"Name"]];
            }
            _startTF.text = address;
            NSLog(@"反编码具体位置:%@",address);
        }
    }];

}

#pragma mark - startNavigationEvent
/**
 *  开始导航
 */
- (void)startNavigationEvent
{
    // 1. 获取用户输入的起点终点
    NSString * startStr = _startTF.text;
    NSString * destinationStr = _destinationTF.text;
    
    if (startStr == nil || startStr.length == 0 || destinationStr == nil || destinationStr.length == 0) {
        [MBProgressHUD showError:@"请输入地址"];
    }
    
    // 2.利用GEO对象进行地理编码获取地标对象
    // 2.1 获取开始位置的地标
    [self.geocoder geocodeAddressString:startStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error != nil) {
            [MBProgressHUD showError:@"请输入地址"];
            return ;
        }
        // 2 开始位置的地标
        CLPlacemark * startPlaceMark = [placemarks firstObject];
        
        // 3 获得结束位置的地标
        [self.geocoder geocodeAddressString:destinationStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count == 0 || error != nil) {
                [MBProgressHUD showError:@"请输入地址"];
                return ;
            }
            CLPlacemark * endPlaceMark = [placemarks firstObject];
            // 4 获得地标后开始导航
            [self startNavigationWithStartPlaceMark:startPlaceMark andEndStartPlaceMark:endPlaceMark];
        }];
    }];
}

/**
 *  利用地标位置开始设置导航
 *
 *  @param startPlaceMark 开始位置的地标
 *  @param endPlaceMark   结束位置的地标
 */
- (void)startNavigationWithStartPlaceMark:(CLPlacemark *)startPlaceMark andEndStartPlaceMark:(CLPlacemark *)endPlaceMark
{
    // 0.创建起点
    MKPlacemark * startMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:startPlaceMark];
    // 创建终点
    MKPlacemark * endMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:endPlaceMark];
    
    // 1.设置起点位置
    MKMapItem * startMapItem = [[MKMapItem alloc] initWithPlacemark:startMKPlacemark];
    // 2.设置终点位置
    MKMapItem * endMapItem = [[MKMapItem alloc] initWithPlacemark:endMKPlacemark];
    // 3.起点、终点数组
    NSArray * items = @[startMapItem, endMapItem];
    
    // 4. 设置地图的附加参数，是个字典
    NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
    // 导航模式（驾车、步行、公交）
    dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    // 地图显示的模式
    dictM[MKLaunchOptionsMapTypeKey] = MKMapTypeStandard;
    
    // 只要调用MKMapItem的open方法，就可以调用系统自带地图的导航
    // Items 告诉系统地图从哪到哪
    // LaunchOptions: 启动地图App参数（导航的模式／是否需要先交通状况／地图的模式。。。）
    
    [MKMapItem openMapsWithItems:items launchOptions:dictM];
}

#pragma mark - Getter
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (CLLocationManager *)locManager
{
    if (_locManager == nil) {
        _locManager = [[CLLocationManager alloc] init];
        self.locManager.distanceFilter = 10.0f;
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.delegate = self;
    }
    return _locManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
