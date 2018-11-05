//
//  ViewController.h
//  CCLineChart
//
//  Created by CC on 2018/6/4.
//  Copyright © 2018年 Caroline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIPickerView* yearPickerView;
@property(nonatomic,strong) NSMutableArray* yearArr;
@property(nonatomic,strong) NSMutableArray* monthArr;
@property(nonatomic,copy)NSString* year;
@property(nonatomic,copy)NSString* month;


@end

