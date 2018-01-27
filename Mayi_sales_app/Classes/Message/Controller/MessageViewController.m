//
//  MessageViewController.m
//  KingsLuck
//
//  Created by JayJay on 2017/12/3.
//  Copyright © 2017年 JayJay. All rights reserved.
//




#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageDetailsViewController.h"
#import "UITabBar+ShowTip.h"
#import "NSString+DealTimestamp.h"
#define CellID @"cellID"

@interface MessageViewController () <UITableViewDelegate,UITableViewDataSource>

{
    NSInteger noticeNum ;
    NSInteger shareNum ;
    NSInteger daibanNum ;
    NSInteger examineNum ;
    NSInteger workNum ;
    
    NSString *_NOTICE_DATE;  //公告消息
    NSString *_EXAMINE_DATE; //审批消息
    NSString *_SHARE_DATE;  //知识分享
    NSString *_WORK_DATE;  //工作消息

    
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self updateMessageState];
    
    self.navigationController.navigationBar.hidden = NO;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
    
    
}



-(void)updateMessageState
{
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:UnreadMessageStatistics] withPrameters:@{} result:^(id result) {
        
        if([result[@"data"][@"data"][@"TOTAL"] integerValue]>0)
        {
            // 让消息界面显示小红点
            [self.tabBarController.tabBar showBadgeOnItemIndex:1];
            
        }
        
        [MYManage defaultManager].NOTICE = [result[@"data"][@"data"][@"NOTICE"] integerValue];
        [MYManage defaultManager].SHARE = [result[@"data"][@"data"][@"SHARE"] integerValue];
        [MYManage defaultManager].DAIBAN = [result[@"data"][@"data"][@"DAIBAN"] integerValue];
        [MYManage defaultManager].EXAMINE = [result[@"data"][@"data"][@"EXAMINE"] integerValue];
        [MYManage defaultManager].WORK = [result[@"data"][@"data"][@"WORK"] integerValue];
        
        NSInteger NOTICE_DATE = [result[@"data"][@"data"][@"NOTICE_DATE"] integerValue];  //公告消息
        NSInteger EXAMINE_DATE = [result[@"data"][@"data"][@"EXAMINE_DATE"] integerValue]; //审批消息
        NSInteger SHARE_DATE = [result[@"data"][@"data"][@"SHARE_DATE"] integerValue];  //知识分享
        NSInteger WORK_DATE = [result[@"data"][@"data"][@"WORK_DATE"] integerValue];  //工作消息
        
        _NOTICE_DATE = [self getMessgaeWithTime:NOTICE_DATE];
        _EXAMINE_DATE = [self getMessgaeWithTime:EXAMINE_DATE];
        _SHARE_DATE = [self getMessgaeWithTime:SHARE_DATE];
        _WORK_DATE = [self getMessgaeWithTime:WORK_DATE];
        
       [self getMessgaeNumber];
        
    } error:^(id error) {
        
    } withHUD:NO];
}




-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [_tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;
        
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        NSArray *array = @[
                           @{@"icon":@"icon_shenpi",@"title":@"公告通知"},
                           @{@"icon":@"icon_xianlu",@"title":@"审批事务"},
                           @{@"icon":@"icon_dindan",@"title":@"知识分享"},
                           @{@"icon":@"icon_tuanguo",@"title":@"工作消息"}
                           ];
        
        _dataSource = [NSMutableArray arrayWithArray:array];
    }
    return _dataSource;
}

-(void)getMessgaeNumber
{
     noticeNum = [MYManage defaultManager].NOTICE;
     shareNum = [MYManage defaultManager].SHARE;
     daibanNum = [MYManage defaultManager].DAIBAN;
     examineNum = [MYManage defaultManager].EXAMINE;
     workNum = [MYManage defaultManager].WORK;
    
    if(noticeNum+shareNum+examineNum+workNum==0)
    {
        // 移除小红点
        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *data = self.dataSource[indexPath.section];
    MessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:data[@"icon"]];
    cell.myTitleLabel.text = data[@"title"];
    cell.tagLabel.text = @"";
    cell.tagLabel.hidden = YES;
    [cell.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(cell).offset(-18);
        make.centerY.equalTo(cell);
        make.width.mas_equalTo(ScreenWidth/4);
        
    }];
    
    [cell.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.mas_equalTo(22);
        make.right.equalTo(cell).offset(-20);
        make.centerY.equalTo(cell);
        
    }];
    
    // 暂时弃用
//    NSMutableDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:[MYManage defaultManager].passport];
//    userInfo[@"GGTZlastTime"];
//    userInfo[@"SPSWlastTime"];
//    userInfo[@"ZSFXlastTime"];
//    userInfo[@"GZXXlastTime"];
    
    if(indexPath.section==0)
    {
        NSString *time = [_NOTICE_DATE isEqualToString:@""]?nil:_NOTICE_DATE;
        cell.timeLabel.text = time?time:@"";
        cell.timeLabel.textColor = time?[UIColor blackColor]:[UIColor whiteColor];

        if(noticeNum>0) // 公告通知
        {
            cell.tagLabel.text = [NSString stringWithFormat:@"%lu",noticeNum];
            cell.tagLabel.hidden = NO;

            CGSize timeLabelSize = [cell.timeLabel.text sizeWithAttributes:@{NSFontAttributeName : cell.timeLabel.font}];
            [cell.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.right.equalTo(cell).offset(-18);
                make.centerY.equalTo(cell).offset(-(timeLabelSize.height/2+5));
                make.width.mas_equalTo(ScreenWidth/4);

            }];

            if(![time isEqualToString:@""])
            {
                [cell.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.and.height.mas_equalTo(22);
                    make.right.equalTo(cell).offset(-20);
                    make.centerY.equalTo(cell).offset((timeLabelSize.height/2+5));
                    
                }];
            }

        }
    }
    else if(indexPath.section==1)
    {
        NSString *time = [_EXAMINE_DATE isEqualToString:@""]?nil:_EXAMINE_DATE;
        cell.timeLabel.text = time?time:@"";
        cell.timeLabel.textColor = time?[UIColor blackColor]:[UIColor whiteColor];
        
        if(examineNum>0) // 审批事务
        {
            cell.tagLabel.text = [NSString stringWithFormat:@"%lu",examineNum];
            cell.tagLabel.hidden = NO;
            
            CGSize timeLabelSize = [cell.timeLabel.text sizeWithAttributes:@{NSFontAttributeName : cell.timeLabel.font}];
            [cell.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.right.equalTo(cell).offset(-18);
                make.centerY.equalTo(cell).offset(-(timeLabelSize.height/2+5));
                make.width.mas_equalTo(ScreenWidth/4);

            }];
            
            if(![time isEqualToString:@""])
            {
                [cell.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

                    make.width.and.height.mas_equalTo(22);
                    make.right.equalTo(cell).offset(-20);
                    make.centerY.equalTo(cell).offset((timeLabelSize.height/2+5));

                }];
            }
            

        }
    }
    else if(indexPath.section==2)
    {
        NSString *time = [_SHARE_DATE isEqualToString:@""]?nil:_SHARE_DATE;
        cell.timeLabel.text = time?time:@"";
        cell.timeLabel.textColor = time?[UIColor blackColor]:[UIColor whiteColor];
        if(shareNum>0) // 知识分享
        {
            cell.tagLabel.text = [NSString stringWithFormat:@"%lu",shareNum];
            cell.tagLabel.hidden = NO;

            CGSize timeLabelSize = [cell.timeLabel.text sizeWithAttributes:@{NSFontAttributeName : cell.timeLabel.font}];
            [cell.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.right.equalTo(cell).offset(-18);
                make.centerY.equalTo(cell).offset(-(timeLabelSize.height/2+5));
                make.width.mas_equalTo(ScreenWidth/4);

            }];
            
            if(![time isEqualToString:@""])
            {
                [cell.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.and.height.mas_equalTo(22);
                    make.right.equalTo(cell).offset(-20);
                    make.centerY.equalTo(cell).offset((timeLabelSize.height/2+5));
                    
                }];
            }
        }
    }
    else if(indexPath.section==3)
    {
        NSString *time = [_WORK_DATE isEqualToString:@""]?nil:_WORK_DATE;
        cell.timeLabel.text = time?time:@"";
        cell.timeLabel.textColor = time?[UIColor blackColor]:[UIColor whiteColor];
        if(workNum>0) // 工作消息
        {
            cell.tagLabel.text = [NSString stringWithFormat:@"%lu",workNum];
            cell.tagLabel.hidden = NO;

            CGSize timeLabelSize = [cell.timeLabel.text sizeWithAttributes:@{NSFontAttributeName : cell.timeLabel.font}];
            [cell.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

                make.right.equalTo(cell).offset(-18);
                make.centerY.equalTo(cell).offset(-(timeLabelSize.height/2+5));
                make.width.mas_equalTo(ScreenWidth/4);

            }];

            if(![time isEqualToString:@""])
            {
                [cell.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.and.height.mas_equalTo(22);
                    make.right.equalTo(cell).offset(-20);
                    make.centerY.equalTo(cell).offset((timeLabelSize.height/2+5));
                    
                }];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageDetailsViewController *MDVC = [MessageDetailsViewController new];
    MDVC.titleText = self.dataSource[indexPath.section][@"title"];
    
    
    if(indexPath.section==0) // 公告通知
    {
        MDVC.type = 0;
    }
    else if(indexPath.section==1) // 审批事务
    {
        MDVC.type = 3;
    }
    else if(indexPath.section==2) // 知识分享
    {
        MDVC.type = 1;
    }
    else if(indexPath.section==3) // 工作消息
    {
        MDVC.type = 4;
    }
    
    [self.navigationController pushViewController:MDVC animated:YES];
    
}




// 返回
-(NSString *)getMessgaeWithTime:(NSInteger )bestNewTime
{
    
    if(bestNewTime==0)
    {
        return @"";
    }
    
    // 获取到最新的时间
    
    if([self compareWithDay:bestNewTime]==1) // 非昨天的过去时间
    {
        return [[NSString stringWithFormat:@"%lu",bestNewTime] dealTimestampWithMonthDate]; // 显示月日
    }
    else if ([self compareWithDay:bestNewTime]==2) // 昨天
    {
        return @"昨天";
    }
    
    return [[NSString stringWithFormat:@"%lu",bestNewTime] dealTimestampWithHoursMinutes]; // 显示时间时分
    
    
}



// 输入一个时间戳与今天的日期比较
- (NSInteger )compareWithDay:(NSInteger)timeString
{
    NSDate *anotherDay = [NSDate dateWithTimeIntervalSince1970:timeString/1000];
    MyLog(@"%lu",timeString);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        
        // 判断日否是昨天
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSInteger todayTimeInterval = [self getZeroWithToDay];
        NSDate *today = [NSDate dateWithTimeIntervalSince1970:todayTimeInterval];
        NSDate *yesterday;
        
        yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
        
        // 10 first characters of description is the calendar date:
        NSString * yesterdayString = [[yesterday description] substringToIndex:10];
        
        NSString * dateString = [[anotherDay description] substringToIndex:10];
        
        if ([dateString isEqualToString:yesterdayString])
        {
            return 2;  // 昨天
        }
        
        return 1;  // 非昨天的过去时间
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        return -1;
    }
    //刚好时间一样
    return 0;
    
}



// 获取今天0点的时间戳
- (NSTimeInterval)getZeroWithToDay
{
    NSDate *originalDate = [NSDate date];
    NSDateFormatter *dateFomater = [[NSDateFormatter alloc]init];
    dateFomater.dateFormat = @"yyyy年MM月dd日";
    NSString *original = [dateFomater stringFromDate:originalDate];
    NSDate *ZeroDate = [dateFomater dateFromString:original];
    return [ZeroDate timeIntervalSince1970] + 28800; // 因为时间差加8小时
}




























@end
