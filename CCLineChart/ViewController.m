//
//  ViewController.m
//  CCLineChart
//
//  Created by CC on 2018/6/4.
//  Copyright © 2018年 Caroline. All rights reserved.
//

#import "ViewController.h"
#import "HomeLineChartView.h" //折线图

@interface ViewController ()
{
    HomeLineChartView  *_lineChatView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //折线图
    _lineChatView = [[HomeLineChartView alloc] initWithFrame:CGRectMake(15, 100, self.view.frame.size.width - 30, 430)];
    _lineChatView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0  blue:247/255.0  alpha:1];
    [self.view addSubview:_lineChatView];
    _lineChatView.dataArrOfY = @[@"1200",@"1000",@"800",@"600",@"400",@"200",@"0"];//Y轴坐标
    _lineChatView.dataArrOfX = @[@"1",@"2",@"3",@"4",@"5",
                                 @"6",@"7",@"8",@"9",@"10",
                                 @"11",@"12",@"13",@"14",@"15",
                                 @"16",@"17",@"18",@"19",@"20",
                                 @"21",@"22",@"23",@"24",@"25",
                                 @"26",@"27",@"28",@"29",@"30",@"31"];//X轴坐标
    _lineChatView.dataArrOfPoint = @[@"360",@"230",@"565",@"460",@"500",
                                     @"275",@"135",@"590",@"0",@"1000",
                                     @"0",@"230",@"565",@"460",@"500",
                                     @"460",@"475",@"335",@"390",@"1000",@"600"];
    _lineChatView.titleLabel.text = @"标题1";
    _lineChatView.bottomLabel.text = @"标题2";
    
    
    UIButton* update = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 100, 40)];
    [update setTitle:@"update" forState: UIControlStateNormal];
    update.backgroundColor = [UIColor grayColor];
    [update addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:update];
}

-(void) onClick:(UIButton*) button{
    
    [_lineChatView removeFromSuperview];
    _lineChatView = nil;
    
    _lineChatView = [[HomeLineChartView alloc] initWithFrame:CGRectMake(15, 100, self.view.frame.size.width - 30, 430)];
    _lineChatView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0  blue:247/255.0  alpha:1];
    [self.view addSubview:_lineChatView];
    
    
    _lineChatView.dataArrOfY = @[@"120",@"100",@"80",@"60",@"40",@"20",@"0"];//Y轴坐标
    _lineChatView.dataArrOfX = @[@"1",@"2",@"3",@"4",@"5",
                                 @"6",@"7",@"8",@"9",@"10",
                                 @"11",@"12",@"13",@"14",@"15",
                                 @"16",@"17",@"18",@"19",@"20",
                                 @"21",@"22",@"23",@"24",@"25",
                                 @"26",@"27",@"28",@"29",@"30",@"31"];//X轴坐标
    _lineChatView.dataArrOfPoint = @[@"60",@"30",@"65",@"60",@"50",
                                     @"25",@"35",@"90",@"0",@"10",
                                     @"0",@"20",@"55",@"40",@"50",
                                     @"40",@"45",@"35",@"90",@"100",@"60"];
    
    
}



@end
