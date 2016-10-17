//
//  ViewController.m
//  APhotoBroswer
//
//  Created by andehang on 16/10/10.
//  Copyright © 2016年 andehang. All rights reserved.
//

#import "ViewController.h"
#import "DemoCell.h"

#define kScreenHeight     ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth      ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/**原图地址*/
@property (nonatomic, strong)  NSArray *originalUrls;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];  
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 代理

#pragma mark UITableViewDelegate,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.originalUrls = self.originalUrls;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat margin = 10;
    CGFloat h = (kScreenWidth - 4 * margin) / 3;
    
    NSInteger row = self.originalUrls.count / 3 + 1;
    
    return row * h + (row + 1) * 10;
}


#pragma mark - getter setter

- (NSArray *)originalUrls
{
    return @[@"http://b.hiphotos.baidu.com/zhidao/pic/item/8d5494eef01f3a29fc8b5f449f25bc315d607cfd.jpg",@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476245140&di=042eb091391938de16887e2f7916a933&src=http://www.ip138.com/images/china31.jpg",@"http://img5q.duitang.com/uploads/item/201506/02/20150602151418_5SfN2.jpeg",@"http://pic12.nipic.com/20110113/5869038_153749556191_2.jpg"
             ];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DemoCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
