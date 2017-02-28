//
//  ImageCollectionViewCell.m
//  Working
//
//  Created by 姜宁桃 on 2016/10/10.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.imgView.layer.cornerRadius = 5;
        self.imgView.clipsToBounds = YES;
        self.imgView.userInteractionEnabled = YES;
        [self addSubview:self.imgView];
        
        [self addDeleteButton];
        [self addLongPressGesture];
    }
    return self;
}

- (void)addLongPressGesture{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    [self addGestureRecognizer:lpgr];
}

- (void)longClick:(UILongPressGestureRecognizer *)lpgr
{
    
    [self.delegate showAllDeleteBtn];
    
}

- (void)btnClick
{
    
    [self.delegate deleteCellAtIndexpath:_indexPath cellView:self];
}

- (void)addDeleteButton{
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(0, 0, 20, 20);
    [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    _deleteBtn.hidden = YES;
    [_deleteBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:_deleteBtn];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
