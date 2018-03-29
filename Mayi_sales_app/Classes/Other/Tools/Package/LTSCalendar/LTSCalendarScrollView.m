//
//  LTSCalendarScrollView.m
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import "LTSCalendarScrollView.h"
#import "ScheduleTableViewCell.h"
#import "ScheduleTableViewHeaderView.h"
#import "BaseWebViewController.h"
#import "TeamManageVisitViewController.h"
#import "CustomerVisitViewController.h"
#import "SignInViewController.h"
#import "UITableView+WLEmptyPlaceHolder.h"
#define CellID @"cellID"
#define CellHeader @"cellHeader"



@interface LTSCalendarScrollView()<UITableViewDelegate,UITableViewDataSource,ScheduleTableViewCellDelegate>

@property (nonatomic,strong)UIView *line;
@property(nonatomic,strong)UIView *noDataView; // 没有数据View

@end
@implementation LTSCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
        
        _showBeginButton = YES;
        
        NSString *dateString;
        _selectDateString = @" ";
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
        
    }
    return self;
}
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}

- (void)initUI{
    
    
    
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    self.backgroundColor = [LTSCalendarAppearance share].scrollBgcolor;
    LTSCalendarContentView *calendarView = [[LTSCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, [LTSCalendarAppearance share].weekDayHeight*[LTSCalendarAppearance share].weeksToDisplay)];
    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame),0.5)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame)) style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollEnabled = [LTSCalendarAppearance share].isShowSingleWeek;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ScheduleTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:CellHeader];
    [self.tableView registerClass:[ScheduleTableViewCell class] forCellReuseIdentifier:CellID];
    
    [self addSubview:self.tableView];
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [LTSCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
    [self.tableView addSubview:self.noDataView];
    
}

-(UIView *)noDataView
{
    if(!_noDataView)
    {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 20)];
        label.text = @"你还没有添加日程";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:180/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:label];
        
    }
    return _noDataView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    [tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataSourceArray.count];
    if(self.dataSourceArray.count==0)
    {
        self.noDataView.hidden = NO;
    }
    else
    {
        self.noDataView.hidden = YES;
    }
    return  self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    if(self.dataSourceArray.count>0)
    {
        NSDictionary *itemData = self.dataSourceArray[indexPath.row];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.visitID = itemData[@"id"];
        cell.rightButton.hidden = NO;
        cell.businessKey = ![itemData[@"businessKey"] isEqual:[NSNull null]]?[itemData[@"businessKey"] integerValue]:0;
        cell.type = ![itemData[@"businessType"] isEqual:[NSNull null]]?[itemData[@"businessType"] integerValue]:1;
        NSString *storeName = itemData[@"storeName"];
        if(![storeName isEqual:[NSNull null]])
        {
            cell.myTitleLabel.text = storeName;
            cell.storeName = storeName;
        }
        NSString *storeAddress = itemData[@"storeAddress"];
        if(![storeAddress isEqual:[NSNull null]])
        {
            cell.myDescribeLabel.text = storeAddress;
        }
        NSInteger status = [itemData[@"status"] integerValue];
        if(status==2)
        {
            [cell.rightButton setTitle:@"继续" forState:UIControlStateNormal];
            [cell.rightButton setTitleColor:MainColor forState:UIControlStateNormal];
            cell.rightButton.backgroundColor = [UIColor whiteColor];
            cell.rightButton.layer.borderColor = MainColor.CGColor;
            cell.finishImageView.hidden = YES;
        }
        else if(status==1)
        {
            [cell.rightButton setTitle:@"开始" forState:UIControlStateNormal];
            [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.rightButton.backgroundColor = MainColor;
            cell.rightButton.layer.borderColor = MainColor.CGColor;
            cell.finishImageView.hidden = YES;
            cell.rightButton.hidden = !_showBeginButton;
            
        }
        else if (status==3)
        {
            [cell.rightButton setTitle:@" " forState:UIControlStateNormal];
            [cell.rightButton setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1] forState:UIControlStateNormal];
            cell.rightButton.backgroundColor = [UIColor whiteColor];
            cell.rightButton.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.finishImageView.hidden = NO;
        }
        
        NSInteger type = [itemData[@"businessType"] integerValue];
        
        if(type==1)
        {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_dian3"];
        }
        else if (type==2)
        {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_huifang 3"];
        }
        else if (type==3) // 广告
        {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_jiancha"];
            cell.rightButton.hidden = NO;
//            cell.finishImageView.hidden = YES;
        }
        else if (type==4) // 陈列
        {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_jiancha"];
            cell.rightButton.hidden = NO;
//            cell.finishImageView.hidden = YES;
        }
        else if(type==5) // 品鉴
        {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_jiancha"];
            cell.rightButton.hidden = NO;
//            cell.finishImageView.hidden = YES;
        }
        else if(type==6) // 自定义
        {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_jiancha"];
            cell.rightButton.hidden = NO;
//            cell.finishImageView.hidden = YES;
        }
        else if(type==7) // 婚喜宴
        {
            cell.iconImageView.image = [UIImage imageNamed:@"icon_hunyan 3"];
            cell.rightButton.hidden = NO;
//            cell.finishImageView.hidden = YES;
        }
        
        
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataSourceArray.count<1)
    {
        return;
    }
    NSDictionary *itemData = self.dataSourceArray[indexPath.row];
    NSInteger status = [itemData[@"status"] integerValue];
    NSInteger type = [itemData[@"businessType"] integerValue];
    NSInteger businessKey = ![itemData[@"businessKey"] isEqual:[NSNull null]]?[itemData[@"businessKey"] integerValue]:0;
    
    if(status==3)
    {
        
        
        if(type==3 ||type==4 ||type==5 ||type==7 )
        {
            BaseWebViewController *BWVC = [BaseWebViewController new];
            BWVC.urlString = [NSString stringWithFormat:@"%@/%@",[MayiURLManage MayiWebURLManageWithURL:TaskCheck],@(businessKey)];
            BWVC.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:BWVC animated:YES];
            return ;
            
        }
        
        
        BaseWebViewController *BWVC = [BaseWebViewController new];
        BWVC.urlString = [NSString stringWithFormat:@"%@%@&0",[MayiURLManage MayiWebURLManageWithURL:VisitDetails],itemData[@"id"]];
        BWVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:BWVC animated:YES];
        
        
        

        
        
        
        
        
        return;
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ScheduleTableViewHeaderView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:CellHeader];
    header.contentView.backgroundColor = [UIColor whiteColor];
    if(self.dataSourceArray.count>0)
    {
        header.firstLabel.text = [NSString stringWithFormat:@"共有%lu个日程",self.dataSourceArray.count];
        if(_noFinishCount>0)
        {
            header.secondLabel.text = [NSString stringWithFormat:@"(未完成%lu个)",_noFinishCount];
        }
        
    }
    else
    {
        header.firstLabel.text = [NSString stringWithFormat:@"共有0个日程"];
        header.secondLabel.text = [NSString stringWithFormat:@"(未完成0个)"];
    }
    header.dateLabel.text = [NSString stringWithFormat:@"%@",_selectDateString];
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (scrollView != self) {
        return;
    }
  
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    self.calendarView.maskView.hidden = false;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
         self.tableView.scrollEnabled = true;
        self.calendarView.maskView.hidden = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        
        self.tableView.scrollEnabled = false;
        if ([LTSCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)+offsetY - 49;
    self.tableView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame) - 49;
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
    
    
    
    
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}
//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [self.calendarView setUpVisualRegion];
}


- (void)scrollToSingleWeek{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
    
    
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[LTSCalendarAppearance share].weekDayHeight*([LTSCalendarAppearance share].weeksToDisplay-1));
}


-(void)CellRightButtonAction:(UIButton *)sender andSelectID:(NSString *)visitID andBusinessKey:(NSInteger)businessKey andType:(NSInteger)type andStoreName:(NSString *)storeName
{
    
    
    if(type==3 ||type==4 ||type==5 ||type==7 )
    {
        BaseWebViewController *BWVC = [BaseWebViewController new];
        BWVC.urlString = [NSString stringWithFormat:@"%@/%@",[MayiURLManage MayiWebURLManageWithURL:TaskCheck],@(businessKey)];
        BWVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:BWVC animated:YES];
        return;
    }
    
    // 自定义特殊跳转
    if(type==6)
    {
        BaseWebViewController *BWVC = [BaseWebViewController new];
        BWVC.urlString = [NSString stringWithFormat:@"%@/%@",[MayiURLManage MayiWebURLManageWithURL:CustomTask],@(businessKey)];
        BWVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:BWVC animated:YES];
        
        NSLog(@"自定义特殊跳转");
        return;
    }
    
    
    
    
    
    
    if([sender.titleLabel.text isEqualToString:@"继续"])
    {
        MyLog(@"继续");
        
        // 判断哪种类型
        if(type==2) // 政商客户类型 拼接上businessKey跳转到webview
        {
            TeamManageVisitViewController *TMVVC = [TeamManageVisitViewController new];
            TMVVC.urlString = [NSString stringWithFormat:@"%@/%lu",[MayiURLManage MayiWebURLManageWithURL:TeamVisit],businessKey];
            TMVVC.businessKey = businessKey;
            TMVVC.visitID = visitID;
            TMVVC.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:TMVVC animated:YES];
        }
        else // 其他类型
        {
            [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:TakeOutVisitInformation] withPrameters:@{@"visitId":visitID} result:^(id result) {
                
                CustomerVisitViewController *CVVC = [CustomerVisitViewController new];
                CVVC.visitData = result[@"data"][@"data"];
                CVVC.visitID = visitID;
                CVVC.hidesBottomBarWhenPushed = YES;
                [self.currentVC.navigationController pushViewController:CVVC animated:YES];
                
            } error:^(id error) {
                
            } withHUD:YES];
        }
        
        
        
        
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"开始"])
    {
        MyLog(@"开始");
        
        
        [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:CheckoutVisit] withPrameters:@{} result:^(id result) {
            
            if([result[@"data"][@"ok"] integerValue] !=0)
            {
                NSArray *array = result[@"data"][@"data"];
                if(array.count>0)
                {
                    
                    NSDictionary *data = array[0];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有任务尚未结束" message:@"是否前往？" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                        
                        
                        // 判断哪种类型
                        if([data[@"businessType"] integerValue]==2) // 政商客户类型 拼接上businessKey跳转到webview
                        {
                            TeamManageVisitViewController *TMVVC = [TeamManageVisitViewController new];
                            TMVVC.urlString = [NSString stringWithFormat:@"%@/%lu",[MayiURLManage MayiWebURLManageWithURL:TeamVisit],[data[@"businessKey"] integerValue]];
                            TMVVC.businessKey = [data[@"businessKey"] integerValue];
                            TMVVC.visitID = data[@"id"];
                            TMVVC.hidesBottomBarWhenPushed = YES;
                            [self.currentVC.navigationController pushViewController:TMVVC animated:YES];
                        }
                        else // 其他类型
                        {
                            
                            [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:TakeOutVisitInformation] withPrameters:@{@"visitId":data[@"id"]} result:^(id subResult) {
                                
                                CustomerVisitViewController *CVVC = [CustomerVisitViewController new];
                                CVVC.visitData = subResult[@"data"][@"data"];
                                CVVC.visitID = subResult[@"data"][@"data"][@"id"];
                                CVVC.hidesBottomBarWhenPushed = YES;
                                [self.currentVC.navigationController pushViewController:CVVC animated:YES];
                                
                            } error:^(id error) {
                                
                            } withHUD:YES];
                        }
                        
                        
                        
                    }]];
                    
                    
                    // 为了不产生延时的现象，直接放在主线程中调用
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.currentVC presentViewController:alert animated:YES completion:^{
                        }];
                        
                    });
                    
                    
                }
                
            }
            else
            {
                
                SignInViewController *SVC = [SignInViewController new];
                SVC.visitID = visitID;
                SVC.type = type;
                SVC.businessKey = businessKey;
                SVC.isFirst = YES;
                SVC.storeName = storeName;
                [SVC setHidesBottomBarWhenPushed:YES];
                [self.currentVC.navigationController pushViewController:SVC animated:YES];
                
                
            }
            
        } error:^(id error) {
            
        } withHUD:YES];
        
        
        
        
    }
    else if([sender.titleLabel.text isEqualToString:@" "])
    {
        MyLog(@"已完成");
        
        
        BaseWebViewController *BWVC = [BaseWebViewController new];
        BWVC.urlString = [NSString stringWithFormat:@"%@%@&0",[MayiURLManage MayiWebURLManageWithURL:VisitDetails],visitID];
        BWVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:BWVC animated:YES];
        
        
    }
    
    
}






@end
