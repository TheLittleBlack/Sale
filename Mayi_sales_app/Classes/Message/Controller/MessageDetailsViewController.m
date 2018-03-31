//
//  MessageDetailsViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "MessageDetailsViewController.h"
#import "MessageTopButton.h"
#import "MessageBaseTableViewCell.h"
#import "BaseWebViewController.h"
#import "UITabBar+ShowTip.h"
#import "NSString+DealTimestamp.h"
#import "UITableView+WLEmptyPlaceHolder.h"
#import "MessageDetailsWebViewController.h"
#import "ApplyForViewController.h"
#define CellID @"cellID"

@interface MessageDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIButton *_lastTypeButton;
    UIButton *_lastStateButton;
    CGFloat _animationTime;
    CGFloat _buttonHeight;
    NSInteger _page; // 页
    NSInteger _row; // 行
}

@property(nonatomic,strong)MessageTopButton *topButton;
@property(nonatomic,strong)UIView *selectView;
@property(nonatomic,strong)NSArray *selectData;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIView *typeLine;
@property(nonatomic,strong)UIView *stateLine;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UIView *noDataView; // 没有数据View
@property(nonatomic,assign)NSInteger currentIsRed; // 记录当前消息类型
@property(nonatomic,assign)BOOL showTopTip;
@property(nonatomic,strong)UIButton *allIsReadButton; // 全部已读

@end

@implementation MessageDetailsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _page = 1;
    
    if(self.currentIsRed)
    {
       [self networkRequestisRead:self.currentIsRed isHud:NO];
    }
    else
    {
        [self networkRequestisRead:2 isHud:YES];
        self.currentIsRed = 2;
            
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleText;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.showTopTip = self.type==3&&[MYManage defaultManager].DAIBAN>0?YES:NO;   // 审批事务需要显示
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_suaixuan"] style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
    
    _animationTime = 0.2; // 动画时间
    _buttonHeight = 44;   // 选择按钮的高度
    _page = 1;
    _row = 10;
    
    if(self.showTopTip)
    {
        [self.view addSubview:self.topButton];
        [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
            make.height.mas_equalTo(44);
            
        }];
        
        [self.topButton layoutIfNeeded];
    }

    
    [self.view addSubview:self.tableView];
    
//    self.selectData = @[@"全部",@"日报",@"审批",@"任务",@"公告"];
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(0);
        make.top.mas_equalTo(64);
        
    }];
    
    
    [self.selectView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(_buttonHeight*0.9);
        make.left.equalTo(self.selectView).offset(15);
        make.top.equalTo(self.selectView).offset(0);

    }];

    [self.selectView addSubview:self.typeLine];
    [self.typeLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.selectView).offset(15);
        make.right.equalTo(self.selectView).offset(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.typeLabel.mas_bottom);

    }];
    
    
    CGFloat spacing = 15; // 间隔
    CGFloat buttonWidth = (ScreenWidth - 4*spacing)/3;

    [self.selectView addSubview:self.allIsReadButton];
    [self.allIsReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.selectView).offset(spacing);
        make.width.mas_equalTo(ScreenWidth/2.5);
        make.height.mas_equalTo(_buttonHeight);
        make.top.equalTo(self.typeLine).offset(15);
        
    }];
    
    
    [self.selectView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(ScreenWidth/3);
        make.height.mas_equalTo(_buttonHeight*0.9);
        make.left.equalTo(self.selectView).offset(15);
        make.top.equalTo(self.allIsReadButton.mas_bottom).offset(10);
        
    }];
    
    [self.selectView addSubview:self.stateLine];
    [self.stateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.selectView).offset(15);
        make.right.equalTo(self.selectView).offset(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.stateLabel.mas_bottom);
        
    }];
    
    
    
    
    self.selectData = @[@"全部",@"已读",@"未读"];
    for(int i=0 ; i<3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(buttonWidth+spacing)+spacing, 50 + 115, buttonWidth, _buttonHeight);
        [button setTitle:self.selectData[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor colorWithWhite:150/255.0 alpha:1].CGColor;
        button.layer.borderWidth = 0.8;
        [button addTarget:self action:@selector(stateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:button];
        
        if(i==0)
        {
            _lastStateButton = button;
            [_lastStateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _lastStateButton.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
    
//    self.currentIsRed = 2;
//    [self networkRequestisRead:2];
    
    
}

-(MessageTopButton *)topButton
{
    if(!_topButton)
    {
        _topButton = [MessageTopButton buttonWithType:UIButtonTypeCustom];
        [_topButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _topButton.myTitle.text = [NSString stringWithFormat:@"您有%lu条待办事务，点击查看",[MYManage defaultManager].DAIBAN];
        _topButton.myTitle.textColor = [UIColor whiteColor];
        _topButton.backgroundColor = MyColor(246, 189, 208, 255);
        
    }
    return _topButton;
}

-(UIView *)selectView
{
    if(!_selectView)
    {
        _selectView = [UIView new];
        _selectView.layer.masksToBounds = YES;
        _selectView.backgroundColor = [UIColor whiteColor];
    }
    return _selectView;
}

-(UIButton *)allIsReadButton
{
    if(!_allIsReadButton)
    {
        _allIsReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allIsReadButton setTitle:@"设置全部已读" forState:UIControlStateNormal];
        [_allIsReadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _allIsReadButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _allIsReadButton.backgroundColor = [UIColor whiteColor];
        _allIsReadButton.layer.cornerRadius = 4;
        _allIsReadButton.layer.masksToBounds = YES;
        _allIsReadButton.layer.borderColor = [UIColor colorWithWhite:150/255.0 alpha:1].CGColor;
        _allIsReadButton.layer.borderWidth = 0.8;
        [_allIsReadButton addTarget:self action:@selector(allIsReadButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allIsReadButton;
}

-(void)topButtonAction:(MessageTopButton *)sender
{
    
    
    ApplyForViewController *AFVC = [ApplyForViewController new];
    AFVC.urlString = [MayiURLManage MayiWebURLManageWithURL:CheckApproval];
    [AFVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:AFVC animated:YES];
    
    
//
//    if(self.selectView.My_Height==0)
//    {
//        [UIView animateWithDuration:_animationTime animations:^{
//
//            self.selectView.My_Height = 120;
//
//        }];
//    }
//    else
//    {
//        [UIView animateWithDuration:_animationTime animations:^{
//
//            self.selectView.My_Height = 0;
//
//        }];
//    }
    
}

-(UIView *)typeLine
{
    if(!_typeLine)
    {
        _typeLine = [UIView new];
        _typeLine.backgroundColor = [UIColor colorWithWhite:235/255.0 alpha:1];
    }
    return _typeLine;
}

-(UIView *)stateLine
{
    if(!_stateLine)
    {
        _stateLine = [UIView new];
        _stateLine.backgroundColor = [UIColor colorWithWhite:235/255.0 alpha:1];
    }
    return _stateLine;
}

-(UILabel *)typeLabel
{
    if(!_typeLabel)
    {
        _typeLabel = [UILabel new];
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.textColor = [UIColor blackColor];
        _typeLabel.text = @"编辑";
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

-(UILabel *)stateLabel
{
    if(!_stateLabel)
    {
        _stateLabel = [UILabel new];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.textColor = [UIColor blackColor];
        _stateLabel.text = @"状态";
        _stateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _stateLabel;
}



//-(void)typeButtonAction:(UIButton *)sender
//{
//
//    NSString *type =  self.selectData[sender.tag];
//
//    self.topButton.myTitle.text = type;
//    [self.topButton layoutIfNeeded];
//
//    sender.layer.borderColor = [UIColor redColor].CGColor;
//    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    _lastTypeButton.layer.borderColor = [UIColor colorWithWhite:150/255.0 alpha:1].CGColor;
//    [_lastTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _lastTypeButton = sender;
//
//    [UIView animateWithDuration:_animationTime animations:^{
//
//        self.selectView.My_Height = 0;
//
//    }];
//}

-(void)stateButtonAction:(UIButton *)sender
{
    NSString *type =  self.selectData[sender.tag];
    
    sender.layer.borderColor = [UIColor redColor].CGColor;
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _lastStateButton.layer.borderColor = [UIColor colorWithWhite:150/255.0 alpha:1].CGColor;
    [_lastStateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _lastStateButton = sender;
    
    [UIView animateWithDuration:_animationTime animations:^{
        
        self.selectView.My_Height = 0;
        
    }];
    

    if([type isEqualToString:@"全部"])
    {
        [self networkRequestisRead:2 isHud:YES];
    }
    else if([type isEqualToString:@"已读"])
    {
        [self networkRequestisRead:1 isHud:YES];
    }
    else if([type isEqualToString:@"未读"])
    {
        [self networkRequestisRead:0 isHud:YES];
    }
    
    
}

-(void)networkRequestisRead:(NSInteger )isread isHud:(BOOL)hud
{
    
    self.currentIsRed = isread;
    [self.dataSource removeAllObjects];
    
    NSDictionary *prameters;
    
    if(isread==2) // 全部
    {
        prameters = @{@"page":@(_page),@"rows":@(_row),@"searchType":@(self.type)};
    }
    else
    {
        prameters = @{@"page":@(_page),@"rows":@(_row),@"searchType":@(self.type),@"isRead":@(isread)};
    }
    
    
    
    // 字典转字符串 并过滤掉空格及换行符
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:prameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:MessageList] withPrameters:@{@"query":DicString} result:^(id result) {
        
        NSArray *targetArray = result[@"data"][@"data"][@"records"];
        
        if(_page==1)
        {
            self.dataSource = [NSMutableArray arrayWithArray:targetArray];
            
            if(self.dataSource.count<_row)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else
        {
            [self.dataSource addObjectsFromArray:targetArray];
        }
        
        
        if(isread==2)
        {
            
        
            NSString *saveTime = targetArray.count>0?[self findBestNewMessgaeWithArray:targetArray]:nil;
            
            if(!saveTime)
            {
                return ;
            }
            
            // 取出
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:[MYManage defaultManager].passport]];
            
            // 更新根消息列表的最后时间
            if(self.type==0)
            {
                [userInfo setValue:saveTime forKey:@"GGTZlastTime"];
            }
            else if(self.type==3)
            {
                [userInfo setValue:saveTime forKey:@"SPSWlastTime"];
            }
            else if(self.type==2)
            {
                [userInfo setValue:saveTime forKey:@"GZXXlastTime"];
            }
            else if(self.type==1)
            {
                [userInfo setValue:saveTime forKey:@"ZSFXlastTime"];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:[NSString stringWithFormat:@"%@",[MYManage defaultManager].passport]];
        
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } error:^(id error) {
        
    } withHUD:hud];
    
    
    
}

// 找到最新的消息
-(NSString *)findBestNewMessgaeWithArray:(NSArray *)array
{

        
    NSInteger bestNewTime = 0;
    for (int i = 0; i<array.count; i++) {
        
        NSDictionary *data = array[i];
        NSInteger time = [data[@"createDatetime"] integerValue];
        if(time>bestNewTime)
        {
            bestNewTime = time;
        }
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
        NSDate *today = [[NSDate alloc] init];
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

#pragma mark tableView
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.showTopTip?64+44:64, ScreenWidth, self.showTopTip?ScreenHeight-64-49-44:ScreenHeight-64-49) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1];
        [_tableView registerClass:[MessageBaseTableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    [tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataSource.count];
    
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    MessageBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1];
    cell.iconImageView.image = [UIImage imageNamed:@"icon_gonggao"];
    cell.headerImageView.image = [UIImage imageNamed:@"renwu01"];
    cell.headerTitleLabel.text = self.titleText;
    cell.bodyTextLabel.text = [dic[@"messageText"]isEqual:[NSNull null]]?@" ":[NSString stringWithFormat:@"%@",dic[@"messageText"]];
    // 字间距
    NSDictionary *StringDic = @{NSKernAttributeName:@0.5};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:cell.bodyTextLabel.text attributes:StringDic];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cell.bodyTextLabel.text length])];
    [cell.bodyTextLabel setAttributedText:attributedString];
    
    cell.name.text = [NSString stringWithFormat:@"%@",dic[@"userName"]];
    cell.date.text = [[NSString stringWithFormat:@"%@",dic[@"createDatetime"]] dealTimestampWithMonthDayHoursMinutes];
    cell.isReadView.hidden = NO;
    cell.bodyView.backgroundColor = [UIColor whiteColor];
    if([dic[@"isRead"] integerValue]==1)
    {
        cell.isReadView.hidden = YES;
    }
    if(self.type==3&&![dic[@"isDeal"] isEqual:[NSNull null]] &&[dic[@"isDeal"] intValue]!=1)
    {
        cell.bodyView.backgroundColor = MyColorHex(0xFCF9E3);
    }
    
    // 审批事务需要显示此项
    
    if(self.type==3)
    {
        NSString *dealStr = [dic[@"isDeal"] isEqual:[NSNull null]]?@"0":dic[@"isDeal"];
        NSInteger deal = [dealStr integerValue];
        if(deal==1)
        {
            cell.state.text = @"已审批";
            cell.state.textColor = [UIColor greenColor];
        }
        else
        {
            cell.state.text = @"未审批";
            cell.state.textColor = [UIColor redColor];
        }
    }

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *messageText = [dic[@"messageText"]isEqual:[NSNull null]]?@" ":[NSString stringWithFormat:@"%@",dic[@"messageText"]];
    
    CGSize infoSize = CGSizeMake(ScreenWidth-40, 1000); // 提供一个宽度，高度去自适应
    
    NSDictionary *textAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};

    CGRect textRect = [messageText boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:textAttr context:nil];

    return 128 + textRect.size.height + 25;
    // 25+33+10+50+16+17+15+15
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *data = self.dataSource[indexPath.row];
    
    // 更新状态
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:UpdateMessage] withPrameters:@{@"ids":data[@"id"]} result:^(id result) {
        
        MessageDetailsWebViewController *web = [MessageDetailsWebViewController new];
        web.urlString = [NSString stringWithFormat:@"%@%@",[MayiURLManage MayiWebURLManageWithURL:GetMessage],data[@"url"]];
        web.autoManageBack = NO;
        [web setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:web animated:YES];
        
    } error:^(id error) {
        
    } withHUD:YES];
    
    
    
}


-(void)search:(MessageTopButton *)sender
{
    if(self.selectView.My_Height==0)
    {
        [UIView animateWithDuration:_animationTime animations:^{
            
            self.selectView.My_Height = 120*2;
            
        }];
    }
    else
    {
        [UIView animateWithDuration:_animationTime animations:^{
            
            self.selectView.My_Height = 0;
            
        }];
    }
}


-(UIView *)noDataView
{
    if(!_noDataView)
    {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWidth/2+50, ScreenWidth, ScreenHeight-50-64-49)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (ScreenHeight-50-64-49)/2 - 10, ScreenWidth, 20)];
        label.text = @"暂无消息";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:180/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:label];
        
    }
    return _noDataView;
}

-(void)allIsReadButtonAction
{
    
    [UIView animateWithDuration:_animationTime animations:^{
        
        self.selectView.My_Height = 0;
        
    }];
    
    NSString *noReadIDString = @"";
    
    for (int i=0; i<self.dataSource.count; i++) {
        
        NSDictionary *subData = self.dataSource[i];
        if([subData[@"isRead"] integerValue]==0) // 收集所有未读消息的ID
        {
            noReadIDString = [NSString stringWithFormat:@"%@,%@",noReadIDString,subData[@"id"]];
        }
        
    }
    
    if(noReadIDString.length>0) // 存在未读消息时
    {
        // 更新状态
        [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:UpdateMessage] withPrameters:@{@"ids":noReadIDString} result:^(id result) {

            [self networkRequestisRead:2 isHud:YES];
            
        } error:^(id error) {
            
        } withHUD:YES];
    }
    

    
}

-(void)footerRefresh
{
    NSLog(@"上拉加载");
    
    _page ++;
    
    if(self.currentIsRed)
    {
        [self networkRequestisRead:self.currentIsRed isHud:NO];
    }
    else
    {
        [self networkRequestisRead:2 isHud:YES];
        self.currentIsRed = 2;
        
    }
    
    
}

@end
