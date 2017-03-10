//
//  MYFactoryManager.m
//  GoHiking_app
//
//  Created by qf on 15/10/13.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "MYFactoryManager.h"
#import "GTMBase64.h"
#import "UIDevice+deviceSystem.h"

@implementation MYFactoryManager
/**
 *  创建一个左边是图片的TF
 *
 *  @param frame 框架大小
 *  @param color 背景颜色
 *  @param image 图片名
 *
 *  @return TF
 */
+ (UITextField *)textFieldWithFrame:(CGRect)frame withBackGroundColor:(UIColor *)color withLeftImage:(NSString *)image{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    //    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = color;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    textField.leftView = leftView;
    
    return textField;
}

/*创建有边框的图像 */
+ (UIImageView *)createNomalImageViewWithFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.borderColor = sepline_color.CGColor;
    imageView.layer.borderWidth = 1;
    imageView.layer.cornerRadius = 5;
    imageView.clipsToBounds = YES;
    return imageView;
}

/*创建特定红色边框的按钮*/
+ (UIButton *)createRedButtonWithFrame:(CGRect)frame withTitle:(NSString *)title withTarget:(id)target withSelector:(SEL)sel {
    UIButton *sendIdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendIdBtn.frame = frame;
    sendIdBtn.layer.cornerRadius = 4;
    sendIdBtn.layer.borderColor = red_color.CGColor;
    sendIdBtn.layer.borderWidth = 0.5;
    sendIdBtn.titleLabel.font = systemFont(12.0f);
    [sendIdBtn setTitleColor:red_color forState:UIControlStateNormal];
    [sendIdBtn setTitle:title forState:UIControlStateNormal];
    [sendIdBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return sendIdBtn;
}

//发布页面输入框
/**
 *创建一个左边带有标题的TF
 *
 *  @param frame       框架大小
 *  @param placeholder placeHolder
 *  @param title       左边标题
 *  @param titleColor  标题颜色
 *  @param fontSize    左边标题大小
 *  @param width       左边宽度
 *  @param target      target
 *
 *  @return TF
 */
+ (UITextField *)createTextField:(CGRect)frame withPlaceholder:(NSString *)placeholder withLeftViewTitle:(NSString *)title withLeftViewTitleColor:(UIColor *)titleColor withLeftFont:(float)fontSize withLeftViewWidth:(float)width withDelegate:(id)target{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = systemFont(15.0f);
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = YES;
    textField.minimumFontSize = 10;
    textField.placeholder = placeholder;
    textField.delegate = target;
    UILabel *leftLabel = [UILabel labelWithFrame:CGRectMake(0, 0, width, frame.size.height) text:title font:fontSize textColor:titleColor];
    textField.leftView = leftLabel;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

/**
 *  创建左边有TF标题，右边带View的 TextField
 *
 *  @param frame       框架大小
 *  @param placeholder 提示文字
 *  @param title       TF左边标题
 *  @param titleColor  标题颜色
 *  @param fontSize    输入文字大小
 *  @param width       左边宽度
 *  @param rightView   右边的View
 *  @param target      target
 *
 *  @return 返回TextField
 */
+ (UITextField *)createTextField:(CGRect)frame withPlaceholder:(NSString *)placeholder withLeftViewTitle:(NSString *)title withLeftViewTitleColor:(UIColor *)titleColor withLeftFont:(float)fontSize withLeftViewWidth:(float)width withRightView:(UIView *)rightView withDelegate:(id)target{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = YES;
    textField.minimumFontSize = 10;
    textField.placeholder = placeholder;
    textField.delegate = target;
    UILabel *leftLabel = [UILabel labelWithFrame:CGRectMake(0, 0, width, frame.size.height) text:title font:fontSize textColor:titleColor];
    textField.leftView = leftLabel;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    return textField;
}

#pragma mark -- 登陆界面控件
//登陆
+ (UIView *)createLoginView:(CGRect)frame withCore:(BOOL)isCore{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if (isCore) {
        view.layer.cornerRadius = 5;
    }
    view.layer.borderColor = color(0, 0, 0, 0.1).CGColor;
    view.layer.borderWidth = 0.5;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
//登陆小控件
+ (UILabel *)createLabel:(CGRect)frame withTitle:(NSString *)title withFont:(float)fontSize{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = color(0, 0, 0, 0.8);
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
//登陆里的控件创建
+ (UITextField *)createTextField:(CGRect)frame withLeftView:(UIView *)leftView withPlaceholder:(NSString *)placeholder withDelegate:(id)target{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.layer.cornerRadius = 5;
    textField.background = [[UIImage imageNamed:@"rr_pub_button_silver.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = YES;
    textField.minimumFontSize = 10;
    textField.placeholder = placeholder;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = target;
    return textField;
}
//登陆按钮
+ (UIButton *)createBtn:(CGRect)frame withTitle:(NSString *)title target:(id)target withSel:(SEL)sel withTitleColor:(UIColor *)color withBackColor:(UIColor *)backColor{
    UIButton *logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.frame = frame;
    [logInBtn setTitle:title forState:UIControlStateNormal];
    [logInBtn setTitleColor:color forState:UIControlStateNormal];
    [logInBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    logInBtn.backgroundColor = backColor;
    logInBtn.titleLabel.font = boldSystemFont(18.0f);
    logInBtn.layer.cornerRadius = 5;
    
    //额外设置
    [logInBtn setTitleColor:red_color forState:UIControlStateSelected];
    [logInBtn setTitle:@"删除" forState:UIControlStateSelected];
    
    return logInBtn;
}

#pragma mark -- 左图式按钮
+ (UIButton *)createLeftImageBtn:(CGRect)frame withImage:(NSString *)imageName withImageWidth:(float)width withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withFont:(UIFont *)font {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    if (frame.size.height<width) {
        leftView.frame = CGRectMake(5, 0, frame.size.height, frame.size.height);
    }else {
        leftView.frame = CGRectMake(5, (frame.size.height-width)/2, width, width);
    }
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(leftView.right+5, 0, frame.size.width-leftView.right-10, frame.size.height) text:title font:15.0f textColor:titleColor];
    titleLabel.font = font;
    titleLabel.textAlignment = 1;
    [button addSubview:leftView];
    [button addSubview:titleLabel];
    return button;
}

#pragma mark -- 计算高度
+ (CGFloat)heightForString:(NSString *)string fontSize:(CGFloat)fontSize andWidth:(CGFloat)width{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.height;
}

+ (CGFloat)widthForString:(NSString *)string fontSize:(CGFloat)fontSize andHeight:(CGFloat)height{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.width;
}

#pragma mark -- 时间
+ (NSString *)getStartTimeDate:(double)dateTime format:(NSString *)format{
    if (format == nil) {
        format = @"yyyy/MM/dd";
    }
    NSTimeInterval time= dateTime;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式 @"yyyy/MM/dd"
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

/*处理返回应该显示的时间*/
+ (NSString *) returnUploadTime:(NSString *)timeStr
{
    NSTimeInterval time= [timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSDate *datenow = [NSDate date];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm dateFromString:currentDateStr];
    long dd = (long)[datenow timeIntervalSince1970] - [newdate timeIntervalSince1970];
    NSString *timeString=@"";
    if (dd/3600<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/60];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if (dd/3600>1&&dd/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/3600];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (dd/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/86400];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    return timeString;
}

//设置label的text不同颜色--评论中使用
+ (NSAttributedString *)getAttributeStringWithSender:(NSString *)senderStr withContent:(NSString *)content {
    NSAttributedString *nickName = [[NSAttributedString alloc] initWithString:senderStr attributes:@{NSForegroundColorAttributeName:red_color,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithAttributedString:nickName];
    [mString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@",content] attributes:@{NSForegroundColorAttributeName:color(0, 0, 0, 0.9),NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}]];
    return mString;
}

//字符串转字典与字典转字符串
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    return responseJSON;
}

+ (NSArray *)parseJSONStringToNSArray:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    return responseJSON;
}

+ (NSString*)arrayToJson:(NSArray *)arr

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+(NSString *)GTMEncodeTest:(NSString *)originStr

{
    
    NSString* encodeResult = nil;
    
    NSData* originData = [originStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* encodeData = [GTMBase64 encodeData:originData];
    
    encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    
    return encodeResult;
    
}


/**
 
 * GTM 解码
 
 */

+(NSString *)GMTDecodeTest:(NSString *)decodeStr

{
    
    NSString* decodeResult = nil;
    
    NSData* encodeData = [decodeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* decodeData = [GTMBase64 decodeData:encodeData];
    
    decodeResult = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    
    return decodeResult;
    
}

//获取部分显示手机格式
+ (NSString *)getPhoneText:(NSString *)phoneNum {
    NSString *headStr = [phoneNum substringToIndex:3];//截取掉下标2之前的字符串
    NSString *backStr = [phoneNum substringFromIndex:7];//截取掉下标6之后的字符串
    
    return [NSString stringWithFormat:@"%@****%@",headStr,backStr];
}

//修改图片尺寸
+ (NSData *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width > defineWidth) {
        CGFloat targetWidth = defineWidth;
        CGFloat targetHeight = (targetWidth / width) * height;
        UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
        [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    }
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.3);
}


+ (BOOL)phoneNum:(NSString *) textString {
    NSString *number = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

#pragma mark - 时间处理方法
// 获取当前时间的方法
+ (NSString *)getCurrentTime
{
    //获取当前时间日期
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    
    return dateStr;
}

// 获取两个时间之间的时间差
+ (NSString *)counttIntervalOfCurrentTime:(NSString *)currentTime AndPastTime:(NSString *)time
{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *expireDate = [dateFomatter dateFromString:currentTime];
    // 当前时间data格式
    NSDate * nowDate = [dateFomatter dateFromString:time];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    NSLog(@"year:%ld, month:%ld, day:%ld, hour:%ld, minute:%ld, second:%ld", (long)dateCom.year, (long)dateCom.month, (long)dateCom.day, (long)dateCom.hour, (long)dateCom.minute, (long)dateCom.second);
    
    if (dateCom.year > 0) {
        return [NSString stringWithFormat:@"%ld年前", (long)dateCom.year];
    }else if (dateCom.month > 0){
        return [NSString stringWithFormat:@"%ld月前", (long)dateCom.month];
    }else if (dateCom.day > 0){
        return [NSString stringWithFormat:@"%ld天前", (long)dateCom.day];
    }else if (dateCom.hour > 0){
        return [NSString stringWithFormat:@"%ld分钟前", (long)dateCom.minute];
    }else if(dateCom.minute > 10){
        return [NSString stringWithFormat:@"%ld分钟前", (long)dateCom.minute];
    }else if(dateCom.minute > 0 || dateCom.second > 0){
        return @"刚刚";
    }
    
    return nil;
}

+ (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    if ([UIDevice isSystemVersioniOS8]) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}



@end
