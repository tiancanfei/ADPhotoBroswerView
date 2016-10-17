//
//  DemoCell.m
//  APhotoBroswer
//
//  Created by andehang on 16/10/17.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import "DemoCell.h"
#import "ADPhotoBroswerView.h"

#define kScreenHeight     ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth      ([UIScreen mainScreen].bounds.size.width)

@interface DemoCell()

/**图片*/
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation DemoCell

#pragma mark - 自定义方法

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageViews = [NSMutableArray array];
    }
    return self;
}

- (void)setOriginalUrls:(NSArray *)originalUrls
{
    _originalUrls = originalUrls;
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageView removeFromSuperview];
    }];
    [self.imageViews removeAllObjects];
    
    CGFloat margin = 10;
    CGFloat w = (kScreenWidth - 4 * margin) / 3;
    
    [_originalUrls enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = (idx % 3) * w + (idx % 3 + 1) *margin;
        CGFloat y = (idx / 3) * w + (idx / 3 + 1) *margin;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        imageView.backgroundColor = [UIColor redColor];
        imageView.userInteractionEnabled = YES;
        imageView.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBroswe:)];
        [imageView addGestureRecognizer:tap];
        [self.imageViews addObject:imageView];
        [self.contentView addSubview:imageView];
    }];
}

- (void)tapBroswe:(UIGestureRecognizer *)gesture
{
    //从下标1开始浏览图片
    ADPhotoBroswerView *photoBroswerView = [ADPhotoBroswerView showImagesWithOriginalUrls:self.originalUrls
                                                                      thumbnailImageViews:self.imageViews browseStartIndex:gesture.view.tag];
    photoBroswerView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
}

@end
