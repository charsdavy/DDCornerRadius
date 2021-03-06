//
//  ExampleTableViewCell.m
//  Example
//
//  Created by chars on 2018/7/16.
//  Copyright © 2018年 chars. All rights reserved.
//

#import "ExampleTableViewCell.h"
#import "DDCornerRadius.h"

#define WIDTH_AND_HEIGHT_SCALE (3.0 / 2.0)
#define CONTENT_INSET          10.0

@implementation ExampleTableViewCell

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
    self.rightImageView.image = [[UIImage imageNamed:@"demo3"] dd_imageByCornerRadius:10.0 scaleSize:CGSizeMake(imageH, imageH) borderWidth:1.0 borderColor:[UIColor redColor] corners:(UIRectCornerTopLeft | UIRectCornerBottomRight)];
}

@end
