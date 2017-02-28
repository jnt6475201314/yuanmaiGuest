//
//  MyPicButton.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPicButton : UIButton

typedef NS_ENUM(NSInteger, NSPicPlacement) {
    NSPicPlacementLeft      = 0,    // Visually left aligned
    NSPicPlacementCenter    = 1,    // Visually centered
    NSPicPlacementRight     = 2,    // Visually right aligned
} NS_ENUM_AVAILABLE_IOS(6_0);

@property (nonatomic,readonly)UIImageView *btnView;
@property (nonatomic,readonly)UILabel *btnLabel;
@property (nonatomic,assign)float imageWidth;
@property (nonatomic)NSPicPlacement picPlacement;

//间隙
@property (nonatomic,assign)float imageDistant;
@property (nonatomic,assign)float txtImgDistant;

#pragma mark 选择状态和非选择状态
@property (nonatomic,assign)BOOL myBtnSelected;
//非选择状态
@property (nonatomic,strong)NSString *nomalTitle;
@property (nonatomic,strong)UIColor *nomalTitleColor;
@property (nonatomic,strong)NSString *nomalImage;
//选择状态
@property (nonatomic,readonly)UIColor *selectedTitleColor;
@property (nonatomic,readonly)NSString *selectedImage;
@property (nonatomic,strong)NSString *selectedTitle;

//无图
- (void)setOnlyText;
//居中模式
- (void)setContentCenter;
//文本宽度
- (float)getLabelTextWidth;
//整体宽度
- (float)getAllWidth;
//设置按钮内--内容(图文模式)
- (void)setBtnViewWithImage:(NSString *)imageName withImageWidth:(float)width withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withFont:(UIFont *)font;
//设置按钮内--文本(无图模式)
- (void)setBtnViewWithTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withFont:(UIFont *)font;
#pragma mark -- 设置按钮选择状态与常规状态
//常规状态
- (void)setBtnNomalImage:(NSString *)imageName withNomalTitle:(NSString *)title withNomalTitleColor:(UIColor *)nomalColor;
//选择状态
- (void)setBtnselectImage:(NSString *)imageName withselectTitleColor:(UIColor *)nomalColor;
//设置字体
- (void)setBtnFont:(UIFont *)font;

@end
