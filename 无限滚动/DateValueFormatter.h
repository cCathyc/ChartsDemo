//
//  DateValueFormatter.h
//  无限滚动
//
//  Created by caoting on 2016/11/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;
@interface DateValueFormatter : NSObject<IChartAxisValueFormatter>
-(id)initWithArr:(NSArray *)arr;
@end
