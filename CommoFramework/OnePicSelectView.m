//
//  OnePicSelectView.m
//  BIZCarSpider
//
//  Created by fwios001 on 16/2/19.
//  Copyright © 2016年 feiwei. All rights reserved.
//

#import "OnePicSelectView.h"
#import "BrowsePicView.h"
#import "BrowerView.h"

@interface OnePicSelectView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,strong)BrowerView *browerView;

@end

@implementation OnePicSelectView

{
    UIAlertController *alertController;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.image = [UIImage imageNamed:@"publish_img"];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectClick:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setDefaultImg:(NSString *)defaultImg {
    self.image = [UIImage imageNamed:defaultImg];
}

- (void)selectClick:(UIButton *)button {
    if (!_enEdit) {
        //代理,实现图片浏览
        BrowsePicView *browsePicView = [[BrowsePicView alloc]initWithFrame:CGRectMake(0,0,screen_width,screen_height)];
        browsePicView.imageArray = @[_imgUrl];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        
        [browsePicView.layer.superlayer addAnimation:transition forKey:nil];
        [browsePicView.layer addAnimation:transition forKey:nil];
        [self.viewController.view addSubview:browsePicView];
    }else {
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction: [UIAlertAction actionWithTitle:@"查看" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //代理,实现图片浏览
            BrowsePicView *browsePicView = [[BrowsePicView alloc]initWithFrame:CGRectMake(0,0,screen_width,screen_height)];
            browsePicView.imageArray = @[_imgUrl];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            
            [browsePicView.layer.superlayer addAnimation:transition forKey:nil];
            [browsePicView.layer addAnimation:transition forKey:nil];
            [self.viewController.view addSubview:browsePicView];

        }]];
        
        [alertController addAction: [UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //处理点击拍照
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if (!isCamera) {
                UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"此设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertCon addAction:cancelAction];
                [self.viewController presentViewController:alertCon animated:YES completion:nil];
            }else {
                [self setImagePickerControllerSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //处理点击从相册选取
            [self setImagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)setImagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = sourceType;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self.viewController presentViewController:_imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.image = image;
    _isSelectPic = YES;
    if ([self.selectDelegate respondsToSelector:@selector(didSelectImageView)]) {
        [self.selectDelegate didSelectImageView];
    }
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
