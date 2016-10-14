//
//  ViewController.m
//  APhotoBroswer
//
//  Created by andehang on 16/10/10.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import "ViewController.h"
#import "ADPhotoBroswerView.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property (nonatomic, strong)  UIImageView *imageView1;

/**原图地址*/
@property (nonatomic, strong)  NSArray *originalUrls;

@end

@implementation ViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    //添加图片1
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    self.imageView1 = imageView1;
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476245140&di=042eb091391938de16887e2f7916a933&src=http://www.ip138.com/images/china31.jpg"]];
    [self.view addSubview:imageView1];
    
    //添加图片2
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    imageView2.backgroundColor = [UIColor redColor];
    imageView2.userInteractionEnabled = YES;
    [self.view addSubview:imageView2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBroswe:)];
    [imageView2 addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter setter

- (NSArray *)originalUrls
{
    return @[@"http://b.hiphotos.baidu.com/zhidao/pic/item/8d5494eef01f3a29fc8b5f449f25bc315d607cfd.jpg",@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476245140&di=042eb091391938de16887e2f7916a933&src=http://www.ip138.com/images/china31.jpg",@"http://img5q.duitang.com/uploads/item/201506/02/20150602151418_5SfN2.jpeg",@"http://pic12.nipic.com/20110113/5869038_153749556191_2.jpg"
             ];
}

#pragma mark - 自定义方法

- (void)tapBroswe:(UIGestureRecognizer *)gesture
{
    //从下标1开始浏览图片
    ADPhotoBroswerView *photoBroswerView = [ADPhotoBroswerView showImagesWithOriginalUrls:self.originalUrls
                                                                      thumbnailImageViews:@[gesture.view,self.imageView1,gesture.view,gesture.view,gesture.view,gesture.view] browseStartIndex:1];
    photoBroswerView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
}

@end
