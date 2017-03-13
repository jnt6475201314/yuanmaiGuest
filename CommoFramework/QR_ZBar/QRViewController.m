//
//  QRViewController.m
//  QRCode
//
//  Created by Apple on 16/5/9.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import "QRViewController.h"
#import "MyQRCodeView.h"
#import "UIView+Layout.h"

#define HIGH [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface QRViewController ()

@property(nonatomic,strong)UITextField *KeyCode;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
   // [self setupQRCodeView];
    
    self.KeyCode = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, WIDTH-100, 40)];
    [self.view addSubview:self.KeyCode];
    self.KeyCode.borderStyle = UITextBorderStyleRoundedRect;
    self.KeyCode.placeholder = @"请输入关键字";
    
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 64, 90, 40)];
    self.btn.backgroundColor = [UIColor blueColor];
    [self.btn setTitle:@"生成" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(shengCheng) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.imageView.center = CGPointMake(WIDTH/2, HIGH/2);
    [self.view addSubview:self.imageView];
}

-(void)shengCheng
{
    NSString *text = self.KeyCode.text;
    NSData *stringData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offcolor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage",qrFilter.outputImage,@"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],@"inputColor1",[CIColor colorWithCGColor:offcolor.CGColor], nil];
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGSize size = CGSizeMake(300, 300);
    CGImageRef cgimage = [[CIContext contextWithOptions:nil]createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgimage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    CGImageRelease(cgimage);
    self.imageView.image = codeImage;
    
    [self.KeyCode resignFirstResponder];
    
}

//- (void)setupQRCodeView {
//    
//    // view 的高度 = view宽 + 上面高 + 下面高
//    MyQRCodeView *qrView = [[MyQRCodeView alloc] initWithFrame:
//                            CGRectMake(20, 40, self.view.width - 20 * 2, self.view.width - 20 * 2 + 60 + 30 + 30)];
//    
//    if ([UIScreen mainScreen].bounds.size.width <= 480) { // 4s 重新调整下高度
//        qrView.frame = CGRectMake(20, 20, self.view.width - 20 * 2, self.view.width - 20 * 2 + 60 + 30 + 10);
//    }
//    
//    [self.view addSubview:qrView];
//}

@end
