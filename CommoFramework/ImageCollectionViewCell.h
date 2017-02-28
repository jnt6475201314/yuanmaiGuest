//
//  ImageCollectionViewCell.h
//  Working
//
//  Created by 姜宁桃 on 2016/10/10.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageCollectionViewCell;
@protocol CellDelegate <NSObject>

-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath cellView:(ImageCollectionViewCell *)cell;
-(void)showAllDeleteBtn;
-(void)hideAllDeleteBtn;

@end

@interface ImageCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong)UIImageView *imgView;

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak) id<CellDelegate>delegate;

@end
