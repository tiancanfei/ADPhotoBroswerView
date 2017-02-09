//
//  ADPhotoBroswerView.h
//  APhotoBroswer
//
//  Created by andehang on 16/10/10.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADPhotoBroswerView : UIView

/**展位图片*/
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 originalUrls：原图地址
 thumbnailImageViews：展示缩略图UIImageView控件
 browseStartIndex：浏览开始脚标(从哪一个缩略图展示的图片开始浏览)
 */
+ (instancetype)showImagesWithOriginalUrls:(NSArray *)originalUrls
                       thumbnailImageViews:(NSArray<UIImageView *> *)thumbnailImageViews
                          browseStartIndex:(NSInteger)browseStartIndex;
@end
