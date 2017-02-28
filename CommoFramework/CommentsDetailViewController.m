//
//  CommentsDetailViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/11/9.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "CommentsDetailViewController.h"
#import "StarRatingView.h"
#import "UIPlaceHolderTextView.h"

@interface CommentsDetailViewController ()<StarRatingViewDelegate, UITextViewDelegate>
{
    UIView * _detailView;  // 青色背景
    UIImageView * _whiteBgImgView; // 白色图片
    
    UIImageView * _driverHeadImgView;
    UIImageView * _identityImgView; // 认证图片
    
    StarRatingView * _starView;  // 评分视图
    
    UIPlaceHolderTextView * _commentTextView;  // 评论视图
    
    UIButton * _commentButton;  // 提交评价按钮
    
    CGFloat _comments;
}

@end

@implementation CommentsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    
    [self showBackBtn];
    self.titleLabel.text = @"评价详情";
    // 详情背景view
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, screen_height - 63)];
    _detailView.backgroundColor = color(23, 199, 189, 1);
    [self.view addSubview:_detailView];
    
    [self configDetailView];
}

- (void)configDetailView{
    _whiteBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, screen_width - 40, 460*heightScale)];
    _whiteBgImgView.image = [UIImage imageNamed:@"comment_white_bgImg"];
    _whiteBgImgView.userInteractionEnabled = YES;
    [_detailView addSubview:_whiteBgImgView];
    
    // 司机头像
    _driverHeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20*widthScale, 20*widthScale, 70*widthScale, 70*widthScale)];
    NSString * _HeadImgUrlStr = [NSString stringWithFormat:@"http://202.91.248.43/project/Public/Uploads/driver_id/%@", self.commentModel.photo];
    NSURL * _headImgUrl = [NSURL URLWithString:_HeadImgUrlStr];
    [_driverHeadImgView sd_setImageWithURL:_headImgUrl placeholderImage:[UIImage imageNamed:@"Detail_person_default"]];
    [_whiteBgImgView addSubview:_driverHeadImgView];
    
    // 认证图片
    _identityImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21*widthScale, 22*widthScale)];
    _identityImgView.image = [UIImage imageNamed:@"cell_ identificationed"];
    [_driverHeadImgView addSubview:_identityImgView];
    
    
    UILabel * nameLab = [UILabel labelWithFrame:CGRectMake(_driverHeadImgView.right + 5*widthScale, 20*heightScale, 60*widthScale, 20*heightScale) text:self.commentModel.name font:15 textColor:[UIColor darkTextColor]];
    [_whiteBgImgView addSubview:nameLab];
    
    // 信用星级数
    for (int i = 0; i < 5; i++) {
        UIImageView * starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_driverHeadImgView.right + 5*widthScale +i*(22*widthScale), nameLab.bottom+3*heightScale, 20*widthScale, 20*widthScale)];
        if (i == 0) {
            starImgView.image = [UIImage imageNamed:@"detail_star_fill"];
        }else
            starImgView.image = [UIImage imageNamed:@"detail_star_empty"];
        [_whiteBgImgView addSubview:starImgView];
    }
    
    UIImageView * phoneImgView = [UIImageView imageViewWithFrame:CGRectMake(_driverHeadImgView.right + 5*widthScale, nameLab.bottom + 26*heightScale, 19*widthScale, 19*widthScale) image:@"detail_phone"];
    [_whiteBgImgView addSubview:phoneImgView];
    
    UILabel * telLab = [UILabel labelWithFrame:CGRectMake(phoneImgView.right + 5*widthScale, nameLab.bottom + 26*heightScale, 100 * widthScale, 20*heightScale) text:self.commentModel.tel font:15 textColor:[UIColor darkTextColor]];
    [_whiteBgImgView addSubview:telLab];
    
    //    出发地地址图标
    UIImageView * startImgView = [UIImageView imageViewWithFrame:CGRectMake(5*widthScale,_driverHeadImgView.bottom + 10*heightScale, 17*widthScale, 21*widthScale) image:@"pub_detail_startImg"];
    [_whiteBgImgView addSubview:startImgView];
    
    //    出发地地址
    UILabel * startingLabel = [UILabel labelWithFrame:CGRectMake(startImgView.right,_driverHeadImgView.bottom + 11*heightScale, screen_width/2 - 55*widthScale, 20*heightScale) text:self.commentModel.address_f font:15 textColor:[UIColor darkTextColor]];
    startingLabel.textAlignment = NSTextAlignmentCenter;
    startingLabel.adjustsFontSizeToFitWidth = YES;
    [_whiteBgImgView addSubview:startingLabel];
    
    //    至图标
    UIImageView * toImgView = [UIImageView imageViewWithFrame:CGRectMake(_whiteBgImgView.width/2 - 10*widthScale,_driverHeadImgView.bottom +  16*heightScale, 19*widthScale, 6*heightScale) image:@"pub_detail_toImg"];
    [_whiteBgImgView addSubview:toImgView];
    
    //    目的地地址图标
    UIImageView * destinationImgView = [UIImageView imageViewWithFrame:CGRectMake(toImgView.right + 10*widthScale,_driverHeadImgView.bottom + 10*heightScale, 17*widthScale, 21*widthScale) image:@"pub_detail_destionation"];
    [_whiteBgImgView addSubview:destinationImgView];
    
    //    目的地地址
    UILabel * destinationLabel = [UILabel labelWithFrame:CGRectMake(destinationImgView.right,_driverHeadImgView.bottom + 11*heightScale, screen_width/2 - 55*widthScale, 20*heightScale) text:self.commentModel.address_s font:15 textColor:[UIColor darkTextColor]];
    destinationLabel.textAlignment = NSTextAlignmentCenter;
    destinationLabel.adjustsFontSizeToFitWidth = YES;
    [_whiteBgImgView addSubview:destinationLabel];
    
    NSArray * getterTitleArray = @[@"目前状态", @"订单编号", @"发布日期", @"到达时间"];
    NSArray * getterTextArray = @[self.commentModel.order_state, self.commentModel.order_number, self.commentModel.delivery_time, self.commentModel.comment];
    for (int i = 0; i < getterTitleArray.count; i++) {
        UITextField * getterInfoTF = [MYFactoryManager createTextField:CGRectMake(20*widthScale,destinationLabel.bottom + 10*heightScale+i*25, _whiteBgImgView.width - 40*widthScale, 20*heightScale) withPlaceholder:nil withLeftViewTitle:getterTitleArray[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:80*widthScale withDelegate:self];
        getterInfoTF.enabled = NO;
        getterInfoTF.text = getterTextArray[i];
        [_whiteBgImgView addSubview:getterInfoTF];
    }
    
    _starView = [[StarRatingView alloc] initWithFrame:CGRectMake(20, destinationLabel.bottom + 110*heightScale, _whiteBgImgView.width - 40, 40) andLoadStarRatingNum:5 andStarRatingW:36*widthScale andStarBackgroundColor:[UIColor grayColor] andLightStarColor:[UIColor orangeColor]];
    _starView.delegate = self;
    [_whiteBgImgView addSubview:_starView];
    
    UILabel * commentLab = [UILabel labelWithFrame:CGRectMake(20, _starView.bottom+5*widthScale, _whiteBgImgView.width - 40, 20) text:@"您的评价，让我们服务得更好！" font:15 textColor:[UIColor orangeColor]];
    commentLab.textAlignment = NSTextAlignmentCenter;
    [_whiteBgImgView addSubview:commentLab];
    
    _commentTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, commentLab.bottom+5*widthScale, _whiteBgImgView.width - 40, 80*heightScale)];
    _commentTextView.delegate = self;
    _commentTextView.font = systemFont(15);
    _commentTextView.textColor = [UIColor blackColor];
    _commentTextView.keyboardType = UITextBorderStyleLine;
    _commentTextView.layer.borderWidth = 1.0;
    _commentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    if (self.commentModel.state && [self.commentModel.state isEqualToString:@"1"]) {
        // 已评价
        _commentButton = [UIButton buttonWithFrame:CGRectMake(20*widthScale, _commentTextView.bottom+10*widthScale, _whiteBgImgView.width - 40*widthScale, 40*widthScale) title:@"已评价" image:nil target:self action:@selector(commentButtonEvent)];
        _commentButton.enabled = NO;
        [_commentButton setBackgroundColor:[UIColor lightGrayColor]];
        [_commentButton setTitle:@"已评价" forState:UIControlStateNormal];
        _commentTextView.text = self.commentModel.content;
        _commentTextView.editable = NO;
        _starView.userInteractionEnabled = NO;
        [_starView lightWholeStar:CGPointMake(48*[self.commentModel.stars integerValue], 10)];
    }else
    {
        _commentButton = [UIButton buttonWithFrame:CGRectMake(20*widthScale, _commentTextView.bottom+10*widthScale, _whiteBgImgView.width - 40*widthScale, 40*widthScale) title:@"提交评价" image:nil target:self action:@selector(commentButtonEvent)];
        _commentButton.backgroundColor = [UIColor blackColor];
        [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commentTextView.placeholder = @"输入您的宝贵意见";
    }
    
    [_whiteBgImgView addSubview:_commentTextView];
    [_whiteBgImgView addSubview:_commentButton];
}

#pragma mark - StarRatingViewDelegate -
- (void)starBtnAction:(CGFloat)index
{
    NSLog(@"%f", index);
    _comments = index;
}

#pragma mark - Event Hander 
- (void)commentButtonEvent{
    NSLog(@"提交评价");
    CGPoint point =  CGPointMake(_commentButton.centerX, _commentButton.centerY);
    _commentButton.center = CGPointMake(_commentButton.centerX - 15, _commentButton.centerY);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _commentButton.center = point;
        
    } completion:^(BOOL finished) {
        
        [self commentNetWorkEvent];
    }];
}

- (void)commentNetWorkEvent{
    if (_comments) {
        NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/Apporder/comments";
        NSString * comments = [NSString stringWithFormat:@"%f", _comments];
        NSDictionary * params = @{@"uid":GETUID, @"sid":_commentModel.driver_id, @"state":comments,@"distinguish":@"1", @"order_id":_commentModel.oid, @"content":_commentTextView.text};
        NSLog(@"%@?uid=%@&sid=%@&state=4&distinguish=1&content=%@", urlStr, GETUID, _commentModel.driver_id, _commentTextView.text);
        [NetRequest postDataWithUrlString:urlStr withParams:params success:^(id data) {
            
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"1"]) {
                [self showTipView:data[@"message"]];
                _commentButton.enabled = NO;
                [_commentButton setBackgroundColor:[UIColor lightGrayColor]];
                [_commentButton setTitle:@"已评价" forState:UIControlStateNormal];
                _starView.userInteractionEnabled = NO;
                _commentTextView.editable = NO;
            }else if([data[@"code"] isEqualToString:@"2"]){
                [self showTipView:data[@"message"]];
            }
        } fail:^(id errorDes) {
            
            NSLog(@"%@", errorDes);
        }];
    }else
    {
        [self showTipView:@"请先评价完再进行提交操作"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
