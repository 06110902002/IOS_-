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
    _lineChatView = [[HomeLineChartView alloc] initWithFrame:CGRectMake(15, 300, self.view.frame.size.width - 30, 430)];
    _lineChatView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0  blue:247/255.0  alpha:1];
    _lineChatView.dataArrOfY = @[@"1200",@"1000",@"800",@"600",@"400",@"200",@"0"];//Y轴坐标
    _lineChatView.dataArrOfX = @[@"1",@"2",@"3",@"4",@"5",
                                 @"6",@"7",@"8",@"9",@"10",
                                 @"11",@"12",@"13",@"14",@"15",
                                 @"16",@"17",@"18",@"19",@"20",
                                 @"21",@"22",@"23",@"24",@"25",
                                 @"26",@"27",@"28",@"29",@"30",@"31"];//X轴坐标
    _lineChatView.dataArrOfPoint = @[@"800",@"200",@"600",@"343",@"250",@"700",
                                     @"400",@"600",@"1000",@"340",@"550",@"800"];
//    _lineChatView.titleLabel.text = @"标题1";
//    _lineChatView.bottomLabel.text = @"标题2";
    [self.view addSubview:_lineChatView];
   
    
    
    UIButton* update = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 100, 40)];
    [update setTitle:@"update" forState: UIControlStateNormal];
    update.backgroundColor = [UIColor grayColor];
    [update addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:update];
    
   
    self.yearPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 100, 140, 100)];
    self.yearPickerView.dataSource = self;
    self.yearPickerView.delegate = self;
    [self.view addSubview:self.yearPickerView];
    self.yearArr = @[@"2013",@"2014",@"2015"];
    self.monthArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
}

-(void) onClick:(UIButton*) button{
    
    [_lineChatView removeFromSuperview];
    _lineChatView = nil;

    _lineChatView = [[HomeLineChartView alloc] initWithFrame:CGRectMake(15, 300, self.view.frame.size.width - 30, 430)];
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



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.yearArr.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
            result = self.monthArr.count;
            break;
            
        default:
            break;
    }
    
    return result;

}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.yearArr[row];
            break;
        case 1:
            title = self.monthArr[row];
            break;
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            self.year = [self.yearArr objectAtIndex:row];
            break;
        case 1:
            self.month = [self.monthArr objectAtIndex:row];
            break;
        default:
            break;
    }
    NSString* date = [NSString stringWithFormat:@"%@/%@",self.year,self.month];
}


@end
