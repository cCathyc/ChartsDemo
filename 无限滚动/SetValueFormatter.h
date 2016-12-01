//
//  SetValueFormatter.h
//  无限滚动
//
//  Created by caoting on 2016/11/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;
@interface SetValueFormatter : NSObject<IChartValueFormatter>
-(id)initWithArr:(NSArray *)arr;
@end
