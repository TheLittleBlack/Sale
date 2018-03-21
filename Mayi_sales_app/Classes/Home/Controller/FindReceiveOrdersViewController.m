//
//  FindReceiveOrdersViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/20.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "FindReceiveOrdersViewController.h"
#import "SaoMaShouHuoViewController.h"
#define CellID @"cellID"

@interface FindReceiveOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation FindReceiveOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self networkRequest];
    
    [self.view addSubview:self.tableView];
    

    
}


-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;
        
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
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataSource[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = data[@"orderSn"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
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
    SaoMaShouHuoViewController *SMSHVC = [SaoMaShouHuoViewController new];
    NSDictionary *data = self.dataSource[indexPath.row];
    SMSHVC.data = data;
    [self.navigationController pushViewController:SMSHVC animated:YES];
    
}

-(void)networkRequest
{
    
    
    [self.dataSource removeAllObjects];
    
    NSDictionary *prameters;
    

    prameters = @{@"page":@"1",@"rows":@"50"};
    
    
    // 字典转字符串 并过滤掉空格及换行符
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:prameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:FindReceiveOrders] withPrameters:@{@"query":DicString} result:^(id result) {
        
        NSArray *targetArray = result[@"data"][@"data"][@"list"];
        NSLog(@"=============================%@=====================================",targetArray);
        self.dataSource = [NSMutableArray arrayWithArray:targetArray];
        
        [self.tableView reloadData];
        
    } error:^(id error) {
        
    } withHUD:YES];

}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
