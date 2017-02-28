//
//  MySelectView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "MySelectView.h"
#import "MyPicButton.h"

@implementation MySelectView
{
    UIView *_moveView;
    MyPicButton *_lastBtn;
    //存储
    NSArray *_titleArr;
    NSArray *_imgArr;
    //按钮宽度
    float _btnWidth;
    BOOL isOnlyText;//图文或文
    BOOL noSelelctt;//是否可选择
    
    //基本配置保存
    UIColor *_nomalColor;
    UIColor *_selectColor;
    
    //列
    int _col;
}

//基本配置
- (void)initBaseCon {
    _nomalColor = [UIColor blackColor];
    _selectColor = [UIColor grayColor];
    _btnWidth = self.width/_titleArr.count;
}

//无图
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr noSelected:(BOOL)noSelelct{
    self = [super initWithFrame:frame];
    if (self) {
        noSelelctt = noSelelct;
        _titleArr = titleArr;
        isOnlyText = YES;
        [self initBaseCon];
        [self _initViewOnlyText];
    }
    return self;
}
//图文
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr withImgArr:(NSArray *)imgArr withImgWidth:(float)width noSelected:(BOOL)noSelelct{
    self = [super initWithFrame:frame];
    if (self) {
        noSelelctt = noSelelct;
        _imgArr = imgArr;
        _titleArr = titleArr;
        isOnlyText = NO;
        [self initBaseCon];
        [self _initViewWithImage:width];
    }
    return self;
}
//重设图片和文本
- (void)setImageArr:(NSArray *)imgArr withTitleArr:(NSArray *)titleArr {
    _imgArr = imgArr;
    _titleArr = titleArr;
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        [button setBtnNomalImage:[imgArr objectAtIndex:i] withNomalTitle:[titleArr objectAtIndex:i] withNomalTitleColor:_nomalColor];
        [button setContentCenter];
    }
}

#pragma mark -- 初始化
//无图模式
- (void)_initViewOnlyText {
    //创建按钮
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = [MyPicButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_btnWidth*i, 0, _btnWidth, self.height);
        [button setBtnViewWithTitle:[_titleArr objectAtIndex:i] withTitleColor:[UIColor blackColor] withFont:nil];
        [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [self addSubview:button];
        if (!noSelelctt) {
            if (i==self.firstSelect) {
                button.myBtnSelected = YES;
                _lastBtn = button;
            }
        }
    }
    float width = [_lastBtn getAllWidth]+5;
    _moveView = [[UIView alloc] initWithFrame:CGRectMake((_lastBtn.tag-100)*_btnWidth+(_btnWidth-width)/2, self.height/2+13, width, 1)];
    _moveView.backgroundColor = [UIColor blackColor];
    [self addSubview:_moveView];
}
//图文模式
- (void)_initViewWithImage:(float)width {
    //创建按钮
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = [MyPicButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_btnWidth*i, 0, _btnWidth, self.height);
        [button setBtnViewWithImage:[_imgArr objectAtIndex:i] withImageWidth:width withTitle:[_titleArr objectAtIndex:i] withTitleColor:_nomalColor withFont:nil];
        [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [self addSubview:button];
        if (!noSelelctt) {
            if (i==self.firstSelect) {
                button.myBtnSelected = YES;
                _lastBtn = button;
            }
        }
        [button setContentCenter];
    }
    _moveView = [[UIView alloc] initWithFrame:CGRectZero];
    _moveView.backgroundColor = [UIColor blackColor];
    [self addSubview:_moveView];
    //    [self changMoveViewIndex];
    float moveWidth = [_lastBtn getAllWidth]+2;
    float bottom = (self.height-16)/2+16+2;
    _moveView.frame = CGRectMake((_lastBtn.tag-100)*_btnWidth+(_lastBtn.width-moveWidth)/2, bottom, moveWidth, 0.5);
}
//设置列,重新对btn进行排布
- (void)setViewCols:(int)viewCol {
    _col = viewCol;
    if (((_titleArr.count-1)/_col+1) > 1) {
        if ([_moveView superview]) {
            [_moveView removeFromSuperview];
        }
    }
    for (int i=0; i<(int)_titleArr.count; i++) {
        int row = i/_col;
        int col = i%_col;
        _btnWidth = screen_width/_col;
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        button.frame = CGRectMake(_btnWidth*col, self.height/((_titleArr.count-1)/_col+1)*row, _btnWidth, self.height/((_titleArr.count-1)/_col+1));
    }
}

#pragma mark -- 初始化属性--有选择状态下
//设置多个属性--存文本情况下
- (void)setTextViewWithNomalColor:(UIColor *)nomalColor withSelectColor:(UIColor *)selectColor withTitlefont:(UIFont *)font{
    _nomalColor = nomalColor;
    _selectColor = selectColor;
    _moveView.backgroundColor = selectColor;
    //设置按钮状态
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        [button setTitleColor:nomalColor forState:UIControlStateNormal];
        if (button.myBtnSelected) {
            [button setTitleColor:_selectColor forState:UIControlStateNormal];
        }
        button.titleLabel.font = font;
    }
}
//设置多个属性--图文情况下
- (void)setImageViewWithNomalColor:(UIColor *)nomalColor withSelectColor:(UIColor *)selectColor withTitleFont:(UIFont *)font withselectImage:(NSArray *)selectImages{
    _moveView.backgroundColor = selectColor;
    //设置按钮状态
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        button.nomalTitleColor = nomalColor;
        [button setBtnFont:font];
        [button setBtnselectImage:[selectImages objectAtIndex:i] withselectTitleColor:selectColor];
        [button setContentCenter];
    }
}
//重置图片与文本距离
- (void)setImageDistant:(float)imageDistant withTxtDistant:(float)txtDistant {
    //设置按钮状态
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        button.imageDistant = imageDistant;
        button.txtImgDistant = txtDistant;
    }
}

#pragma mark -- 无选择状态下
- (void)setImageViewWithNomalTitleColor:(UIColor *)nomalColor withTitleFont:(UIFont *)font {
    //设置按钮状态
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        button.nomalTitleColor = nomalColor;
        [button setBtnFont:font];
        [button setContentCenter];
    }
}

//图片位置
- (void)setSelectPlacement:(NSSelectPicPlacement)selectPlacement {
    if (_selectPlacement != selectPlacement) {
        _selectPlacement = selectPlacement;
    }
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        if (selectPlacement == 0) {
            button.picPlacement = 0;
        }else if(selectPlacement == 1) {
            button.picPlacement = 1;
            [self setMoveViewHidden:YES];
        }else if(selectPlacement == 2) {
            button.picPlacement = 2;
        }
    }
}

#pragma mark -- 滑动条的设置
//设置滑动条高度
- (void)setMoveViewHeight:(float)height {
    _moveView.height = height;
}
//设置滑动条隐藏
- (void)setMoveViewHidden:(BOOL)hidden {
    _moveView.hidden = hidden;
}
//是否整个长度
- (void)setStandMoveView:(BOOL)standMoveView {
    if (_standMoveView != standMoveView) {
        _standMoveView = standMoveView;
    }
}

#pragma 分割线的设置
//设置边框属性
- (void)setViewBorderColor:(UIColor *)color borderWidth:(float)width {
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        button.layer.borderColor = color.CGColor;
        button.layer.borderWidth = width;
    }
}
//设置主流分割线
- (void)setViewSepColor:(UIColor *)color sepHeight:(float)height sepWidth:(float)width{
    for (int i=0; i<(int)_titleArr.count; i++) {
        MyPicButton *button = (MyPicButton *)[self viewWithTag:100+i];
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(button.right, (self.height-height)/2, width, height)];
        sepView.backgroundColor = color;
        [self addSubview:sepView];
    }
}

#pragma mark -- action
//moveView的移动
- (void)changMoveViewIndex {
    float width = [_lastBtn getAllWidth]+5;
    float bottom;
    if (isOnlyText) {
        bottom = _lastBtn.titleLabel.bottom+2;
    }else {
        CGRect frame = [_lastBtn.btnLabel.text boundingRectWithSize:CGSizeMake(_lastBtn.btnLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_lastBtn.btnLabel.font} context:nil];
        bottom = (self.height-frame.size.height)/2+frame.size.height+2;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        _moveView.frame = CGRectMake((_lastBtn.tag-100)*_btnWidth+_lastBtn.imageDistant-2, bottom, width, 1);
    }];
}

//按钮选择
- (void)selectBtnClick:(MyPicButton *)button {
    if (!noSelelctt) {
        if (button != _lastBtn) {
            button.myBtnSelected = YES;
            _lastBtn.myBtnSelected = NO;
            if (isOnlyText) {
                [_lastBtn setTitleColor:_nomalColor  forState:UIControlStateNormal];
                _lastBtn = button;
                [button setTitleColor:_selectColor forState:UIControlStateNormal];
            }
            _lastBtn = button;
        }
        [self changMoveViewIndex];
    }
    if ([self.mySelectDelegate respondsToSelector:@selector(mySelectedBtnSendSelectIndex:)]) {
        [self.mySelectDelegate mySelectedBtnSendSelectIndex:(int)button.tag-100];
    }
}

@end
