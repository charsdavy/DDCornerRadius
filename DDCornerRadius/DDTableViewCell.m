//
//  DDTableViewCell.m
//  DDCornerRadius
//
//  Created by dengw on 2017/6/27.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "DDTableViewCell.h"
#import "DDCornerRadius.h"

#define WIDTH_AND_HEIGHT_SCALE (3.0 / 2.0)
#define CONTENT_INSET          10.0

@interface DDTableViewCell ()

@end

@implementation DDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftImageView];
        [self addSubview:self.centerImageView];
        [self addSubview:self.rightImageView];
    }
    return self;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"demo1"];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.image = [UIImage imageNamed:@"demo2"];
        _centerImageView.layer.cornerRadius = 10.0;
        _centerImageView.clipsToBounds = YES;
        _centerImageView.backgroundColor = [UIColor blackColor];
    }
    return _centerImageView;
}


- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [[UIImage imageNamed:@"demo3"] dd_imageByCornerRadius:40.0 corners:(UIRectCornerTopLeft | UIRectCornerBottomRight) borderWidth:5.0 borderColor:[UIColor redColor]];
    }
    return _rightImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    CGFloat imageH = size.height - CONTENT_INSET * 2;
    CGFloat imageW = imageH * WIDTH_AND_HEIGHT_SCALE;
    self.leftImageView.frame = CGRectMake(CONTENT_INSET, CONTENT_INSET, imageW, imageH);
    CGFloat centerImageX = (size.width - imageW * 3 - CONTENT_INSET * 2) / 2.0 + CONTENT_INSET + imageW;
    self.centerImageView.frame = CGRectMake(centerImageX, CONTENT_INSET, imageW, imageH);
    self.rightImageView.frame = CGRectMake(size.width - CONTENT_INSET - imageW, CONTENT_INSET, imageW, imageH);
}

@end
