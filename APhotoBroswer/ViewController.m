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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ADPhotoBroswerView *imgView = [[ADPhotoBroswerView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    
    
    
    imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest:)];
    
    [imgView addGestureRecognizer:tap];
    
    imgView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:imgView];
}

- (void)tapTest:(UIGestureRecognizer *)gesture
{
    [(ADPhotoBroswerView *)gesture.view showImagesWithOriginalUrls:@[@"http://a.hiphotos.baidu.com/zhidao/pic/item/48540923dd54564e72d16cb3b5de9c82d0584f80.jpg",@"http://b.hiphotos.baidu.com/zhidao/pic/item/8d5494eef01f3a29fc8b5f449f25bc315d607cfd.jpg",@"http://img5q.duitang.com/uploads/item/201506/02/20150602151418_5SfN2.jpeg",@"http://pic12.nipic.com/20110113/5869038_153749556191_2.jpg"
] thumbnailUrls:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
