//
//  MapView.h
//  Working
//
//  Created by 姜宁桃 on 16/8/4.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import "Place.h"

@interface MapView : UIView<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) Place * driverPlace;

@property (nonatomic, strong) MKMapView * mapView;
@property (nonatomic, strong) CLLocationManager * locationManager;

// 显示路线 和司机的位置
-(void) showRouteFrom: (Place*) f to:(Place*) t driverPlace:(Place *)p;

@end
