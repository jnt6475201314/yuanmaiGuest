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
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 57*widthScale)/2, (CGRectGetWidth(self.frame) - 57*widthScale)/2, 57*widthScale, 57*widthScale)];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.imgView.layer.cornerRadius = self.imgView.width/2;
        self.imgView.clipsToBounds = YES;
        [self addSubview:self.imgView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame), 30)];
        self.text.backgroundColor = [UIColor clearColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.text];
        
    }
    return self;
}

@end
