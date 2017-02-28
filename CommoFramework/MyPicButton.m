//
//  MyPicButton.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "MyPicButton.h"

@implementation MyPicButton

{
    BOOL isOnlyText;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    //默认
    _myBtnSelected = NO;
    _picPlacement = 0;
    _imageDistant = 10;
    _txtImgDistant = 5;
    _imageWidth = 1;
    //视图初始化
    _btnView = [[UIImageView alloc] init];
    _btnLabel = [[UILabel alloc] init];
    [self addSubview:_btnView];
    [self addSubview:_btnLabel];
}

#pragma mark -- 按钮选择状态
- (void)setMyBtnSelected:(BOOL)myBtnSelected {
    if (_myBtnSelected != myBtnSelected) {
        _myBtnSelected = myBtnSelected;
        if (!isOnlyText) {
            if (!_myBtnSelected) {
                _btnView.image = [UIImage imageNamed:_nomalImage];
                _btnLabel.text = _nomalTitle;
                _btnLabel.textColor = _nomalTitleColor;
            }else {
                _btnView.image = [UIImage imageNamed:_selectedImage];
                _btnLabel.textColor = _selectedTitleColor;
                if (_selectedTitle != nil) {
                    _btnLabel.text = _selectedTitle;
                }
            }
        }
    }
}

#pragma mark -- 设置图片宽度
- (void)setImageWidth:(float)imageWidth {
    if (_imageWidth != imageWidth) {
        _imageWidth = imageWidth;
        [self refreshBtnFrame];
    }
}

#pragma mark -- 设置距离
//图片与文字距离
- (void)setTxtImgDistant:(float)txtImgDistant {
    if (_txtImgDistant != txtImgDistant) {
        _txtImgDistant = txtImgDistant;
        [self refreshBtnFrame];
    }
}
//图片与边缘距离
- (void)setImageDistant:(float)imageDistant {
    if (_imageDistant != imageDistant) {
        _imageDistant = imageDistant;
        
        [self refreshBtnFrame];
    }
}

#pragma 设置左图、右图、中图状态下的坐标排布
//左图
- (void)setLeftBtnFrame {
    if (self.height<=self.width) {
        if (self.height<_imageWidth) {
            _btnView.frame = CGRectMake(_imageDistant, 0, self.height, self.height);
        }else {
            _btnView.frame = CGRectMake(_imageDistant, (self.height-_imageWidth)/2, _imageWidth, _imageWidth);
        }
        _btnLabel.frame = CGRectMake(_btnView.right+_txtImgDistant, 0, self.width-_btnView.right-_txtImgDistant, self.height);
        _btnLabel.textAlignment = 0;
    }else {
        NSLog(@"暂未处理左图情况下高比宽大的情况");
    }
}
//右图
- (void)setRightBtnFrame {
    if (self.height<=self.width) {
        if (self.height<_imageWidth) {
            _btnView.frame = CGRectMake(self.width-self.height-_imageDistant, 0, self.height, self.height);
        }else {
            _btnView.frame = CGRectMake(self.width-_imageWidth-_imageDistant, (self.height-_imageWidth)/2, _imageWidth, _imageWidth);
        }
        _btnLabel.frame = CGRectMake(0, 0, _btnView.left-_txtImgDistant, self.height);
        _btnLabel.textAlignment = 2;
    }else {
        NSLog(@"暂未处理右图情况下高比宽大的情况");
    }
}
//中图
- (void)setCenterBtnFrame {
    if (self.height>=self.width) {
        if (self.width<_imageWidth) {
            _btnView.frame = CGRectMake(0, _imageDistant, self.width, self.width);
        }else {
            _btnView.frame = CGRectMake((self.width-_imageWidth)/2, _imageDistant, _imageWidth, _imageWidth);
        }
        _btnLabel.frame = CGRectMake(0, _btnView.bottom, self.width, self.height-_btnView.bottom);
        _btnLabel.textAlignment = 1;
    }else {
        _btnView.frame = CGRectMake((self.width-_imageWidth)/2, _imageDistant, _imageWidth, _imageWidth);
        _btnLabel.frame = CGRectMake(0, _btnView.bottom, self.width, self.height-_btnView.bottom);
        _btnLabel.textAlignment = 1;
    }
}

- (void)refreshBtnFrame {
    if (!isOnlyText) {
        if (_picPlacement == 0) {//左图
            [self setLeftBtnFrame];
        }else if (_picPlacement == 1) {//居中图
            [self setCenterBtnFrame];
        }else if (_picPlacement == 2) {//右图
            [self setRightBtnFrame];
        }
    }
}

//设置图片位置
- (void)setPicPlacement:(NSPicPlacement)picPlacement {
    //当图片位置不同时才设置坐标变化
    if (_picPlacement != picPlacement) {
        _picPlacement = picPlacement;
        [self refreshBtnFrame];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self refreshBtnFrame];
}

#pragma mark -- 初始化设置
//设置按钮内--内容(图文模式)
- (void)setBtnViewWithImage:(NSString *)imageName withImageWidth:(float)width withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withFont:(UIFont *)font {
    isOnlyText = NO;
    [self setBtnNomalImage:imageName withNomalTitle:title withNomalTitleColor:titleColor];
    //图片
    if (imageName != nil || ![imageName isEqualToString:@""]) {
        _btnView.image = [UIImage imageNamed:imageName];
    }
    self.imageWidth = width;
    //文本
    _btnLabel.text = title;
    _btnLabel.textColor = titleColor;
    if (font != nil) {
        _btnLabel.font = font;
    }
    _btnLabel.numberOfLines = 0;
    
    [self refreshBtnFrame];
}
//设置按钮内--文本(无图模式)
- (void)setBtnViewWithTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withFont:(UIFont *)font {
    isOnlyText = YES;
    if ([_btnLabel superview] || [_btnView superview]) {
        [_btnView removeFromSuperview];
        [_btnLabel removeFromSuperview];
    }
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    if (font != nil) {
        self.titleLabel.font = font;
    }
}

#pragma mark -- 无图模式
- (void)setOnlyText {
    _imageWidth = 1;
    _txtImgDistant = 0;
    _imageDistant = 0;
    
    [self refreshBtnFrame];
}


#pragma mark -- 内容居中模式
- (void)setContentCenter {
    //重新设置图片与边缘距离即可
    float allWidth = [self getAllWidth];
    _imageDistant = (self.width-allWidth)/2;
    if (_picPlacement != 1) {
        [self refreshBtnFrame];
    }
}


#pragma mark -- 获取宽度
//文本宽度--有图
- (float)getLabelTextWidth {
    CGRect frame = [_btnLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_btnLabel.font} context:nil];
    return frame.size.width;
}
//整体宽度
- (float)getAllWidth {
    if (!isOnlyText) {
        float textWidth = [self getLabelTextWidth];
        return textWidth+_txtImgDistant+_imageWidth;
    }else {
        CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
        return frame.size.width;
    }
    return 0;
}

#pragma mark -- 设置按钮选择状态与常规状态
//常规状态
- (void)setBtnNomalImage:(NSString *)imageName withNomalTitle:(NSString *)title withNomalTitleColor:(UIColor *)nomalColor {
    self.nomalImage = imageName;
    self.nomalTitle = title;
    self.nomalTitleColor = nomalColor;
}
//选择状态
- (void)setBtnselectImage:(NSString *)imageName withselectTitleColor:(UIColor *)selectColor {
    _selectedImage = imageName;
    _selectedTitleColor = selectColor;
    if (self.myBtnSelected) {
        _btnView.image = [UIImage imageNamed:_selectedImage];
        _btnLabel.textColor = _selectedTitleColor;
    }
}
//单一的状态
//图片
- (void)setNomalImage:(NSString *)nomalImage {
    if (_nomalImage != nomalImage) {
        _nomalImage = nomalImage;
    }
    if (!isOnlyText) {
        if (nomalImage != nil || ![nomalImage isEqualToString:@""]) {
            _btnView.image = [UIImage imageNamed:nomalImage];
        }
    }
}
//标题
- (void)setNomalTitle:(NSString *)nomalTitle {
    if (_nomalTitle != nomalTitle) {
        _nomalTitle = nomalTitle;
    }
    if (!isOnlyText) {
        _btnLabel.text = _nomalTitle;
    }
}
//颜色
- (void)setNomalTitleColor:(UIColor *)nomalTitleColor {
    if (_nomalTitleColor != nomalTitleColor) {
        _nomalTitleColor = nomalTitleColor;
    }
    if (!isOnlyText) {
        _btnLabel.textColor = _nomalTitleColor;
    }
}
//设置字体
- (void)setBtnFont:(UIFont *)font {
    _btnLabel.font = font;
}
//标题
- (void)setSelectedTitle:(NSString *)selectedTitle {
    if (_selectedTitle != selectedTitle) {
        _selectedTitle = selectedTitle;
    }
}


@end
