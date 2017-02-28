//
//  BrowsePicView.m
//  CarSpider
//
//  Created by feiwei on 16/1/30.
//  Copyright © 2016年 fwios001. All rights reserved.
//

#import "BrowsePicView.h"
#import "BLImageSize.h"

@interface BrowsePicView()<UIScrollViewDelegate>

@property(strong,nonatomic) UIScrollView *guenBrowseScrollView;
@property(nonatomic,strong) UILabel *indexLabel;

@end


@implementation BrowsePicView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI{
    _guenBrowseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    _guenBrowseScrollView.pagingEnabled = YES;
    _guenBrowseScrollView.backgroundColor = [UIColor blackColor];
    _guenBrowseScrollView.delegate = self;
    [self addSubview:_guenBrowseScrollView];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    
    _indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, screen_height-50, screen_width, 30)];
    _indexLabel.textAlignment = 1;
    _indexLabel.font = [UIFont systemFontOfSize:18];
    _indexLabel.textColor = [UIColor whiteColor];
    [self addSubview:_indexLabel];
}

- (void)setImageArray:(NSArray *)imageArray{
    if (_imageArray != imageArray) {
        _imageArray = imageArray;
    }
    for (int i = 0; i < _imageArray.count; i++) {
        CGSize picSize;
        if ([_imageArray[i] isKindOfClass:[UIImage class]]) {
            UIImage *image = _imageArray[i];
            picSize = image.size;
        }else{
            picSize = [BLImageSize dowmLoadImageSizeWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_imageArray[i]]]];
        }
        NSLog(@"picSize is %f",picSize.height);
        //图片的长宽比
        if (picSize.width != 0) {
            float dPicAspectRatio = picSize.width/picSize.height;
            float picH = screen_width/dPicAspectRatio;
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width*i, (screen_height-50-picH)/2, screen_width, picH)];
            
            //        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width*i, 170, screen_width, screen_height-370)];
            [_guenBrowseScrollView addSubview:imageView];
            if ([_imageArray[i] isKindOfClass:[UIImage class]]) {
                imageView.image = _imageArray[i];
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_imageArray[i]]]];
            }
        }else {
            NSLog(@"图片格式错误");
        }
    }
    _guenBrowseScrollView.contentSize = CGSizeMake(screen_width*_imageArray.count, [[UIScreen mainScreen] bounds].size.height);
    
    _indexLabel.text = [NSString stringWithFormat:@"1/%ld",_imageArray.count];
}

- (void)setPicIndex:(NSInteger)picIndex{
    if (_picIndex != picIndex) {
        _picIndex = picIndex;
    }
    
    _guenBrowseScrollView.contentOffset = CGPointMake(screen_width*_picIndex, 0);
    
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",_picIndex+1,_imageArray.count];
}


- (void)tapView:(UITapGestureRecognizer *)tap{
    //    [UIView animateWithDuration:0.5 animations:^{
    //        [self removeFromSuperview];
    //    }];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
    [self.layer.superlayer addAnimation:transition forKey:nil];
    [self.layer addAnimation:transition forKey:nil];
    [self removeFromSuperview];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int offX = scrollView.contentOffset.x/screen_width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld",offX+1,_imageArray.count];
}

@end
