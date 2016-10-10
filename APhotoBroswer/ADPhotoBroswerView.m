//
//  ADPhotoBroswerView.m
//  APhotoBroswer
//
//  Created by andehang on 16/10/10.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import "ADPhotoBroswerView.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#define kScreenHeight     ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth      ([UIScreen mainScreen].bounds.size.width)
#define kMaxScale 2

@interface ADPhotoBroswerViewCell : UICollectionViewCell

/**图片*/
@property (weak, nonatomic) UIImageView *imageView;

/**原始图片*/
@property (nonatomic, copy) NSString *originalUrl;

/**缩略图片*/
@property (nonatomic, copy) NSString *thumbnailUrl;

@end

@implementation ADPhotoBroswerViewCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setUpCell];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setThumbnailUrl:(NSString *)thumbnailUrl
{
    _thumbnailUrl = thumbnailUrl;
    self.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_thumbnailUrl];
}

- (void)setOriginalUrl:(NSString *)originalUrl
{
    _originalUrl = originalUrl;
    
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_originalUrl];
    
    if (!cacheImage)
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_originalUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize == 0)
            {
                [SVProgressHUD show];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error)
            {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }
            else
            {
                [SVProgressHUD dismiss];
                [UIView animateWithDuration:0.25 animations:^{
                    self.imageView.frame = [UIApplication sharedApplication].keyWindow.bounds;
                }];
            }
        }];
    }
    else
    {
        self.imageView.image = cacheImage;
        self.imageView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    }
}

@end

@interface ADPhotoBroswerView()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

/**遮盖*/
@property (nonatomic, strong) UIView *coverView;

/**最后点击消失时的图片容器*/
@property (nonatomic, strong) UIImageView *dismissImageView;

/**原始图片*/
@property (nonatomic, strong) NSArray *originalUrls;

/**缩略图片*/
@property (nonatomic, strong) NSArray *thumbnailUrls;

/**缩略图最初大小*/
@property (nonatomic, assign)  CGRect thumbnailFrame;

/**放大系数*/
@property (nonatomic, assign)  NSInteger scale;

@end

@implementation ADPhotoBroswerView

- (void)showImagesWithOriginalUrls:(NSArray *)originalUrls thumbnailUrls:(NSArray *)thumbnailUrls
{
    self.originalUrls = originalUrls;
    self.thumbnailUrls = thumbnailUrls;
    [self setUpCoverView];
}

- (void)setUpCoverView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.scale = 1;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = keyWindow.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *coverView = [[UICollectionView alloc] initWithFrame:keyWindow.bounds collectionViewLayout:layout];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.delegate = self;
    coverView.dataSource = self;
    [coverView registerClass:[ADPhotoBroswerViewCell class] forCellWithReuseIdentifier:@"cell"];
    coverView.pagingEnabled = YES;
    
    coverView.userInteractionEnabled = YES;
    
    coverView.canCancelContentTouches = YES;
    coverView.delaysContentTouches = NO;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage)];
    doubleTap.numberOfTapsRequired = 2;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCover)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [singleTap requireGestureRecognizerToFail:pinch];
    
    [coverView addGestureRecognizer:singleTap];
    [coverView addGestureRecognizer:doubleTap];
    [coverView addGestureRecognizer:pinch];
    
    [keyWindow addSubview:coverView];
    self.coverView = coverView;
}

- (void)scaleImage
{
    self.scale++;
    self.dismissImageView.layer.transform = CATransform3DScale([UIApplication sharedApplication].keyWindow.layer.transform, self.scale, self.scale, 0);
    NSLog(@"%zd",self.scale);
    if (self.scale == kMaxScale)
    {
        self.scale = 1;
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    CGFloat currentScale = pinch.scale;
//    NSLog(@"%f",currentScale);
    
    self.dismissImageView.layer.transform = CATransform3DScale([UIApplication sharedApplication].keyWindow.layer.transform, currentScale, currentScale, 0);
    
    if (pinch.state == UIGestureRecognizerStateEnded)
    {
        currentScale = currentScale > kMaxScale ? kMaxScale : currentScale;
        currentScale = currentScale < 1 ? 1 : currentScale;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.dismissImageView.layer.transform = CATransform3DScale([UIApplication sharedApplication].keyWindow.layer.transform, currentScale, currentScale, 0);
        }];
    }
}

- (void)dismissCover
{
    self.coverView.backgroundColor = [UIColor clearColor];
    UIImage *image = self.dismissImageView.image;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    self.dismissImageView.frame = CGRectMake(0, (kScreenHeight - h * kScreenWidth / w) / 2, kScreenWidth, h * kScreenWidth / w);
    self.dismissImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.dismissImageView.layer.masksToBounds = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.dismissImageView.frame = self.frame;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADPhotoBroswerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.frame = self.thumbnailFrame;
    cell.imageView.backgroundColor = [UIColor blackColor];
    cell.originalUrl = self.originalUrls[indexPath.row];
    self.dismissImageView = cell.imageView;
    self.scale = 1;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.thumbnailUrls.count;
    count = count > self.originalUrls.count ? self.originalUrls.count : count;
    count = self.originalUrls.count;
    return count;
}

- (CGRect)thumbnailFrame
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat x = (kScreenWidth - w) * 0.5;
    CGFloat y = (kScreenHeight - h) * 0.5;
    return CGRectMake(x, y, w, h);
}

- (void)setDismissImageView:(UIImageView *)dismissImageView
{
    _dismissImageView = dismissImageView;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    
    _dismissImageView.userInteractionEnabled = YES;
    
//    [_dismissImageView addGestureRecognizer:pan];
}

- (void)test:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.dismissImageView.superview];
    
    NSLog(@"%@",NSStringFromCGPoint(point));
}

@end

