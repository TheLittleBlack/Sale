//
//  ScheduleViewController.m
//  KingsLuck
//
//  Created by JayJay on 2017/12/3.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "ScheduleViewController.h"
#import "XTPopView.h"
#import "BaseWebViewController.h"
#import "CustomerVisitViewController.h"
#import "PlanVisitViewController.h"
#import "SignInViewController.h"
#import "UITableView+WLEmptyPlaceHolder.h"
#import "TeamManageVisitViewController.h"
#import "LTSCalendarManager.h"
#import "AddTaskViewController.h"

@interface ScheduleViewController ()<SelectIndexPathDelegate,UIPickerViewDelegate,UIPickerViewDataSource,LTSCalendarEventSource>

{

    NSString *_pickerSelectData;
    BOOL _showBeginButton;
    NSString *_selectDateString;
    BOOL _isFirst;
    BOOL _isSecondAppear;
}


@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *myTaskButton;
@property(nonatomic,strong)UIButton *branchTaskButton;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIView *backgroundView; // 弹出的View 选择任务类型
@property(nonatomic,strong)NSMutableArray *pickerViewDataSource;
@property(nonatomic,strong)LTSCalendarManager *manager;
@property(nonatomic,strong)UILabel *showTimeLabel;

@end

@implementation ScheduleViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *dateString;
    
    if([_selectDateString isEqualToString: @" "])
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateString = [dateFormatter stringFromDate:[NSDate date]];
    }
    else
    {
        dateString = _selectDateString;
    }

    // 过滤掉第一次显示时重复加载请求
    if(_isSecondAppear)
    {
        [self networkRequest:dateString hud:NO];
        
    }
    
    _isSecondAppear = YES;
    
    
    // 竞品信息开关
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:CollectTheSwitch] withPrameters:@{} result:^(id result) {
        
        NSLog(@"%@",result);
        NSArray *array = result[@"data"][@"data"];
        if(array.count>0)
        {
            for (NSString *subData in array) {
                if([subData isEqualToString:@"JPSJ"])
                {
                    [MYManage defaultManager].isJPSJ = YES;
                }
            }
        }
        
    } error:^(id error) {
        
    } withHUD:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectDateString = @" ";
    _showBeginButton = YES;
    _isFirst = YES;
    _pickerSelectData = @"婚喜宴检查"; // 默认选中婚喜宴
    
    self.navigationItem.title = @"我的任务";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.showTimeLabel];
    [self.showTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.view).offset(64);
        
    }];
    
    [self lts_InitUI];
    
    
    // 暂时隐藏下属任务
    //    [self setTitleView];
    
    

    
    
    
    [self addRightBarButton];
    
    
    [self addNewTaskView];
    
    
    
}

- (void)lts_InitUI{
    
    
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame))];
    [self.view addSubview:self.manager.calenderScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 是否显现农历
    [LTSCalendarAppearance share].isShowLunarCalender = NO;
    // 选中时日期实心圆的颜色
    [LTSCalendarAppearance share].dayCircleColorSelected = MainColor;
    // 今天实心圆的颜色
    [LTSCalendarAppearance share].dayCircleColorToday = MainColor;
    // 今天外圈圆的颜色
    [LTSCalendarAppearance share].dayBorderColorToday = MainColor;
    // 其他月份阳历文本颜色
    [LTSCalendarAppearance share].dayTextColorOtherMonth = [UIColor clearColor];
    /// 周  标识 颜色
    [LTSCalendarAppearance share].weekDayTextColor = [UIColor blackColor];
    /// 周  标识  字体大小
    [LTSCalendarAppearance share].weekDayTextFont = [UIFont systemFontOfSize:14];
    ///  阳历文本颜色
    [LTSCalendarAppearance share].dayTextColor = [UIColor blackColor];
    ///  阳历字体大小
    [LTSCalendarAppearance share].dayTextFont = [UIFont systemFontOfSize:14];
    self.manager.calenderScrollView.dataSourceArray = [NSMutableArray array];
    self.manager.calenderScrollView.currentVC = self;
    
    [self.manager reloadAppearanceAndData];
}

-(UILabel *)showTimeLabel
{
    if(!_showTimeLabel)
    {
        _showTimeLabel = [UILabel new];
        _showTimeLabel.font = [UIFont systemFontOfSize:15];
        _showTimeLabel.textColor = [UIColor blackColor];
        _showTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _showTimeLabel;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}



-(UIView *)titleView
{
    if(!_titleView)
    {
        _titleView = [UIView new];
    }
    return _titleView;
}

-(UIButton *)myTaskButton
{
    if(!_myTaskButton)
    {
        _myTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myTaskButton setTitle:@"我的任务" forState:UIControlStateNormal];
        [_myTaskButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_myTaskButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _myTaskButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_myTaskButton addTarget:self action:@selector(myTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _myTaskButton.selected = YES;
        
    }
    return _myTaskButton;
}

-(UIButton *)branchTaskButton
{
    if(!_branchTaskButton)
    {
        _branchTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_branchTaskButton setTitle:@"下属任务" forState:UIControlStateNormal];
        [_branchTaskButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_branchTaskButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _branchTaskButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_branchTaskButton addTarget:self action:@selector(branchTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _branchTaskButton.selected = NO;
        
    }
    return _branchTaskButton;
}



-(NSMutableArray *)pickerViewDataSource
{
    if(!_pickerViewDataSource)
    {
        NSArray *array = @[@"婚喜宴检查",@"品鉴会检查",@"广告检查",@"陈列检查",@"自定义"];
        _pickerViewDataSource = [NSMutableArray arrayWithArray:array];
        
    }
    return _pickerViewDataSource;
}

// ★注意
//- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
//{
//    // 判断日期是否在当前时间之前，是的话隐藏 + 号
//    _showBeginButton = YES;
//    NSInteger results = [self compareOneDay:[NSDate date] withAnotherDay:dayView.date];
//    if(results==1)
//    {
//        // 过期
//        [self removeRightBarButton];
//    }
//    else if (results==-1)
//    {
//        // 未来
//        _showBeginButton = NO;
//        [self addRightBarButton];
//    }
//    else
//    {
//        // 今天
//        [self addRightBarButton];
//    }
//
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    NSString *dateString = [dateFormatter stringFromDate:dayView.date];
//
//    MyLog(@"%@",dateString);
//
//
//    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
//    [UIView transitionWithView:dayView
//                      duration:.3
//                       options:0
//                    animations:^{
//                        dayView.circleView.transform = CGAffineTransformIdentity;
//                        [calendar reload];
//                    } completion:^(BOOL finished) {
//
//                        [self networkRequest:dateString hud:YES];
//
//                    }];
//}






- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}






-(void)myTaskButtonAction:(UIButton *)sender
{
    
    
    
    
    
    
    sender.selected = !sender.selected;
    self.branchTaskButton.selected = !self.branchTaskButton.selected;
}

-(void)branchTaskButtonAction:(UIButton *)sender
{
    
    
    
    
    sender.selected = !sender.selected;
    self.myTaskButton.selected = !self.myTaskButton.selected;
}

-(void)setTitleView
{
    
    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 44)];
    self.navigationItem.titleView = View;
    
    [View addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.and.centerY.equalTo(View);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(ScreenWidth/2);
        
    }];
    
    
    [self.titleView addSubview:self.myTaskButton];
    CGSize myTaskButtonSize = [self.myTaskButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.myTaskButton.titleLabel.font}];
    
    [self.myTaskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.and.top.equalTo(self.titleView);
        make.centerX.equalTo(self.titleView).offset(-(myTaskButtonSize.width+2)/2-12);
        make.width.mas_equalTo(myTaskButtonSize.width+2);
        
    }];
    
    
    [self.titleView addSubview:self.branchTaskButton];
    [self.branchTaskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.and.top.equalTo(self.titleView);
        make.centerX.equalTo(self.titleView).offset((myTaskButtonSize.width+2)/2+12);
        make.width.mas_equalTo(myTaskButtonSize.width+2);
        
    }];
    
    [self addRightBarButton];
    
}

-(void)addRightBarButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_jia"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(addTask)];
}

-(void)removeRightBarButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)addTask
{
    
    CGPoint point = CGPointMake(ScreenWidth-30, 64);
    XTPopTableView *popView = [[XTPopTableView alloc] initWithOrigin:point Width:150 Height:110 Type:XTTypeOfUpRight Color:[UIColor colorWithRed:0.2737 green:0.2737 blue:0.2737 alpha:1.0]];
    popView.dataArray       = @[@"规划拜访", @"新增任务"];
    popView.images          = @[@"icon_baifan", @"icon_jiarenwu"];
    popView.row_height      = 55;
    popView.delegate        = self;
    popView.titleTextColor  = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [popView popView];
    
}

- (void)selectIndexPathRow:(NSInteger )index
{
    if(index==0)
    {
        MyLog(@"规划拜访");
        
        PlanVisitViewController *web = [PlanVisitViewController new];
        web.urlString = [NSString stringWithFormat:@"%@/%@",[MayiURLManage MayiWebURLManageWithURL:PlanVisit],_selectDateString];
        [web setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:web animated:YES];
        
    }
    else if(index==1)
    {
        MyLog(@"新增任务");
        self.backgroundView.hidden = NO;
    }
    
}






-(void)networkRequest:(NSString *)dateString hud:(BOOL)hud
{
    _selectDateString = dateString;
    
    self.manager.calenderScrollView.noFinishCount = 0;
    self.manager.calenderScrollView.dataSourceArray = [NSMutableArray new];
    self.manager.calenderScrollView.selectDateString = dateString;
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SearchDataQuery] withPrameters:@{@"visitDateQuery":dateString,@"rows":@"100",@"page":@"1"} result:^(id result) {
        
        MyLog(@"%@",result);
        
        NSArray *dataArray = result[@"data"][@"data"];
        NSMutableArray *targetArray = [NSMutableArray new];
        NSString *userID = [MYManage defaultManager].ID;
        for (NSDictionary *item in dataArray) {
            if([item[@"userId"] integerValue] ==[userID integerValue])
            {
                [targetArray addObject:item];
            }
        }
        
        if(targetArray.count>0)
        {
            for (NSDictionary *item in targetArray) {
                if([item[@"status"] integerValue]==1||[item[@"status"] integerValue]==2)
                {
                    self.manager.calenderScrollView.noFinishCount  +=1;
                }
            }
        }
        
        self.manager.calenderScrollView.dataSourceArray = [NSMutableArray arrayWithArray:targetArray];
        [self.manager.calenderScrollView.tableView reloadData];
        
        MyLog(@"%@",self.manager.calenderScrollView.dataSourceArray);
        
        
    } error:^(id error) {
        
    } withHUD:hud];
}


// 新增任务的View
-(void)addNewTaskView
{
    self.backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.backgroundView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    [self.backgroundView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.and.centerY.equalTo(self.backgroundView);
        make.width.mas_equalTo(ScreenWidth-40);
        make.height.mas_equalTo(ScreenHeight/2.3);
        
    }];
    
    UILabel *taskTypeLabel = [UILabel new];
    taskTypeLabel.text = @"任务类型";
    taskTypeLabel.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:taskTypeLabel];
    [taskTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.top.equalTo(contentView).offset(12);
        make.width.mas_equalTo(ScreenWidth/4);
        make.height.mas_equalTo(18);
        
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"icon_guanbi"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton sizeToFit];
    
    [contentView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(contentView).offset(-12);
        make.centerY.equalTo(taskTypeLabel);
        
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor colorWithWhite:230/255.0 alpha:1].CGColor;
    [contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(contentView).multipliedBy(0.5);
        make.height.mas_equalTo(44);
        make.left.equalTo(contentView);
        make.bottom.equalTo(contentView);
        
    }];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.borderWidth = 1;
    confirmButton.layer.borderColor = [UIColor colorWithWhite:230/255.0 alpha:1].CGColor;
    [contentView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(contentView).multipliedBy(0.5);
        make.height.mas_equalTo(44);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        
    }];
    
    UIPickerView *pickerView = [UIPickerView new];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [contentView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).offset(12);
        make.right.equalTo(contentView).offset(-12);
        make.top.equalTo(taskTypeLabel.mas_bottom).offset(10);
        make.bottom.equalTo(confirmButton.mas_top).offset(-10);
        
    }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // 有多少列
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerViewDataSource.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerViewDataSource[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerSelectData = self.pickerViewDataSource[row];
    
    MyLog(@"%@",_pickerSelectData);
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
    return 38;
    
}


-(void)closeButtonAction:(UIButton *)sender
{
    MyLog(@"关闭");
    self.backgroundView.hidden = YES;
}


-(void)confirmButtonAction:(UIButton *)sender
{
    MyLog(@"确定");
    self.backgroundView.hidden = YES;
    
    
    
    
    NSString *taskID;
    
    if([_pickerSelectData isEqualToString:@"婚喜宴检查"])
    {
        taskID = @"7";
    }
    else if([_pickerSelectData isEqualToString:@"品鉴会检查"])
    {
        taskID = @"5";
    }
    else if([_pickerSelectData isEqualToString:@"广告检查"])
    {
        taskID = @"3";
    }
    else if([_pickerSelectData isEqualToString:@"陈列检查"])
    {
        taskID = @"4";
    }
    else if([_pickerSelectData isEqualToString:@"自定义"])
    {
        
        AddTaskViewController *ATVCDIY = [AddTaskViewController new];
        ATVCDIY.urlString = [NSString stringWithFormat:@"%@/%@",[MayiURLManage MayiWebURLManageWithURL:AddDiyTask],_selectDateString];
        ATVCDIY.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ATVCDIY animated:YES];
        return;
    }
    
    AddTaskViewController *ATVC = [AddTaskViewController new];
    ATVC.urlString = [NSString stringWithFormat:@"%@/%@/%@",[MayiURLManage MayiWebURLManageWithURL:TaskPool],taskID,_selectDateString];
    ATVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ATVC animated:YES];
    
    
    
    
}


// 比较日期
- (NSInteger )compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        return -1;
    }
    //刚好时间一样
    return 0;
    
}




//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    
    // 已知问题：上缩时会调用点击方法
    
    // 初始化时会调用两次，把第一次过滤掉
    if(_isFirst)
    {
        _isFirst = NO;
        return;
    }
    
    NSString *key = [[self LTSDateFormatter] stringFromDate:date];
    self.showTimeLabel.text = key;
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    // 判断日期是否在当前时间之前，是的话隐藏 + 号
    self.manager.calenderScrollView.showBeginButton = YES;
    _showBeginButton = YES;
    NSInteger results = [self compareOneDay:[NSDate date] withAnotherDay:date];
    if(results==1)
    {
        // 过期
        [self removeRightBarButton];
    }
    else if (results==-1)
    {
        // 未来
        _showBeginButton = NO;
        self.manager.calenderScrollView.showBeginButton = NO;
        [self addRightBarButton];
    }
    else
    {
        // 今天
        [self addRightBarButton];
    }
    
    [self networkRequest:dateString hud:YES];
    
    
}

- (void)calendarDidLoadPageCurrentDate:(NSDate *)date
{
    NSString *key = [[self LTSDateFormatter] stringFromDate:date];
    self.showTimeLabel.text = key;
   
}


- (NSDateFormatter *)LTSDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy年MM月";
    }
    
    return dateFormatter;
}






@end

