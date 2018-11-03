//
//  HomeLineChartView.m
//  CCLineChart
//
//  Created by CC on 2018/5/6.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "HomeLineChartView.h"

@interface HomeLineChartView ()
@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic,strong)UIView *lineChartView;
@property (nonatomic,strong)NSMutableArray *pointCenterArr;
@property (nonatomic,assign) BOOL startDrawLine;
@property (nonatomic,assign) CGPoint curPos;
@property (nonatomic,assign) NSInteger lineHeight;
@property (nonatomic,strong) NSMutableDictionary* posAndValue; //当前座标代表的值
@property (nonatomic,assign) NSInteger topIndexLineWidth;
@property(nonatomic,assign) NSInteger topIndexLineTopMargin;
@property(nonatomic,strong) NSString* selectDaySum; //选中的消费金额
@end


@implementation HomeLineChartView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.startDrawLine = false;
        self.curPos = CGPointZero;
        self.posAndValue = [[NSMutableDictionary alloc] init];
        self.topIndexLineTopMargin = 10;

        //左上角按钮
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0  blue:122/255.0  alpha:1];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        //下面按钮
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _bottomLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 10 - 20 / 2);
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.textColor = [UIColor colorWithRed:0/255.0 green:165/255.0  blue:87/255.0  alpha:1];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomLabel];
        
        
        //中间区域
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + _titleLabel.frame.size.height + 10, self.bounds.size.width, self.bounds.size.height - 40)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        //_contentView.backgroundColor = [UIColor brownColor];
        [self addLineChartView];
        self.pointCenterArr = [NSMutableArray array];
        
    }
    return self;
    
}
- (void)layoutSubviews{
    self.lineHeight = [self bounds].size.height;
    self.topIndexLineWidth = [self bounds].size.width;
}
#pragma mark - 外部赋值
//外部Y坐标轴赋值
-(void)setDataArrOfY:(NSArray *)dataArrOfY
{
    _dataArrOfY = dataArrOfY;
    [self addYAxisViews];
}

//外部X坐标轴赋值
-(void)setDataArrOfX:(NSArray *)dataArrOfX
{
    _dataArrOfX = dataArrOfX;
    [self addXAxisViews];
    [self addLinesView];
}

//点数据
-(void)setDataArrOfPoint:(NSArray *)dataArrOfPoint
{
    _dataArrOfPoint = dataArrOfPoint;
    [self addPointView];
    [self addBezierLine];
}

#pragma mark - UI
- (void)addLineChartView
{
    _lineChartView = [[UIView alloc]initWithFrame:CGRectMake(5, 50, _contentView.bounds.size.width - 15, _contentView.bounds.size.height-100)];
    _lineChartView.layer.masksToBounds = YES;
    _lineChartView.layer.borderWidth = 0.5;
    _lineChartView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1].CGColor;
    _lineChartView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_lineChartView];
}

-(void)addYAxisViews
{
    CGFloat height = _lineChartView.bounds.size.height / (_dataArrOfY.count - 1);
    for (int i = 0;i< _dataArrOfY.count ;i++ )
    {
        //if([_dataArrOfY[i] integerValue] == 0){continue;}
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, height * i - height / 2 - 10, 30, height)];
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0  blue:74/255.0  alpha:1];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.text = _dataArrOfY[i];
        leftLabel.backgroundColor = [UIColor clearColor];
        [_lineChartView addSubview:leftLabel];
    }
}

-(void)addXAxisViews
{
    CGFloat height = _lineChartView.bounds.size.width /( _dataArrOfX.count - 1);
    for (int i = 0;i< _dataArrOfX.count;i++ )
    {
        if([_dataArrOfX[i] integerValue] % 5 != 0){continue;}
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(
                                                            i*height - 1.5 * height +_lineChartView.frame.origin.x,
                                                    _lineChartView.bounds.origin.y+_lineChartView.bounds.size.height, 30, 20)];
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0  blue:74/255.0  alpha:1];
        leftLabel.text = _dataArrOfX[i];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:leftLabel];
    }
    
}

-(void)addLinesView
{
    CGFloat white = _lineChartView.bounds.size.height /( _dataArrOfY.count - 1);
    CGFloat height = _lineChartView.bounds.size.width /( _dataArrOfX.count - 1);
    //横格
    for (int i = 0;i < _dataArrOfY.count - 2 ;i++ ){
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineChartView.bounds.size.width , 0.5)];
        hengView.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1];
        [_lineChartView addSubview:hengView];
    }
    //竖格
    for (int i = 0;i< _dataArrOfX.count - 2 ;i++ ){
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 0, 0.5, _lineChartView.bounds.size.height)];
        shuView.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1];
        [_lineChartView addSubview:shuView];
    }
}

#pragma mark - 点和根据点画贝塞尔曲线
-(void)addPointView
{
    //区域高
    CGFloat height = self.lineChartView.bounds.size.height;
    //y轴最小值
    float arrmin = [_dataArrOfY[_dataArrOfY.count - 1] floatValue];
    //y轴最大值
    float arrmax = [_dataArrOfY[0] floatValue];
    //区域宽
    CGFloat width = self.lineChartView.bounds.size.width;
    //X轴间距
    float Xmargin = width / (_dataArrOfX.count - 1 );
    
    for (int i = 0; i<_dataArrOfPoint.count; i++)
    {
        //nowFloat是当前值
        float nowFloat = [_dataArrOfPoint[i] floatValue];
        //点点的x就是(竖着的间距 * i),y坐标就是()
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake((Xmargin)*i - 2 / 2, height - (nowFloat - arrmin)/(arrmax - arrmin) * height - 2 / 2 , 2, 2)];
        v.backgroundColor = [UIColor blueColor];
        [_lineChartView addSubview:v];
        
        NSValue *point = [NSValue valueWithCGPoint:v.center];
        [self.pointCenterArr addObject:point];
        
        [self.posAndValue setObject:_dataArrOfPoint[i] forKey:[NSString stringWithFormat:@"%f",v.center.x]];
    }
//    for (NSString *string in self.posAndValue){
//        NSLog(@"181-------string = %@", string);
//    }

}

-(void)addBezierLine
{
    //取得起点
    CGPoint p1 = [[self.pointCenterArr objectAtIndex:0] CGPointValue];
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //添加线
    for (int i = 0;i<self.pointCenterArr.count;i++ )
    {
        
        if (i != 0)
        {
            CGPoint prePoint = [[self.pointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.pointCenterArr objectAtIndex:i] CGPointValue];
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
        }
    }
    //显示线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithRed:245/255.0 green:166/255.0  blue:35/255.0  alpha:1].CGColor;
    shapeLayer.lineWidth = 2;
    [_lineChartView.layer addSublayer:shapeLayer];
    //设置动画
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =2.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    
    //遮罩层相关
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    CGPoint lastPoint;
    for (int i = 0;i<self.pointCenterArr.count;i++ )
    {
        if (i != 0)
        {
            CGPoint prePoint = [[self.pointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.pointCenterArr objectAtIndex:i] CGPointValue];
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            if (i == self.pointCenterArr.count-1)
            {
                lastPoint = nowPoint;
            }
        }
    }
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    CGPoint lastPointX1 = CGPointMake(lastPointX,_lineChartView.bounds.size.height);
    [bezier1 addLineToPoint:lastPointX1];
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, _lineChartView.bounds.size.height)];
    [bezier1 addLineToPoint:p1];
    
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor colorWithRed:245/255.0 green:166/255.0  blue:35/255.0  alpha:1].CGColor;
    [_lineChartView.layer addSublayer:shadeLayer];
    
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, _lineChartView.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:245/255.0 green:166/255.0  blue:35/255.0  alpha:0.6].CGColor,(__bridge id)[UIColor colorWithRed:245/255.0 green:166/255.0  blue:35/255.0  alpha:0.2].CGColor];
    gradientLayer.locations = @[@(0.5f)];

    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [_lineChartView.layer addSublayer:baseLayer];

    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 2.0f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*lastPoint.x, _lineChartView.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"]; 
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawIndexLine:self.curPos];
    [self drawTopIndexLine:self.curPos];
    [self drawDetailMaker:self.curPos content:self.selectDaySum];
}


/**
 画中间索引线

 @param point x座标
 */
-(void)drawIndexLine:(CGPoint) point{
    if(self.startDrawLine){
    
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, point.x, self.topIndexLineTopMargin + 5);
        CGContextAddLineToPoint(context, point.x, self.lineHeight);
        CGContextClosePath(context);
        CGContextSetLineWidth(context, 0.8);
        [[UIColor redColor]setStroke];//设置红色边框
        //[[UIColor greenColor]setFill];//设置绿色填充
        //[[UIColor blueColor]set];//同时设置填充和边框色
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

/**
 画顶部指示线

 @param point 当前座标
 */
-(void) drawTopIndexLine:(CGPoint)point{
    if(!self.startDrawLine) return;
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, self.topIndexLineTopMargin);
    CGContextAddLineToPoint(context, self.topIndexLineWidth, self.topIndexLineTopMargin);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 0.8);
    [[UIColor redColor]setStroke];//设置红色边框
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //画索引三角形，使用3条线组成
    CGContextMoveToPoint(context, point.x - 5, self.topIndexLineTopMargin);
    CGContextAddLineToPoint(context, point.x, 15);
    
    CGContextMoveToPoint(context, point.x, 15);
    CGContextAddLineToPoint(context, point.x + 5, self.topIndexLineTopMargin);
    [[UIColor redColor]setStroke];//设置红色边框
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 0.8);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextMoveToPoint(context, point.x + 5, self.topIndexLineTopMargin);
    CGContextAddLineToPoint(context, point.x - 5, self.topIndexLineTopMargin);
    [[UIColor whiteColor]setStroke];//设置红色边框
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 0.8);
    CGContextDrawPath(context, kCGPathFillStroke);
   
}

/**
 画浮动显示框

 @param point 当前手指座标
 @param text 当前内容
 */
-(void) drawDetailMaker:(CGPoint)point content:(NSString*) text{
    if(!self.startDrawLine || self.selectDaySum == nil) return;
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rectangle = CGRectMake(point.x - 50, 2 * self.topIndexLineTopMargin,100, 60.0f); //指定矩形
    CGPathAddRect(path,NULL, rectangle);//将矩形添加到路径中
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取上下文
    CGContextAddPath(currentContext, path);//将路径添加到上下文
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setStroke];
    CGContextSetLineWidth(currentContext,1.0f);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
    
   
    //绘制文本
    CGContextSetLineWidth(currentContext, 1.0);
    CGContextSetRGBFillColor (currentContext, 0.01, 0.01, 0.01, 1);
    
    //段落格式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    UIFont  *font = [UIFont systemFontOfSize:14.0];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle};//构建属性集合
    NSString* value = [NSString stringWithFormat:@"%@\n%@\n%@",@"2018/11/05",@"每日利润",text];
    CGSize strSize = [value sizeWithAttributes:attributes];  //获得size
    CGFloat marginTop = (rectangle.size.height - strSize.height) / 2;
    //垂直居中要自己计算
    CGRect r = CGRectMake(rectangle.origin.x, rectangle.origin.y + marginTop,rectangle.size.width, strSize.height);
    [value drawInRect:r withAttributes:attributes];
    
}

//当有一个或多个手指触摸事件在当前视图或window窗体中响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    self.curPos = [touch locationInView:[touch view]];
    self.startDrawLine = true;
    [self setNeedsDisplay];
    self.selectDaySum = [self getValueByPosX:self.curPos.x];
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setNeedsDisplay];
    self.curPos = [self getPosByUIEvent:event];
    self.startDrawLine = true;
    self.selectDaySum = [self getValueByPosX:self.curPos.x];
    
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self setNeedsDisplay];
    //self.startDrawLine = false;
    
}

-(CGPoint) getPosByUIEvent:(UIEvent*)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    return point;
}

-(NSString*) getValueByPosX:(CGFloat) x{
    NSString* value = nil;
    CGFloat dayUnit = _lineChartView.bounds.size.width /( _dataArrOfX.count - 1);   //一天所占用的格子
    NSInteger index = x / dayUnit;
    if(index < [_dataArrOfPoint count] && index >= 0){
        value = [_dataArrOfPoint objectAtIndex:index];
    }
    return value;
}







@end
