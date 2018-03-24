//
//  FindReceiveOrdersViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/20.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "FindReceiveOrdersViewController.h"
#import "SaoMaShouHuoViewController.h"
#import "DingDanLieBiaoTableViewCell.h"
#import "NSString+DealTimestamp.h"
#define CellID @"cellID"
#define TFHeight 50

@interface FindReceiveOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIButton *searchButton;
@property(nonatomic,strong)NSMutableArray *orderNumberArray;
@property(nonatomic,strong)NSMutableArray *nameArrey;
@property(nonatomic,strong)NSMutableArray *cacheArray;

@end

@implementation FindReceiveOrdersViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self networkRequest];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(ScreenWidth - 100);
        make.centerX.equalTo(self.view).offset(-23);
        make.height.mas_equalTo(TFHeight-16);
        make.top.equalTo(self.view).offset(64+8);
        
    }];
    
    [self.view addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.and.centerY.equalTo(self.textField);
        make.width.mas_equalTo(40);
        make.left.equalTo(self.textField.mas_right).offset(5);
        
    }];
    
    [self.view addSubview:self.tableView];
    

    
}

-(UIButton *)searchButton
{
    if(!_searchButton)
    {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor colorWithWhite:150/255.0 alpha:1] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchButton;
}

-(UITextField *)textField
{
    if(!_textField)
    {
        _textField = [UITextField new];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor blackColor];
        _textField.tintColor = [UIColor redColor];
        _textField.layer.borderColor = [UIColor colorWithWhite:150/255.0 alpha:1].CGColor;
        _textField.layer.borderWidth = 1;
        _textField.layer.cornerRadius = 3;
        NSString *placeholderString = @" 请输入门店名称/编码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:placeholderString];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithWhite:205/255.0 alpha:1]
                            range:NSMakeRange(0, placeholderString.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:18.5]
                            range:NSMakeRange(0, placeholderString.length)];
        _textField.attributedPlaceholder = placeholder;
        
    }
    return _textField;
}


-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + TFHeight, ScreenWidth, ScreenHeight-64-TFHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [_tableView registerClass:[DingDanLieBiaoTableViewCell class] forCellReuseIdentifier:CellID];
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

-(NSMutableArray *)orderNumberArray
{
    if(!_orderNumberArray)
    {
        _orderNumberArray = [NSMutableArray new];
    }
    return _orderNumberArray;
}

-(NSMutableArray *)nameArrey
{
    if(!_nameArrey)
    {
        _nameArrey = [NSMutableArray new];
    }
    return _nameArrey;
}

-(NSMutableArray *)cacheArray
{
    if(!_cacheArray)
    {
        _cacheArray = [NSMutableArray new];
    }
    return _cacheArray;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.dataSource[indexPath.row];
    DingDanLieBiaoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [data[@"customerName"] isEqual:[NSNull null]]?@"":data[@"customerName"];
    NSString *time = data[@"createDatetime"];
    if(time && ![time isEqual:[NSNull null]])
    {
        time = [time dealTimestamp];
    }
    else
    {
        time = @" ";
    }

    cell.timeLabel.text = time;
    cell.orderLabel.text = [NSString stringWithFormat:@"订单编号: %@",data[@"orderSn"]];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
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
    

    prameters = @{@"page":@"1",@"rows":@"100"};
    
    
    // 字典转字符串 并过滤掉空格及换行符
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:prameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:FindReceiveOrders] withPrameters:@{@"query":DicString} result:^(id result) {
    
        if([result[@"data"][@"ok"] integerValue])
        {
            NSArray *targetArray = result[@"data"][@"data"][@"list"];
            
            if(targetArray.count>0)
            {
                self.dataSource = [NSMutableArray arrayWithArray:targetArray];
                self.cacheArray = [NSMutableArray arrayWithArray:targetArray];
            }
        }
        else
        {
            [Hud showText:result[@"data"][@"message"]];
        }
        
        [self.tableView reloadData];
        
    } error:^(id error) {
        
    } withHUD:YES];

}

-(void)searchAction
{
    NSLog(@"搜索:%@",self.textField.text);
    
    [self.dataSource removeAllObjects];
    
    [self.view endEditing:YES];
    
    NSString *key = self.textField.text;
   
    for (int i=0; i<self.cacheArray.count; i++) {
        
        NSDictionary *data = self.cacheArray[i];
        NSString *name = [data[@"customerName"] isEqual:[NSNull null]]?@"":data[@"customerName"];
        NSString *order = data[@"orderSn"];
        if([name containsString:key])
        {
            [self.dataSource addObject:data];
        }
        
        if([order containsString:key])
        {
            [self.dataSource addObject:data];
        }
        
    }
    
    
    [self.tableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
