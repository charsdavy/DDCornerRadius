//
//  UIImage+DDCornerRadius.m
//  DDCornerRadius
//
//  Created by dengw on 2017/6/27.
//  Copyright © 2017年 Chars. All rights reserved.
//

#import "UIImage+DDCornerRadius.h"

@implementation UIImage (DDCornerRadius)

- (UIImage *)dd_imageByRoundScaleSize:(CGSize)scaleSize
{
    if (scaleSize.width > 0 && scaleSize.height > 0) {
        CGFloat minSize = MIN(scaleSize.width, scaleSize.height);
        CGFloat radius = minSize / 2.0;
        return [self dd_imageByCornerRadius:radius scaleSize:scaleSize borderWidth:0 borderColor:nil corners:UIRectCornerAllCorners];
    }
    return self;
}

- (UIImage *)dd_imageByCornerRadius:(CGFloat)radius
                          scaleSize:(CGSize)scaleSize
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor
                            corners:(UIRectCorner)corners
{
    if (radius > 0 && scaleSize.width > 0 && scaleSize.height > 0) {
        UIImage *scaledImage = [self dd_imageByScalingAndCroppingToSize:scaleSize];
        if (scaledImage) {
            return [scaledImage dd_imageByCornerRadius:radius
                                               corners:corners
                                           borderWidth:borderWidth
                                           borderColor:borderColor];
        }
    }
    return self;
}

- (UIImage *)dd_imageByCornerRadius:(CGFloat)radius
                            corners:(UIRectCorner)corners
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor
{
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);

    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2.0) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image dd_imageByCornerRadius:radius borderedColor:borderColor borderWidth:borderWidth corners:corners];
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)dd_imageByRoundBorderedColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
{
    if (self.size.height != self.size.width) {
        return self;
    }

    return [self dd_imageByCornerRadius:self.size.width / 2.0 borderedColor:borderColor borderWidth:borderWidth corners:UIRectCornerAllCorners];
}

- (UIImage *)dd_imageByCornerRadius:(CGFloat)radius
                      borderedColor:(UIColor *)borderColor
                        borderWidth:(CGFloat)borderWidth
                            corners:(UIRectCorner)corners
{
    if (!borderColor || borderWidth > MIN(self.size.width, self.size.height) / 2.0 || borderWidth < 0) {
        return self;
    }
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }

    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [self drawAtPoint:CGPointZero];
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGFloat strokeInset = borderWidth / 2.0;
    CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
    path.lineWidth = borderWidth;
    [borderColor setStroke];
    [path stroke];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)dd_roundImageWithColor:(UIColor *)color
                               size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *roundedColorImage = [colorImage dd_imageByRoundScaleSize:size];
    return roundedColorImage;
}

/**
 先找出image宽和高中缩放程度较小者，作为整个图片的缩放比例。
 再将图片放入drawInRect函数的rect的中央。
 最后将超过的宽或高裁剪，得到缩放后的图片。

 在使用时应该检查返回值是否为nil
 */
- (UIImage *)dd_imageByScalingAndCroppingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;

    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;

    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor) scaleFactor = widthFactor;  // scale to fit height
        else scaleFactor = heightFactor;                            // scale to fit width

        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0); // this will crop
    CGRect thumbnailRect = CGRectZero;

    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
