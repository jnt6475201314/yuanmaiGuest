//
//  CollectionViewCell.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/18.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 20, CGRectGetWidth(self.frame)-60, CGRectGetWidth(self.frame)-60)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.imgView.layer.cornerRadius = 5;
        self.imgView.clipsToBounds = YES;
        [self addSubview:self.imgView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imgView.frame)+10, CGRectGetWidth(self.frame)-10, 20)];
        self.text.backgroundColor = [UIColor clearColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.text];
    }
    return self;
}

@end
