//
//  starView.m
//  Working
//
//  Created by 姜宁桃 on 16/7/27.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "starView.h"

@implementation starView

- (instancetype)initWithFrame:(CGRect)frame starNum:(NSInteger)num
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configStarViewWithStarNum:num];
    }
    return self;
}

- (void)configStarViewWithStarNum:(NSInteger)starNum
{
    NSMutableArray * _starArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        if (i < starNum) {
            [_starArray addObject:@"star_selected_fill"];
        }else
        {
            [_starArray addObject:@"star_unselected"];
        }
    }
    for (int i = 0; i < 5; i++) {
        UIImageView * starImgView = [UIImageView imageViewWithFrame:CGRectMake(2 + i * 22, 2, 20, 20) image:_starArray[i]];
        [self addSubview:starImgView];
    }

}


@end
