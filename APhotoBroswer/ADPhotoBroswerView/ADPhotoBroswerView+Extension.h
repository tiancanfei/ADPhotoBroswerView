//
//  ADPhotoBroswerView+Extension.h
//  SmartCampusSever
//
//  Created by andehang on 2016/10/25.
//  Copyright © 2016年 jinlinbao. All rights reserved.
//

#import "ADPhotoBroswerView.h"

@interface ADPhotoBroswerView (Extension)

/**工厂方法
 urls：网络图片地址
 imageViews：图片容器ImageView
 browseStartIndex：开始浏览的角标
 */
+ (instancetype)showImagesWithUrls:(NSArray *)urls
                       imageViews:(NSArray<UIImageView *> *)imageViews
                          browseStartIndex:(NSInteger)browseStartIndex;
/**获取缩略图地址*/
+ (NSString *)thumbnailUrlWithOriginalUrl:(NSString *)originalUrl;

@end
