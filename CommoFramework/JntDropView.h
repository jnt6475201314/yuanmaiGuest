//
//  JntDropView.h
//  iOS selecte
//
//  Created by 姜宁桃 on 2016/11/22.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger{
    menuArrowStyleSolid  = 0,
    menuArrowStyleHollow = 1,
}menuArrowStyle;

@protocol MenuViewDelegate <NSObject>

// 代理方法
/*点击menu按钮的代理，点击的button的tag数，button的title*/
- (void)MenuClickButton:(UIButton *)button Index:(NSInteger)menuIndex menuTitle:(NSString *)menuTitle;

/** 代理方法返回 菜单标题:MenuTitle  菜单标题index:MenuTitleIndex 一级菜单内容:firstContent 一级菜单index:firstIndex 二级菜单内容:secondContent 二级菜单index:secondIndex  三级菜单内容:thirdContent  三级菜单index:thirdIndex (返回的内容和index在一个代理方法中) */
//- (void)menuCellDidSelected:(NSString *)MenuTitle menuIndex:(NSInteger)menuIndex firstContent:(NSString *)firstContent firstIndex:(NSInteger)firstIndex secondContent:(NSString *)secondContent secondIndex:(NSInteger)secondIndex thirdContent:(NSString *)thirdContent thirdIndex:(NSInteger)thirdIndex;

#pragma mark - net
/** net代理方法返回 菜单标题index:MenuTitleIndex 菜单标题:MenuTitle */
//- (void)netMenuClickMenuIndex:(NSInteger)menuIndex menuTitle:(NSString *)menuTitle;

/** net代理方法返回 菜单标题index:MenuTitleIndex 菜单标题:MenuTitle  一级菜单内容:firstContent  一级菜单内容:firstContent */
//- (void)netMenuClickMenuIndex:(NSInteger)menuIndex menuTitle:(NSString *)menuTitle FirstIndex:(NSInteger)FirstIndex firstContent:(NSString *)firstContent;

@end

@interface JntDropView : UIView<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark -- 属性设置
/** 遮盖层颜色 */
@property (nonatomic,strong)UIColor *CarverViewColor;

/** 遮盖的动画时间 */
@property (nonatomic,assign)CGFloat caverAnimationTime;

/** 缩进的动画时间 */
@property (nonatomic,assign)CGFloat hideAnimationTime;

/** 菜单title的字体大小 */
@property (nonatomic,assign)CGFloat menuTitleFont;

/** 下拉菜单的的字体大小 */
@property (nonatomic,assign)CGFloat tableTitleFont;

/** 下拉菜单的的字体大小 */
@property (nonatomic,assign)CGFloat menuHeight;

/** 下拉菜单cell的高度 */
@property (nonatomic,assign)CGFloat cellHeight;

/** 旋转箭头的样式 */
@property (nonatomic,assign)menuArrowStyle menuArrowStyle;

/** 下拉的Tableview最大高度(超出高度可以滑动显示) */
@property (nonatomic,assign)CGFloat tableViewMaxHeight;

/** 自定义tag值防止和页面其他tag有冲突 */
@property (nonatomic,assign)NSInteger menuButtonTag;

/** 未选中字体的颜色 */
@property (nonatomic,strong)UIColor *unSelectedColor;

/** 选中字体的颜色 */
@property (nonatomic,strong)UIColor *selectedColor;

/** 设置代理 */
@property (nonatomic,assign) id<MenuViewDelegate>delegate;

@property (nonatomic,strong) UIView         *backView;
@property (nonatomic,strong) NSMutableArray *bgLayers;

- (void)createMenuViewWithData:(NSArray *)data;


/** 创建四组下拉菜单 */
//- (void)createFourMenuTitleArray:(NSArray *)menuTitleArray FirstArr:(NSArray *)firstArr SecondArr:(NSArray *)secondArr threeArr:(NSArray *)threeArr fourArr:(NSArray *)fourArr;

/** 收缩菜单 */
- (void)drawBackMenu;


#pragma mark -- net一级一级点击网络获取数据创建
//
///** net创建下拉菜单 */
//- (void)netCreateMenuTitleArray:(NSArray *)menuTitleArray;
//
///** net导入一级菜单数据 */
//- (void)netLoadFirstArray:(NSArray *)firstArray;
//
///** net导入二级菜单数据 */
//- (void)netLoadSecondArray:(NSArray *)SecondArray;

@end
