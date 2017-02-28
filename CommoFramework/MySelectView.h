//
//  MySelectView.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NSSelectPicPlacement) {
    NSSelectPicPlacementLeft      = 0,    // Visually left aligned
    NSSelectPicPlacementCenter    = 1,    // Visually centered
    NSSelectPicPlacementRight     = 2,    // Visually right aligned
} NS_ENUM_AVAILABLE_IOS(6_0);
@protocol mySelectedBtnDelegate <NSObject>

- (void)mySelectedBtnSendSelectIndex:(int)selectedIndex;

@end

@interface MySelectView : UIView

//设置图片模式
@property (nonatomic)NSSelectPicPlacement selectPlacement;

@property (nonatomic,assign)int firstSelect;
@property (nonatomic,assign)BOOL standMoveView;
@property (nonatomic,weak)id<mySelectedBtnDelegate>mySelectDelegate;

//无图
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr noSelected:(BOOL)noSelelct;
//图文
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr withImgArr:(NSArray *)imgArr withImgWidth:(float)width noSelected:(BOOL)noSelelct;
//重设图片和文本
- (void)setImageArr:(NSArray *)imgArr withTitleArr:(NSArray *)titleArr;

#pragma mark -- 初始化属性--有选择状态下
//设置多个属性--存文本情况下
- (void)setTextViewWithNomalColor:(UIColor *)nomalColor withSelectColor:(UIColor *)selectColor withTitlefont:(UIFont *)font;
//设置多个属性--图文情况下
- (void)setImageViewWithNomalColor:(UIColor *)nomalColor withSelectColor:(UIColor *)selectColor withTitleFont:(UIFont *)font withselectImage:(NSArray *)selectImages;
//重置图片与文本距离
- (void)setImageDistant:(float)imageDistant withTxtDistant:(float)txtDistant;

//设置列,重新对btn进行排布
- (void)setViewCols:(int)viewCol;
#pragma mark -- 无选择状态下
- (void)setImageViewWithNomalTitleColor:(UIColor *)nomalColor withTitleFont:(UIFont *)font;

//设置边框属性
- (void)setViewBorderColor:(UIColor *)color borderWidth:(float)width;
//设置主流分割线
- (void)setViewSepColor:(UIColor *)color sepHeight:(float)height sepWidth:(float)width;
//设置滑动条高度
- (void)setMoveViewHeight:(float)height;
//设置滑动条隐藏--默认显示
- (void)setMoveViewHidden:(BOOL)hidden;

//按钮方法公有化
- (void)selectBtnClick:(MyPicButton *)button;

@end
