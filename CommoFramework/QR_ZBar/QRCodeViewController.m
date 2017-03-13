//
//  QRCodeViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/12.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "QRCodeViewController.h"
#import "MyQRCodeView.h"
#import "UIView+Layout.h"

@interface QRCodeViewController ()

@property(nonatomic,strong)UITextField *KeyCodeTF;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"生成二维码";
    [self showBackBtn];
    [self showRightBtn:CGRectMake(self.navView.width-50, 24, 40, 36) withFont:systemFont(16) withTitle:@"保存" withTitleColor:[UIColor whiteColor]];
    
    [self configUI];
}

- (void)configUI
{
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(self.KeyCodeTF.right, 120, 90, 40)];
    self.btn.backgroundColor = [UIColor blueColor];
    [self.btn setTitle:@"生成" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(shengCheng) forControlEvents:UIControlEventTouchUpInside];
    
    self.KeyCodeTF = [MYFactoryManager createTextField:CGRectMake(20, 120, screen_width - 40, 40) withPlaceholder:@"请输入关键字" withLeftViewTitle:@"" withLeftViewTitleColor:[UIColor darkTextColor] withLeftFont:16 withLeftViewWidth:5 withRightView:self.btn withDelegate:self];
    [self.view addSubview:self.KeyCodeTF];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/2 - 150, self.KeyCodeTF.bottom+40*heightScale, 300, 300)];
    [self.view addSubview:self.imageView];
}

-(void)shengCheng
{
    NSString *text = self.KeyCodeTF.text;
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
    
    [self.KeyCodeTF resignFirstResponder];
    
}

- (void)navRightBtnClick:(UIButton *)button
{
    if (self.imageView.image) {
        [self loadImageFinished:self.imageView.image];
    }else
    {
        [self showTipView:@"你还没有生成二维码，请先生成后再保存！"];
    }
    
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self showTipView:[NSString stringWithFormat:@"保存图片失败！error：%@", error]];
        NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    }else
    {
        [self showTipView:@"图片已成功保存至相册!"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
