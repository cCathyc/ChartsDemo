//
//  ViewController.m
//  无限滚动
//
//  Created by caoting on 15/11/10.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import "SymbolsValueFormatter.h"
#import "DateValueFormatter.h"
#import "SetValueFormatter.h"
#define screenWidth  [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

@import Charts;
@interface ViewController ()<ChartViewDelegate>
@property (nonatomic,strong) LineChartView * lineView;
@property (nonatomic,strong) UILabel * markY;
@end


@implementation ViewController
- (UILabel *)markY{
    if (!_markY) {
        _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
        _markY.font = [UIFont systemFontOfSize:15.0];
        _markY.textAlignment = NSTextAlignmentCenter;
        _markY.text =@"";
        _markY.textColor = [UIColor whiteColor];
        _markY.backgroundColor = [UIColor grayColor];
    }
    return _markY;
}

- (LineChartView *)lineView {
    if (!_lineView) {
        _lineView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 50, screenWidth, screenHeight-200)];
        _lineView.delegate = self;//设置代理
        _lineView.backgroundColor =  [UIColor whiteColor];
        _lineView.noDataText = @"暂无数据";
        _lineView.chartDescription.enabled = YES;
        _lineView.scaleYEnabled = NO;//取消Y轴缩放
        _lineView.doubleTapToZoomEnabled = NO;//取消双击缩放
        _lineView.dragEnabled = YES;//启用拖拽图标
        _lineView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        _lineView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        //设置滑动时候标签
        ChartMarkerView *markerY = [[ChartMarkerView alloc]
                                    init];
        markerY.offset = CGPointMake(-999, -8);
        markerY.chartView = _lineView;
        _lineView.marker = markerY;
        [markerY addSubview:self.markY];
        
        
        
        
        
        _lineView.rightAxis.enabled = NO;//不绘制右边轴
        ChartYAxis *leftAxis = _lineView.leftAxis;//获取左边Y轴
        leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
        // leftAxis.axisMinValue = 0;//设置Y轴的最小值
        //leftAxis.axisMaxValue = 105;//设置Y轴的最大值
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineColor = [UIColor clearColor];//Y轴颜色
        leftAxis.valueFormatter = [[SymbolsValueFormatter alloc]init];
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.labelTextColor = [UIColor blackColor];//文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
        leftAxis.gridColor = [UIColor grayColor];//网格线颜色
        leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
        
        ChartXAxis *xAxis = _lineView.xAxis;
        xAxis.granularityEnabled = YES;//设置重复的值不显示
        xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
        xAxis.gridColor = [UIColor clearColor];
        xAxis.labelTextColor = [UIColor blackColor];//文字颜色
        xAxis.axisLineColor = [UIColor grayColor];
        _lineView.maxVisibleCount = 999;//
        //描述及图例样式
        [_lineView setDescriptionText:@""];
        _lineView.legend.enabled = NO;
        
        [_lineView animateWithXAxisDuration:1.0f];
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.lineView];
    self.lineView.data = [self setData];
  
   }
- (LineChartData *)setData{
    NSInteger xVals_count = 50;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= xVals_count; i++) {
        if (i<30) {
        [xVals addObject: [NSString stringWithFormat:@"02-%d",i]];
        }else{
        [xVals addObject: [NSString stringWithFormat:@"03-%d",i-29]];
        }
    }
    _lineView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:xVals];
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        int a = arc4random() % 100;
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    if (_lineView.data.dataSetCount > 0) {
        LineChartData *data = (LineChartData *)_lineView.data;
        set1 = (LineChartDataSet *)data.dataSets[0];
        set1.values = yVals;
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        return data;
    }else{
        //创建LineChartDataSet对象
        set1 = [[LineChartDataSet alloc]initWithValues:yVals label:nil];
        //设置折线的样式
        set1.lineWidth = 2.0/[UIScreen mainScreen].scale;//折线宽度
        
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        
        set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
        
        [set1 setColor:[UIColor greenColor]];//折线颜色
        set1.highlightColor = [UIColor redColor];
        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.drawFilledEnabled = NO;//是否填充颜色

        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //添加第二个LineChartDataSet对象
        
        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
        for (int i = 0; i <  xVals_count; i++) {
            int a = arc4random() % 80;
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
            [yVals2 addObject:entry];
        }
        LineChartDataSet *set2 = [set1 copy];
        set2.values = yVals2;
        set2.drawValuesEnabled = NO;
        [set2 setColor:[UIColor blueColor]];
        
        [dataSets addObject:set2];
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
        
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
        [data setValueTextColor:[UIColor blackColor]];//文字颜色
        
        
        return data;
    }
    
}

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
    _markY.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)entry.y];
    //将点击的数据滑动到中间
    [_lineView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_lineView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];

    
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
    
    
}


@end
