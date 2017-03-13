//
//  ScanViewController.m
//  QRCode
//
//  Created by Apple on 16/5/9.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import "ScanViewController.h"
#import "QRViewController.h"
#import "QRView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"
#import "QRViewController.h"
//#import "OrderDetailViewController.h"
//#import "GoodsSourceModel.h"

@interface ScanViewController ()<
ZBarReaderDelegate,
AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate
>

//加载视图
@property (nonatomic,strong)UILabel *tipLabel;

@property (nonatomic,copy)NSString *urlString;
@property (nonatomic, copy) NSString * OrderNumber;
@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@end
static NSInteger ledType = 1;
@implementation ScanViewController
-(void)viewWillAppear:(BOOL)animated
{
    //显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航栏半透明
    self.navigationController.navigationBar.translucent = NO;
    //设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = color(67, 89, 224, 1);
    //设置导航栏按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //隐藏导航栏上按钮的文字
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    //隐藏标签栏
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(openQRPhoto)];
    
    self.navigationItem.rightBarButtonItem = barBtn;
    self.title = @"扫描二维码";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};

    [self initConfig];
   
 }


- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}
- (void)initConfig {
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
    
    // kaishi
    [self.session startRunning];
    
    QRView *qrView = [[QRView alloc] initWithFrame:self.view.frame];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    CGSize size = CGSizeZero;
    if (self.view.frame.size.width > 320) {
        size = CGSizeMake(300, 300);
    } else {
        size = CGSizeMake(200, 200);
    }
    
    qrView.transparentArea = size;
    qrView.backgroundColor = [UIColor clearColor];
    qrView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 50);
    [self.view addSubview:qrView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, qrView.center.y - size.height/2 - 30,
                                                                  self.view.frame.size.width, 20)];
    tipLabel.text = @"请将摄像头对准二维码 即可自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *myQRViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(qrView.frame.origin.x+50,qrView.center.y + size.height/2 + 15,100, 20)];
    
    NSLog(@"*****%f\n",qrView.frame.origin.x);
    
    [myQRViewBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    myQRViewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [myQRViewBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
    [myQRViewBtn addTarget:self action:@selector(go2myQRView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *lightBtn = [[UIButton alloc]initWithFrame:CGRectMake(qrView.frame.origin.x+200, qrView.center.y+size.height/2+15, 100, 20)];
    [lightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    lightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [lightBtn setTitle:@"开灯" forState:UIControlStateNormal];
    [lightBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:tipLabel];
    [self.view addSubview:myQRViewBtn];
    [self.view addSubview:lightBtn];
}

- (void)go2myQRView {
    QRViewController *myQRView = [[QRViewController alloc] init];
    [self.navigationController pushViewController:myQRView animated:YES];
}

- (void)openQRPhoto {
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.allowsEditing = YES;
    reader.readerDelegate = self;
    reader.showsHelpOnFail = NO;
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:reader animated:YES completion:nil];
}

#pragma mark -----AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects firstObject];
        
        self.urlString = metaDataObject.stringValue;
        NSLog(@"-----%@",self.urlString);
    }
    
    [self handelURLString:self.urlString];
}


//https://www.baidu.com
// 处理扫描的字符串
-(void)handelURLString:(NSString *)string
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
        if (![self.upVCTitle isEqualToString:@"便捷下单"]) {
//            [self searchBtnEvent];
        }else
        {
            [alertView show];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSArray *resuluts = [info objectForKey:ZBarReaderControllerResults];
    
    if (resuluts.count > 0) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for (ZBarSymbol *sym in resuluts) {
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

- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        NSLog(@"%@",tempStr);
        
        
        [self handelURLString:tempStr];
    }
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

#if 0
- (void)searchBtnEvent
{
    
    if (self.OrderNumber.length) {
        NSString * urlStr = @"http://202.91.248.43/project/Admin/Applineorder/saomiao";
        NSDictionary * params = @{@"num":self.OrderNumber};
        [self showTipView:@"正在查找数据信息，请稍候。。。"];
        [NetRequest postDataWithUrlString:urlStr withParams:params success:^(id data) {
            
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"1"]) {
                NSMutableArray * arr =[[NSMutableArray alloc] initWithArray:data[@"data"]];
                NSLog(@"%ld  arr:%@", arr.count, arr);
                
                NSMutableDictionary * modelDict = [[NSMutableDictionary alloc] initWithDictionary:arr[0]];
                NSMutableString * modelStr = [[NSMutableString alloc] init];
                for (NSMutableDictionary * dict in arr) {
                    NSString * str = [NSString stringWithFormat:@"%@,", dict[@"uid"]];
                    modelStr = [modelStr stringByAppendingString:[NSString stringWithFormat:@"%@", str]];
                }
                
                NSLog(@"%@", modelStr);
                [modelDict setObject:modelStr forKey:@"uid"];
                NSLog(@"%@", modelDict);
                GoodsSourceModel * model = [[GoodsSourceModel alloc] initWithDictionary:modelDict error:nil];
                OrderDetailViewController * orderDetailVC = [[OrderDetailViewController alloc] init];
                orderDetailVC.model = model;
                orderDetailVC.upVC = @"订单扫描";
                [self.navigationController pushViewController:orderDetailVC animated:YES];
                
            }else
            {
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示：无此订单信息"message:[NSString stringWithFormat:@"扫描结果:\n%@",self.OrderNumber] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
                alertView.tag = 100088;
                [self.session stopRunning];
                [alertView show];
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

#pragma 提示框
- (void)showTipView:(NSString *)tipStr {
    if (![_tipLabel superview]) {
        [_tipLabel removeFromSuperview];
        _tipLabel.text = tipStr;
        CGSize size = [_tipLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
        _tipLabel.width = size.width+30;
        _tipLabel.center = CGPointMake(screen_width/2, screen_height/2);
        [self.view addSubview:_tipLabel];
    }
    [_tipLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

#pragma mark-------开灯、关灯
-(void)openLight:(UIButton *)btn
{
    NSLog(@"!!!!!!!!!!!!!!!");
    if (ledType)
    {
        [btn setTitle:@"关灯" forState:UIControlStateNormal];
        [self turnOnLed];
    }
    else
    {
        [btn setTitle:@"开灯" forState:UIControlStateNormal];
        [self turnOffLed];
    }
    ledType = !ledType;
}
-(void)turnOnLed
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}

-(void)turnOffLed
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}
@end
