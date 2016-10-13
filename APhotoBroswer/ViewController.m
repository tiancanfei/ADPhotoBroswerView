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

/**<#注解#>*/
@property (nonatomic, strong)  ADPhotoBroswerView *view1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 400, 100, 100)];
    
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476245140&di=042eb091391938de16887e2f7916a933&src=http://www.ip138.com/images/china31.jpg"]];
    [self.view addSubview:imageView1];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    
    imageView.userInteractionEnabled = YES;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/zhidao/pic/item/8d5494eef01f3a29fc8b5f449f25bc315d607cfd.jpg"]];
    
    [self.view addSubview:imageView];

//    ADPhotoBroswerView *imgView = [[ADPhotoBroswerView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    
    
    
//    imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest:)];
    
    [imageView addGestureRecognizer:tap];

    
    //@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476245140&di=042eb091391938de16887e2f7916a933&src=http://www.ip138.com/images/china31.jpg"
    
//    [self.view addSubview:imgView];
}

- (void)tapTest:(UIGestureRecognizer *)gesture
{
//    [(ADPhotoBroswerView *)gesture.view showImagesWithOriginalUrls:@[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476245140&di=042eb091391938de16887e2f7916a933&src=http://www.ip138.com/images/china31.jpg",@"http://b.hiphotos.baidu.com/zhidao/pic/item/8d5494eef01f3a29fc8b5f449f25bc315d607cfd.jpg",@"http://img5q.duitang.com/uploads/item/201506/02/20150602151418_5SfN2.jpeg",@"http://pic12.nipic.com/20110113/5869038_153749556191_2.jpg"
//] thumbnailUrls:nil];
    
    ADPhotoBroswerView *view1 = [[ADPhotoBroswerView alloc] init];
    
    self.view1 = view1;
    
    [view1 showImagesWithOriginalUrls:@[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476245140&di=042eb091391938de16887e2f7916a933&src=http://www.ip138.com/images/china31.jpg",@"http://b.hiphotos.baidu.com/zhidao/pic/item/8d5494eef01f3a29fc8b5f449f25bc315d607cfd.jpg",@"http://img5q.duitang.com/uploads/item/201506/02/20150602151418_5SfN2.jpeg",@"http://pic12.nipic.com/20110113/5869038_153749556191_2.jpg"
                                       ] thumbnailImageViews:@[gesture.view,gesture.view,gesture.view,gesture.view,gesture.view,gesture.view]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
