//
//  LTSCalendarScrollView.h
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekDayView.h"
@interface LTSCalendarScrollView : UIScrollView
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LTSCalendarContentView *calendarView;
@property (nonatomic,strong)NSMutableArray *dataSourceArray;
@property (nonatomic,strong)NSString *selectDateString;
@property (nonatomic,assign)NSInteger noFinishCount;
@property (nonatomic,assign)BOOL showBeginButton;
@property (nonatomic,strong)UIViewController *currentVC;

@property (nonatomic,strong)UIColor *bgColor;
- (void)scrollToSingleWeek;

- (void)scrollToAllWeek;
@end
