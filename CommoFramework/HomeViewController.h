//
//  HomeViewController.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"
#import <SDCycleScrollView.h>

@interface HomeViewController : BaseViewController<SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray * _cellArray;  // collectionView数据
    SDCycleScrollView * _headerView;
}

@property (nonatomic, strong) UICollectionView * collectionView;

@end
