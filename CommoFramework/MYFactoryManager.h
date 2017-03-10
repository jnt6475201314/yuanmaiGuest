//
//  MYFactoryManager.h
//  GoHiking_app
//
//  Created by qf on 15/10/13.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>
//懒加载专用
@interface MYFactoryManager : NSObject

+ (UITextField *)textFieldWithFrame:(CGRect)frame withBackGroundColor:(UIColor *)color withLeftImage:(NSString *)image;
//创建有边框的图像
+ (UIImageView *)createNomalImageViewWithFrame:(CGRect)frame;
//发布页面输入框
+ (UITextField *)createTextField:(CGRect)frame withPlaceholder:(NSString *)placeholder withLeftViewTitle:(NSString *)title withLeftViewTitleColor:(UIColor *)titleColor withLeftFont:(float)fontSize withLeftViewWidth:(float)width withDelegate:(id)target;
//左右输入框
+ (UITextField *)createTextField:(CGRect)frame withPlaceholder:(NSString *)placeholder withLeftViewTitle:(NSString *)title withLeftViewTitleColor:(UIColor *)titleColor withLeftFont:(float)fontSize withLeftViewWidth:(float)width withRightView:(UIView *)rightView withDelegate:(id)target;
//创建特定红色边框的按钮
+ (UIButton *)createRedButtonWithFrame:(CGRect)frame withTitle:(NSString *)title withTarget:(id)target withSelector:(SEL)sel;

#pragma mark -- 登陆界面控件
+ (UIView *)createLoginView:(CGRect)frame withCore:(BOOL)isCore;
//登陆控件
+ (UILabel *)createLabel:(CGRect)frame withTitle:(NSString *)title withFont:(float)fontSize;
//textField
+ (UITextField *)createTextField:(CGRect)frame withLeftView:(UIView *)leftView withPlaceholder:(NSString *)placeholder withDelegate:(id)target;
//登陆按钮
+ (UIButton *)createBtn:(CGRect)frame withTitle:(NSString *)title target:(id)target withSel:(SEL)sel withTitleColor:(UIColor *)color withBackColor:(UIColor *)backColor;

/**高度自适应*/
+ (CGFloat)heightForString:(NSString *)string fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;

/**宽度自适应*/
+ (CGFloat)widthForString:(NSString *)string fontSize:(CGFloat)fontSize andHeight:(CGFloat)height;


//时间计算
+ (NSString *)getStartTimeDate:(double)dateTime format:(NSString *)format;
+ (NSString *) returnUploadTime:(NSString *)timeStr;

//设置label的text不同颜色--评论中使用
+ (NSAttributedString *)getAttributeStringWithSender:(NSString *)senderStr withContent:(NSString *)content;

//字符串转字典与字典转字符串
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSString*)arrayToJson:(NSArray *)arr;
+ (NSArray *)parseJSONStringToNSArray:(NSString *)JSONString;

//编码和解码base64
+(NSString *)GTMEncodeTest:(NSString *)originStr;
+(NSString *)GMTDecodeTest:(NSString *)decodeStr;

//获取部分显示手机格式
+ (NSString *)getPhoneText:(NSString *)phoneNum;
//修改图片尺寸
+ (NSData *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
//手机格式
+ (BOOL)phoneNum:(NSString *) textString;

// 获取当前时间的方法
+ (NSString *)getCurrentTime;
// 获取两个时间之间的时间差
+ (NSString *)counttIntervalOfCurrentTime:(NSString *)currentTime AndPastTime:(NSString *)time;

+ (BOOL)isAllowedNotification;

@end
