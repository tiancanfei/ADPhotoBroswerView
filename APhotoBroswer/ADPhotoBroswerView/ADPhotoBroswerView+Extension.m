//
//  ADPhotoBroswerView+Extension.m
//  SmartCampusSever
//
//  Created by andehang on 2016/10/25.
//  Copyright © 2016年 jinlinbao. All rights reserved.
//

#import "ADPhotoBroswerView+Extension.h"

@implementation ADPhotoBroswerView (Extension)

+ (NSString *)thumbnailUrlWithOriginalUrl:(NSString *)originalUrl
{
    NSString *url = originalUrl;
    NSString *extension = [url pathExtension];
    url = [NSString stringWithFormat:@"%@_200x200.%@",url,extension];
    return url;
}

+ (instancetype)showImagesWithUrls:(NSArray *)urls
                        imageViews:(NSArray<UIImageView *> *)imageViews
                  browseStartIndex:(NSInteger)browseStartIndex
{
    ADPhotoBroswerView *v = [ADPhotoBroswerView showImagesWithOriginalUrls:urls thumbnailImageViews:imageViews browseStartIndex:browseStartIndex];
    return v;
}

@end
