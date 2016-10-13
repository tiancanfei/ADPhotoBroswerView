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
#define kMaxScale 3
#define kMinScale 0.5

#define kPlaceholderImage [UIImage imageNamed:@"zhanweifu"]

#pragma mark - ADPhotoBroswerViewCell

@interface ADPhotoBroswerViewCell : UICollectionViewCell<UIScrollViewDelegate>

/**图片*/
@property (strong, nonatomic) UIImageView *imageView;

/**原始图片*/
@property (nonatomic, copy) NSString *originalUrl;

/**放大图片容器*/
@property (nonatomic, strong) UIScrollView *imageScaleView;

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageScaleView.frame = self.bounds;
}

#pragma mark 代理
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.imageScaleView.zoomScale == 1)
    {
        self.imageScaleView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        CGFloat heightToWidthRatio = self.imageView.image.size.height / self.imageView.image.size.width;
        
        CGRect frame = self.imageView.frame;
        frame.size.width = kScreenWidth;
        frame.size.height = kScreenWidth * heightToWidthRatio;
        frame.origin.x = 0;
        frame.origin.y = (kScreenHeight - frame.size.height) * 0.5;
        self.imageView.frame = frame;
        return;
    }
    
    CGFloat maxImageH = self.imageScaleView.zoomScale * self.imageView.bounds.size.height;
    CGFloat maxImageW = self.imageScaleView.zoomScale * self.imageView.bounds.size.width;
    
    CGRect scaleViewFrame = self.imageScaleView.frame;
    
    scaleViewFrame.size.width = maxImageW < kScreenWidth ? maxImageW : kScreenWidth;
    scaleViewFrame.size.height = maxImageH < kScreenHeight ? maxImageH : kScreenHeight;
    scaleViewFrame.origin.x = (kScreenWidth - scaleViewFrame.size.width) * 0.5;
    scaleViewFrame.origin.y = (kScreenHeight - scaleViewFrame.size.height) * 0.5;
    
    self.imageScaleView.frame = scaleViewFrame;
    
    CGRect frame = self.imageView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.imageView.frame = frame;
}

#pragma mark 自定义

- (void)setUpCell
{
    [self.contentView addSubview:self.imageScaleView];
    [self.imageScaleView addSubview:self.imageView];
}

#pragma mark getter setter

- (void)setOriginalUrl:(NSString *)originalUrl
{
    self.imageScaleView.zoomScale = 1;
    
    _originalUrl = originalUrl;
    
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_originalUrl];
    
    CGFloat heightToWidthRatio = cacheImage.size.height / cacheImage.size.width;
    
    CGFloat w = kScreenWidth;
    CGFloat h = kScreenWidth * heightToWidthRatio;
    CGFloat y = (kScreenHeight - h) * 0.5;
    
    if (!cacheImage)
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_originalUrl] placeholderImage:kPlaceholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize == 0)
            {
                [SVProgressHUD show];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat heightToWidthRatio = image.size.height / image.size.width;
            
            CGFloat w = kScreenWidth;
            CGFloat h = kScreenWidth * heightToWidthRatio;
            CGFloat y = (kScreenHeight - h) * 0.5;
            
            if (error)
            {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }
            else
            {
                [SVProgressHUD dismiss];
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.imageView.frame = CGRectMake(0, y, w, h);
                }];
            }
        }];
    }
    else
    {
        self.imageView.image = cacheImage;
        self.imageView.frame = CGRectMake(0, y, w, h);
    }
}

- (UIScrollView *)imageScaleView
{
    if (!_imageScaleView)
    {
        _imageScaleView = [[UIScrollView alloc] init];
        _imageScaleView.minimumZoomScale = kMinScale;
        _imageScaleView.maximumZoomScale = kMaxScale;
        _imageScaleView.delegate = self;
        _imageScaleView.contentInset = UIEdgeInsetsZero;
    }
    return _imageScaleView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor redColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

@end

#pragma mark - ADPhotoBroswerView

@interface ADPhotoBroswerView()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

/**图片浏览器*/
@property (nonatomic, strong) UICollectionView *browerView;

/**快照*/
@property (nonatomic, strong) UIView *snapshotView;

/**当前cell*/
@property (nonatomic, strong) ADPhotoBroswerViewCell *currentCell;

/**原始图片*/
@property (nonatomic, strong) NSArray *originalUrls;

/**缩略图View*/
@property (nonatomic, strong) NSArray *thumbnailImageViews;

/**cell重用标示*/
@property (nonatomic, strong)  NSArray *identifiers;

/**缩略图最初大小*/
@property (nonatomic, assign)  CGRect thumbnailFrame;

/**放大系数*/
@property (nonatomic, assign)  CGFloat scale;

/**当前图片下标*/
@property (nonatomic, assign) NSInteger currentImageIndex;

@end

@implementation ADPhotoBroswerView

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.identifiers[indexPath.row];
    ADPhotoBroswerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.frame = self.thumbnailFrame;
    UIImage *thumbnailImage = [(UIImageView *)self.thumbnailImageViews[indexPath.row] image];
    cell.imageView.image = thumbnailImage;
    NSString *originalUrl =  indexPath.row >= self.originalUrls.count ? @"" : self.originalUrls[indexPath.row];

    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originalUrl];
    
    cell.backgroundColor = [UIColor blueColor];
    cell.originalUrl = originalUrl;
    self.currentCell = cell;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.identifiers.count;
}

#pragma mark getter setter

- (CGRect)thumbnailFrame
{
    CGFloat w = 100;
    CGFloat h = 100;
    CGFloat x = (kScreenWidth - w) * 0.5;
    CGFloat y = (kScreenHeight - h) * 0.5;
    return CGRectMake(x, y, w, h);
}

- (UICollectionView *)browerView
{
    if (!_browerView)
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = keyWindow.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _browerView = [[UICollectionView alloc] initWithFrame:keyWindow.bounds collectionViewLayout:layout];
        _browerView.backgroundColor = [UIColor blackColor];
        _browerView.delegate = self;
        _browerView.dataSource = self;
        _browerView.pagingEnabled = YES;
        
        _browerView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage)];
        doubleTap.numberOfTapsRequired = 2;
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCover)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [_browerView addGestureRecognizer:singleTap];
        [_browerView addGestureRecognizer:doubleTap];
        
        [keyWindow addSubview:_browerView];
    }
    return _browerView;
}

- (void)setCurrentCell:(ADPhotoBroswerViewCell *)currentCell
{
    _currentCell = currentCell;
    
    self.scale = _currentCell.imageScaleView.zoomScale;
}

- (NSInteger)currentImageIndex
{
    CGFloat x = self.browerView.contentOffset.x;
    _currentImageIndex = (x + kScreenWidth * 0.5) / kScreenWidth;
    return _currentImageIndex;
}

#pragma mark 自定义

- (void)showImagesWithOriginalUrls:(NSArray *)originalUrls thumbnailImageViews:(NSArray *)thumbnailImageViews
{
    self.thumbnailImageViews = thumbnailImageViews;
    self.originalUrls = originalUrls;
    
    __block NSMutableArray *identifiers = [NSMutableArray array];
    
    [self.thumbnailImageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSString *identifier = [NSString stringWithFormat:@"%zd",idx];
        [self.browerView registerClass:[ADPhotoBroswerViewCell class] forCellWithReuseIdentifier:identifier];
        [identifiers addObject:identifier];
    }];
    
    self.identifiers = identifiers;
}

- (void)scaleImage
{
    if (self.scale >= kMaxScale)
    {
        self.scale = 1;
    }
    else
    {
        self.scale++;
    }
    
    ADPhotoBroswerViewCell *cell = self.currentCell;
    cell.imageScaleView.zoomScale = self.scale;
}


- (void)dismissCover
{
    self.snapshotView = [self.currentCell.imageView snapshotViewAfterScreenUpdates:YES];
    
    self.snapshotView.frame = [[self.currentCell.imageView superview] convertRect:self.currentCell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.snapshotView];
    
    [self.browerView removeFromSuperview];
    
//    NSLog(@"下标:%zd",self.currentImageIndex);
    
    UIView *finallyView = self.thumbnailImageViews[self.currentImageIndex];
    CGRect origanalRect = [finallyView.superview convertRect:finallyView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    [UIView animateWithDuration:3 animations:^{
        self.snapshotView.frame = origanalRect;
    } completion:^(BOOL finished) {
        [self.snapshotView removeFromSuperview];
        self.snapshotView = nil;
    }];
}

@end

