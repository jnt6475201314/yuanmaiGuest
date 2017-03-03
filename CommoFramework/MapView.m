//
//  MapView.m
//  Working
//
//  Created by 姜宁桃 on 16/8/4.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "MapView.h"

@interface MapView ()

@property (nonatomic, strong) CLGeocoder * geocoder;

@property (nonatomic, strong) MKRoute * route;

@property (nonatomic, strong) MKPolyline * naviPath;

@end

@implementation MapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, screen_width, CGRectGetHeight(frame))];
        _mapView.delegate = self;
        _mapView.showsCompass = YES;
        _mapView.showsScale = YES;
        
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.mapType = MKMapTypeStandard;
        
        
        [self addSubview:_mapView];
        // 打开用户定位
        _mapView.showsUserLocation = NO;
        
        [self allocLocationManager];
        // 定位服务开启
        if ([CLLocationManager locationServicesEnabled]) {
            [_locationManager startUpdatingLocation];
        }
        
        _geocoder = [[CLGeocoder alloc] init];
        
        
    }
    return self;
}


#pragma mark - CLLocationManager

- (void)allocLocationManager
{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

// 根据两个地标，向苹果服务器请求对应的行走路线信息
- (void)directionsWithBeginPlackmark:(CLPlacemark *)beginP andEndPlacemark:(CLPlacemark *)endP
{
    NSLog(@"向苹果服务器请求对应的行走路线信息");
    // 创建请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    // 设置开始地标
    MKPlacemark *beginMP = [[MKPlacemark alloc] initWithPlacemark:beginP];
    request.source = [[MKMapItem alloc] initWithPlacemark:beginMP];
    
    
    // 设置结束地标
    MKPlacemark *endMP = [[MKPlacemark alloc] initWithPlacemark:endP];
    request.destination = [[MKMapItem alloc] initWithPlacemark:endMP];
    
    // 根据请求，获取实际路线信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            if (response.routes.count > 0) {
                MKRoute * route = response.routes[0];
                self.naviPath = route.polyline;
                // 回到主线程中画折线
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.mapView addOverlay:self.naviPath level:MKOverlayLevelAboveLabels];
                });
            }
            
            //        [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            NSLog(@"%@--", obj.name);
            //            [obj.steps enumerateObjectsUsingBlock:^(MKRouteStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ////                NSLog(@"%@", obj.instructions);
            //                NSLog(@"%f", obj.distance);
            ////                NSLog(@"%@", obj.polyline);
            //
            //
            //                [instruArr addObject:obj.instructions];
            //
            //            }];
            //            [self locationArrayWithInstructions:instruArr];
            //        }];
            
        }];

    });
    
}


#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    
}

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    
//}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    
    MKOverlayRenderer *renderer = nil;
    MKPolylineRenderer *line=[[MKPolylineRenderer alloc]initWithOverlay:overlay];
    line.lineWidth=4;
    [line setStrokeColor:[UIColor redColor]];
    renderer=line;
    return  renderer;
}


-(void) showRouteFrom: (Place*) f to:(Place*) t driverPlace:(Place *)p
{
    //根据“北京市”进行地理编码
    [_geocoder geocodeAddressString:f.name completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark=[placemarks firstObject];//获取第一个地标
        //        MKPlacemark *mkplacemark=[[MKPlacemark alloc]initWithPlacemark:clPlacemark];//定位地标转化为地图的地标
        //        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
        //        MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:mkplacemark];
        //        [mapItem openInMapsWithLaunchOptions:options];
        
        [_geocoder geocodeAddressString:t.name completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            CLPlacemark * destinationMark = [placemarks firstObject];
            MKPlacemark * destinationPlaceMark = [[MKPlacemark alloc] initWithPlacemark:destinationMark];
            
            NSLog(@"clPlacemark latitude%f, longitude %f, destinationMark latitude %f, longitude %f", clPlacemark.location.coordinate.latitude, clPlacemark.location.coordinate.longitude, destinationPlaceMark.location.coordinate.latitude, destinationPlaceMark.location.coordinate.longitude);
            KCAnnotation * beginAnnotation = [[KCAnnotation alloc] init];
            beginAnnotation.title = @"出发地";
            beginAnnotation.subtitle = f.name;
            beginAnnotation.coordinate = clPlacemark.location.coordinate;
            [_mapView addAnnotation:beginAnnotation];
            
            
            
            KCAnnotation * destinationAnnotaion = [[KCAnnotation alloc] init];
            destinationAnnotaion.title = @"目的地";
            destinationAnnotaion.subtitle = t.name;
            destinationAnnotaion.coordinate = destinationPlaceMark.location.coordinate;
            [_mapView addAnnotation:destinationAnnotaion];
            
            CLLocationCoordinate2D topLeftCoord;
            topLeftCoord.latitude = clPlacemark.location.coordinate.latitude;
            topLeftCoord.longitude = clPlacemark.location.coordinate.longitude;
            
            CLLocationCoordinate2D bottomRightCoord;
            bottomRightCoord.latitude = destinationPlaceMark.location.coordinate.latitude;
            bottomRightCoord.longitude = destinationPlaceMark.location.coordinate.longitude;
            
            for(id<MKAnnotation> annotation in _mapView.annotations) {
                topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
                topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
                bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
                bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            }
            
            MKCoordinateRegion region;
            region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
            region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
            region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
            
            // Add a little extra space on the sides
            region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
            
            region = [_mapView regionThatFits:region];
            [_mapView setRegion:region];
//            region = [MapView regionThatFits:region];
//            [MapView setRegion:region animated:YES];
            
            [self directionsWithBeginPlackmark:clPlacemark andEndPlacemark:destinationMark];
            
//            NSString * driverDrect = p.name;
            [_geocoder geocodeAddressString:p.name completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark * driverPlacemark = [placemarks firstObject];
                MKPlacemark * driverPM = [[MKPlacemark alloc] initWithPlacemark:driverPlacemark];
                CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(driverPM.location.coordinate.latitude, driverPM.location.coordinate.longitude);
                NSLog(@"xxx %f, %f", location1.latitude, location1.longitude);
                KCAnnotation *annotation1=[[KCAnnotation alloc]init];
                annotation1.title=@"司机当前位置";
                annotation1.subtitle=p.name;
                annotation1.coordinate=location1;
                [_mapView addAnnotation:annotation1];
                
            }];
            
        }];
        
    }];
    
    //根据线路确定呈现范围
//    [self centerMap];
}

//用routes数组的内容 确定region的呈现范围
-(void) centerMap {
    MKCoordinateRegion region;
    
    region.center.latitude     = 49.923972;// (maxLat + minLat) / 2;
    region.center.longitude    = 96.305143; //(maxLon + minLon) / 2;
    region.span.latitudeDelta  = 100.76555;//maxLat - minLat;
    region.span.longitudeDelta = 116.305143; //maxLon - minLon;
    
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    if ([[annotation title] isEqualToString:@"目的地"]) {
        newAnnotation.image = [UIImage imageNamed:@"pub_detail_destionation"];
    }
    else if([[annotation title] isEqualToString:@"出发地"]){
        newAnnotation.image = [UIImage imageNamed:@"pub_detail_startImg"];
        
    }else if ([[annotation title] isEqualToString:@"司机当前位置"]){
        newAnnotation.image = [UIImage imageNamed:@"map_truck"];
    }
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
    MKPinAnnotationView * pinView = (MKPinAnnotationView *)[views objectAtIndex:0];
    [_mapView selectAnnotation:pinView.annotation animated:YES];
    /*
    MKAnnotationView * annotaionView;
//    KCAnnotation * annotaionView;
    for (annotaionView in views) {
        if (![annotaionView isKindOfClass:[MKAnnotationView class]]) {
            CGRect endFrame = annotaionView.frame;
            annotaionView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y - 230, endFrame.size.width, endFrame.size.height);
            
            [UIView beginAnimations:@"drop" context:NULL];
            [UIView setAnimationDuration:0.45];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [annotaionView setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
     */
}

@end
