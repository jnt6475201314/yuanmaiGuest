//
//  SuggestionViewController.m
//  Working
//
//  Created by 姜宁桃 on 16/9/30.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "SuggestionViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ImageCollectionViewCell.h"
#import "UIViewController+XHPhoto.h"
#import "MyAnimation.h"

@interface SuggestionViewController ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CellDelegate>{
    UIPlaceHolderTextView * suggestTV;
    UIButton * sendSuggestButton;
    
    BOOL deleteBtnFlag;
    BOOL rotateAniFlag;
}
@property (nonatomic, strong) UICollectionView * imageCollectionView;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableDictionary * params;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showBackBtn];
    self.titleLabel.text = @"意见建议";
    
    deleteBtnFlag = YES;
    rotateAniFlag = YES;
    [self addDoubleTapGesture];
    [self configUI];
}

- (void)configUI{
    
    UILabel * titleLab = [UILabel labelWithFrame:CGRectMake(20, 100, 120, 40) text:@"建议内容：" font:16 textColor:[UIColor blueColor]];
    [self.view addSubview:titleLab];
    
    suggestTV = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, titleLab.bottom, screen_width - 40, screen_height/4)];
    suggestTV.delegate = self;
    suggestTV.font = systemFont(15);
    suggestTV.textColor = [UIColor blackColor];
    suggestTV.keyboardType = UITextBorderStyleRoundedRect;
    suggestTV.placeholder = @"你的建议内容请写在这里。。。";
    suggestTV.layer.borderWidth = 1.0;
    suggestTV.layer.borderColor = [UIColor grayColor].CGColor;
    suggestTV.layer.cornerRadius = 10;
    suggestTV.clipsToBounds = YES;
    [self.view addSubview:suggestTV];
    
    UILabel * addImgTitleLab = [UILabel labelWithFrame:CGRectMake(20, suggestTV.bottom + 10, screen_width - 40, 40) text:@"点击加号可添加图片:(图片数量少于3张哦)" font:16 textColor:[UIColor orangeColor]];
    addImgTitleLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:addImgTitleLab];
    
    [self.view addSubview:self.imageCollectionView];
    
    sendSuggestButton = [UIButton buttonWithFrame:CGRectMake(20, screen_height - 45, screen_width - 40, 40) title:@"提交建议" image:nil target:self action:@selector(sendSuggestButtonEvent)];
    sendSuggestButton.layer.cornerRadius = 5;
    sendSuggestButton.clipsToBounds = YES;
    [sendSuggestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendSuggestButton.backgroundColor = navBar_color;
    [self.view addSubview:sendSuggestButton];
    
    // 提示信息
    UILabel * promptLab = [UILabel labelWithFrame:CGRectMake(20, self.imageCollectionView.bottom, screen_width, 20) text:@"长按可删除图片，双击空白处可退出编辑" font:14 textColor:[UIColor grayColor]];
//    promptLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLab];
}

#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"imageCollectionView";
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.imgView.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
//        cell.userInteractionEnabled = NO;
        cell.deleteBtn.hidden = YES;
    }else{
        cell.indexPath = indexPath;
        cell.deleteBtn.hidden = deleteBtnFlag?YES:NO;
        cell.delegate = self;
        if (!rotateAniFlag) {
            [MyAnimation vibrateAnimation:cell];
        }else{
            [cell.layer removeAnimationForKey:@"shake"];
        }
        cell.imgView.image = self.imageArray[indexPath.item];
    }
    return cell;
}

// 点击每个cell触发的事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        // 点击了添加相片按钮
        NSLog(@"点击了添加相片按钮");
        [self.view endEditing:YES];
        if (self.imageArray.count < 4) {
            [self hideAllDeleteBtn];
            [self showCanEdit:YES photo:^(UIImage *photo) {
                [self.imageArray addObject:photo];
                [self.imageCollectionView reloadData];
            }];
        }else{
            [self showTipView:@"图片数量不能超过3张哦😯"];
        }
        
    }
}

#pragma mark - CellDelegate
-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath cellView:(ImageCollectionViewCell *)cell{
    if (self.imageArray.count < 1) {
        [self hideAllDeleteBtn];
        return;
    }
    
    [self.imageCollectionView performBatchUpdates:^{
        cell.imgView.image = nil;
        cell.deleteBtn.hidden = YES;
        
        [MyAnimation fadeAnimation:cell];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ULL * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            // 延时1s执行， 下面这两行执行删除cell的操作，包括移除数据源和删除item， 如果你用到数据库或者coreData
            // 要先删掉数据库里的内容，再执行移除数据源和删除item
            [self.imageArray removeObjectAtIndex:indexPath.row];
            [self.imageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        });
    } completion:^(BOOL finished) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ULL * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            [self.imageCollectionView reloadData];
        });
    }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *) gestureRecognizer
{
    [self hideAllDeleteBtn];
}

-(void)addDoubleTapGesture{
    UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubletap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubletap];
}

-(void)hideAllDeleteBtn{
    if (!deleteBtnFlag) {
        deleteBtnFlag = YES;
        rotateAniFlag = YES;
        [self.imageCollectionView reloadData];
    }
}

-(void)showAllDeleteBtn{
    deleteBtnFlag = NO;
    rotateAniFlag = NO;
    [self.imageCollectionView reloadData];
}


#pragma mark - Event Hander
- (void)sendSuggestButtonEvent{
    [self.view endEditing:YES];
    NSLog(@"提交建议");
    if (suggestTV.text.length > 0) {
        _params = [[NSMutableDictionary alloc] init];
        NSDictionary * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        NSString * line_id = data[@"line_id"];  // 专线名称
        [_params setValue:line_id forKey:@"line_id"];
        [_params setValue:suggestTV.text forKey:@"content"];
        NSLog(@"%@ --  %@", _params[@"line_id"], _params[@"content"]);
        NSInteger count = self.imageArray.count;
        switch (count) {
            case 1:
                // 没有添加图片
                break;
            case 2:
                // 1张
            {
                UIImage * image = self.imageArray[1];
                NSData * imgData = UIImageJPEGRepresentation(image, 1.0f);
                NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [_params setObject:image64 forKey:@"photo_a"];
            }
                break;
            case 3:
                // 2。。
            {
                for (int i = 1; i<3; i++) {
                    UIImage * image = self.imageArray[i];
                    NSData * imgData = UIImageJPEGRepresentation(image, 1.0f);
                    NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    if (i == 1) {
                        [_params setObject:image64 forKey:@"photo_a"];
                    }else if (i == 2){
                        [_params setObject:image64 forKey:@"photo_b"];
                    }
                }
            }
                break;
            case 4:
                // 3。。
            {
                for (int i = 1; i<4; i++) {
                    UIImage * image = self.imageArray[i];
                    NSData * imgData = UIImageJPEGRepresentation(image, 0.3f);
                    NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    if (i == 1) {
                        [_params setObject:image64 forKey:@"photo_a"];
                    }else if (i == 2){
                        [_params setObject:image64 forKey:@"photo_b"];
                    }else if(i == 3){
                        [_params setObject:image64 forKey:@"photo_c"];
                    }
                }
            }
                break;
                
            default:
                break;
        }
        [self NetWorkOfSendSuggest]; // 进行
    }else{
        [self showTipView:@"建议内容不能为空"];
    }
}

- (void)NetWorkOfSendSuggest{
    [self showHUD:@"正在上传，请稍候" isDim:YES];
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Appline/feedback";
    NSLog(@"%@?%@", urlStr, _params);
    [NetRequest postDataWithUrlString:urlStr withParams:_params success:^(id data) {
        [self hideHUD];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:data[@"message"]];
        }else if ([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:data[@"message"]];
        }
    } fail:^(NSString *errorDes) {
        NSLog(@"%@", errorDes);
        [self hideHUD];
    }];
}

#pragma mark - Getter
-(UICollectionView *)imageCollectionView{
    if (_imageCollectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //        flowLayout.headerReferenceSize = CGSizeMake(screen_width, screen_height/4);
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, suggestTV.bottom + 50, screen_width - 40, 70) collectionViewLayout:flowLayout];
        
        // 定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(60, 60);
        // 定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 10;
        // 定义每个UICollectionView 的纵向间距
        flowLayout.minimumInteritemSpacing = 0;
        // 定义每个UICollectionView 的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8); // 上左下右
        
        //注册cell和ReusableView（相当于头部）
        [_imageCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCollectionView"];
        
        //设置代理
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        
        //背景颜色
        _imageCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _imageCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageCollectionView;
}

-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] initWithObjects:@"add_images", nil];
    }
    return _imageArray;
}

//左边
- (void)backClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
