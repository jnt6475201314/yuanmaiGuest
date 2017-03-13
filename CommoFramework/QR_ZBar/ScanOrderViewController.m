//
//  ScanOrderViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/4.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "ScanOrderViewController.h"
#import "QRView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"
#import "QRCodeViewController.h"
#import "DetailOrderViewController.h"
#import "PublishLishModel.h"
#import "QRViewController.h"

@interface ScanOrderViewController ()<ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate>

@property (nonatomic,copy)NSString *urlString;
@property (nonatomic, copy) NSString * OrderNumber;
@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;

@end

static NSInteger ledType = 1;

@implementation ScanOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.vcTitle;
    self.backImageView.backgroundColor = [UIColor clearColor];
    [self showBackBtn];
    [self showRightBtn:CGRectMake(self.navView.width-50, 24, 40, 36) withFont:systemFont(16) withTitle:@"相册" withTitleColor:[UIColor whiteColor]];
    
    [self initConfig];
}

- (void)initConfig{
    // 检查授权
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResize;
    self.preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // 开始
    [self.session startRunning];
    
    QRView * qrView = [[QRView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64)];
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    CGSize size = CGSizeZero;
    if (self.view.frame.size.width > 320) {
        size = CGSizeMake(300, 300);
    }else {
        size = CGSizeMake(200, 200);
    }
    
    qrView.transparentArea = size;  // 透明的区域
    qrView.backgroundColor = [UIColor clearColor];
    qrView.center = CGPointMake(screen_width/2, (screen_height)/2+32);
    [self.view addSubview:qrView];
    
    UILabel * tipLabel = [UILabel labelWithFrame:CGRectMake(0, qrView.center.y - size.height/2 , self.view.width, 20) text:@"请将摄像头对准二维码即可自动扫描" font:15 textColor:[UIColor whiteColor]];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton * lightBtn = [UIButton buttonWithFrame:CGRectMake(screen_width/2 - 40, qrView.center.y + (size.height/2 + 35)*heightScale, 80, 80) title:@"开灯" image:nil target:self action:@selector(openLigntEvent:)];
    [lightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    lightBtn.titleLabel.font = boldSystemFont(17);
    lightBtn.backgroundColor = [UIColor whiteColor];
    lightBtn.layer.cornerRadius = 40;
    lightBtn.clipsToBounds = YES;
    
    UIButton * myQRViewBtn = [UIButton buttonWithFrame:CGRectMake(lightBtn.left-100*widthScale, qrView.center.y + size.height/2 + 45, 80*widthScale, 35*heightScale) title:@"生成二维码" image:nil target:self action:@selector(productMyQRViewEvent)];
    [myQRViewBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.view addSubview:tipLabel];
    [self.view addSubview:lightBtn];
    [self.view addSubview:myQRViewBtn];
}

#pragma mark - Evnet Hander
- (void)productMyQRViewEvent
{
    QRCodeViewController *qrCodeVC = [[QRCodeViewController alloc] init];
    [self presentViewController:qrCodeVC animated:YES completion:nil];
}

- (void)openLigntEvent:(UIButton *)btn
{
    btn.transform = CGAffineTransformMakeScale(0.6, 0.6);
    if (ledType) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [btn setTitle:@"关灯" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor brownColor];
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            [self turnOnLed];
        } completion:nil];

    }else
    {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [btn setTitle:@"开灯" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            [self turnOffLed];
        } completion:nil];
        
    }
    ledType = !ledType;
}

- (void)turnOnLed
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}

- (void)turnOffLed
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

-(void)navRightBtnClick:(UIButton *)button
{
    [self showTipView:@"请从相册中选择含二维码的图片"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ZBarReaderController *reader = [ZBarReaderController new];
        reader.allowsEditing = YES;
        reader.readerDelegate = self;
        reader.showsHelpOnFail = YES;
        reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:reader animated:YES completion:nil];
    });
}

//左边
//- (void)backClick:(UIButton *)button {
//    [self addAnimationWithType:TAnimationCameraIrisHollowClose Derection:FAnimationFromLeft];
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metaDataObject = [metadataObjects firstObject];
        
        self.urlString = metaDataObject.stringValue;
        NSLog(@"-----扫描结果:%@-----", self.urlString);
        [self showTipView:self.urlString];
    }
    
    [self handelURLString:self.urlString];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSArray * results = [info objectForKey:ZBarReaderControllerResults];
    if (results.count > 0) {
        int quality = 0;
        ZBarSymbol * bestResult = nil;
        for (ZBarSymbol * sym in results) {
            int tempQ = sym.quality;
            if (quality < tempQ) {
                quality = tempQ;
                bestResult = sym;
            }
        }
        
        [self presentResult:bestResult];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentResult:(ZBarSymbol *)sym
{
    if (sym) {
        NSString * tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        NSLog(@"%@", tempStr);
        
        [self handelURLString:tempStr];
    }
}

// 处理扫描的字符串
- (void)handelURLString:(NSString *)string
{
    NSArray * array = [string componentsSeparatedByString:@"/"];
    if ([string hasPrefix:@"http"]) {
        NSLog(@"%@", array);
        if (array.firstObject) {
            // 这里用户根据自己的业务逻辑进行处理 比如判断字符串是否包含某个特定的字符串 然后根据url跳转到响应的界面(如个人详情加好友页面....)
            if ([array[2] isEqualToString:@"www.baidu.com"]) {
                [self.session startRunning];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
            }else{
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示"message:[NSString stringWithFormat:@"该链接可能存在风险\n%@",string] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"打开链接",nil];
                alertView.tag = 100086;
                alertView.delegate = self;
                self.urlString = string;
                [self.session stopRunning];
                [alertView show];
            }
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示"message:[NSString stringWithFormat:@"扫描结果:\n%@",string] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        self.OrderNumber = string;
        alertView.tag = 100087;
        [self.session stopRunning];
        if (![self.vcTitle isEqualToString:@"便捷下单"]) {
            [self searchBtnEvent];
        }else
        {
            [alertView show];
        }
    }
}
#if 1
- (void)searchBtnEvent
{
    
    if (self.OrderNumber.length) {
        NSDictionary * params = @{@"num":self.OrderNumber};
        [self showTipView:@"正在查找数据信息，请稍候。。。"];
        NSLog(@"%@?%@", API_SCAN_URL,params);
        [NetRequest postDataWithUrlString:API_SCAN_URL withParams:params success:^(id data) {
            
            NSLog(@"%@",data);
            if ([data[@"code"] isEqualToString:@"1"]) {
                NSMutableArray * arr =[[NSMutableArray alloc] initWithArray:data[@"data"]];
                NSLog(@"%ld  arr:%@", arr.count, arr);
                
                NSMutableDictionary * modelDict = [[NSMutableDictionary alloc] initWithDictionary:arr[0]];
                NSMutableString * modelStr = [[NSMutableString alloc] init];
                for (NSMutableDictionary * dict in arr) {
                    NSString * str = [NSString stringWithFormat:@"%@,", dict[@"gid"]];
                    modelStr = [modelStr stringByAppendingString:[NSString stringWithFormat:@"%@", str]];
                }
                
                NSLog(@"%@", modelStr);
                [modelDict setObject:modelStr forKey:@"gid"];
                NSLog(@"%@", modelDict);
                
                DetailOrderViewController * detailOrderVC = [[DetailOrderViewController alloc] init];
//                detailOrderVC.upVCTitle = @"订单扫描";
                detailOrderVC.orderModel = [[PublishLishModel alloc] initWithDictionary:modelDict error:nil];
                NSLog(@"%@", detailOrderVC.orderModel);
                [self.navigationController pushViewController:detailOrderVC animated:YES];
                
            }else
            {
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示：无此订单信息"message:[NSString stringWithFormat:@"扫描结果:\n%@",self.OrderNumber] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                alertView.tag = 100088;
                [self.session stopRunning];
                [alertView show];
                
                [self showTipView:@"没有查询到此二维码订单信息！"];
            }
        } fail:^(id errorDes) {
            
            NSLog(@"%@", errorDes);
            [self showTipView:@"获取信息失败！"];
            [self.session startRunning];
        }];
    }else{
        [self showTipView:@"查询编码不能为空"];
        [self.session startRunning];
    }
    
}
#endif

#pragma mark - startSessionDelegate -
-(void)startSessionEvent{
    // 开始扫描
    [self.session startRunning];
}


#pragma mark ---alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100086) {
        if (buttonIndex == 1) {
            [self.session startRunning];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
        } else {
            [self.session startRunning];
        }
    }
    
    if (alertView.tag == 100087) {
        if (buttonIndex == 0) {
            [self.session startRunning];
            if ([self.Odelegate respondsToSelector:@selector(returnOrderNum:)]) {
                [self.Odelegate returnOrderNum:self.OrderNumber];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag == 100088) {
        if (buttonIndex == 0) {
            [self.session startRunning];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
