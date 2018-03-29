//
//  AppDelegate.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/3.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ScheduleViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <UMessage.h>
#import <BuglyHotfix/Bugly.h>
#import <BuglyHotfix/BuglyMender.h>
#import "JPEngine.h"
#import "MessageDetailsWebViewController.h"
#import <CoreLocation/CLLocationManager.h>

#define AMapKey @"c8cb4209d6976cf60837928cf83cab98" // 高德地图 Key
#define UmessageKey @"5a5b752ab27b0a1f0b0003fa"  // 友盟 Key
#define UmessageMasterSecret @"4ryt2ugylzipankz6fqoewxowl8qj765"
#define BuglyKey @"d73bae8b78" // 腾讯Bugly Key

@interface AppDelegate ()<UNUserNotificationCenterDelegate,UIWebViewDelegate,BuglyDelegate>

@property(nonatomic,strong)UITabBarController *tabBarController;
@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 高德地图
    [AMapServices sharedServices].apiKey = AMapKey;
    
    // 配置友盟推送
    [self configureUMessageWithLaunchOptions:launchOptions];
    
    // 配置Bugly
    [self configBugly];
    
    // 检测定位权限
    [self cheackLocation];

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:30/255.0 alpha:1]];

    LoginViewController *LVC = [LoginViewController new];
    UINavigationController *NVC = [[UINavigationController alloc]initWithRootViewController:LVC];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = NVC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self loadWebView];

    [self.window makeKeyAndVisible];
   
    
    
    
    return YES;
}







// 骚需求 预加载webview相关组件
-(void)loadWebView
{
    UIWebView *webView = [UIWebView new];
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:[MayiURLManage MayiWebURLManageWithURL:Message]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
    [webView loadRequest:request];
    [self.window addSubview:webView];
    
}
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    MyLog(@"开始加载");
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
//    [Hud showText:@"webview loading success" withTime:1.0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    MyLog(@"web加载出错：%@",[error localizedDescription]);
    
}









//创建视图控制器
-(void)creatViewControllerView:(UIViewController *)VC andTitle:(NSString *)titleString andImage:(NSString *)image andSelectedImage:(NSString *)selectedImage
{
    
    VC.tabBarItem.title = titleString;
    VC.tabBarItem.image =[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *NVC = [[UINavigationController alloc]initWithRootViewController:VC];
    [_tabBarController addChildViewController:NVC];
    
}




- (void)configureUMessageWithLaunchOptions:(NSDictionary *)launchOptions {
    
    //设置AppKey & LaunchOptions
    [UMessage startWithAppkey:UmessageKey launchOptions:launchOptions];
    
    //推送注册
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;

    //开启log
    [UMessage setLogEnabled:YES];
    //检查是否为iOS 10以上版本
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        
    } else {
        //如果是iOS 10以上版本则必须执行以下操作
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10   completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //这里可以添加一些自己的逻辑
            } else {
                //点击不允许
                //这里可以添加一些自己的逻辑
            }
        }];
        
    }
}






-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //通过identifier对各个交互式的按钮进行业务处理
    [UMessage sendClickReportForRemoteNotification:userInfo];
    
}




// iOS 7之后接收通知 (这是点击通知才会响应的方法)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSString *url = userInfo[@"pathUrl"];
    
    // 当应用在前台时，不推送
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        //关闭对话框
//        [UMessage setAutoAlert:NO];
//        [self goToMessageDetails:url];
        
    }
    [UMessage didReceiveRemoteNotification:userInfo];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    MyLog(@"%@",userInfo);
    
    NSString *url = userInfo[@"pathUrl"];
    MyLog(@"url:%@",url);
    
//    [self goToMessageDetails:url];
    
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;

    NSLog(@"后台括号内：userNotificationCenter:didReceiveNotificationResponse");
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //这个方法用来做action点击的统计
    [UMessage sendClickReportForRemoteNotification:userInfo];
    

    NSString *url = userInfo[@"pathUrl"];
    
//    [self goToMessageDetails:url];
}



//获取device_Token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [UMessage registerDeviceToken:deviceToken];
    NSString *dt = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    MyLog(@"deviceToken:%@",dt);
    // 保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 保存用户偏好设置
    if(dt)
    {
        [defaults setObject:dt forKey:@"deviceToken"];
    }
    else
    {
        [defaults setObject:@" " forKey:@"deviceToken"];
    }
    [defaults synchronize]; // 立刻保存（默认是定时保存）
}



- (void)configBugly {
    //初始化 Bugly 异常上报
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.delegate = self;
    config.debugMode = YES;
    config.reportLogLevel = BuglyLogLevelInfo;
    [Bugly startWithAppId:BuglyKey
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    //捕获 JSPatch 异常并上报
    [JPEngine handleException:^(NSString *msg) {
        NSException *jspatchException = [NSException exceptionWithName:@"Hotfix Exception" reason:msg userInfo:nil];
        [Bugly reportException:jspatchException];
    }];
    //检测补丁策略
    [[BuglyMender sharedMender] checkRemoteConfigWithEventHandler:^(BuglyHotfixEvent event, NSDictionary *patchInfo) {
        //有新补丁或本地补丁状态正常
        if (event == BuglyHotfixEventPatchValid || event == BuglyHotfixEventNewPatch) {
            //获取本地补丁路径
            NSString *patchDirectory = [[BuglyMender sharedMender] patchDirectory];
            if (patchDirectory) {
                //指定执行的 js 脚本文件名
                NSString *patchFileName = @"main.js";
                NSString *patchFile = [patchDirectory stringByAppendingPathComponent:patchFileName];
                //执行补丁加载并上报激活状态
                if ([[NSFileManager defaultManager] fileExistsAtPath:patchFile] &&
                    [JPEngine evaluateScriptWithPath:patchFile] != nil) {
                    BLYLogInfo(@"evaluateScript success");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveSucess];
                }else {
                    BLYLogInfo(@"evaluateScript failed");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveFail];
                }
            }
        }
    }];
}


// 跳转到消息详情
-(void)goToMessageDetails:(NSString *)url
{
    MessageDetailsWebViewController *web = [MessageDetailsWebViewController new];
    web.urlString = [NSString stringWithFormat:@"%@%@",[MayiURLManage MayiWebURLManageWithURL:GetMessage],url];
    web.autoManageBack = NO;
    [web setHidesBottomBarWhenPushed:YES];
    UIViewController *currentVC = [self topViewController];
    [currentVC.navigationController pushViewController:web animated:YES];
}



//获取当前屏幕显示的viewcontroller
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

// 用于第一次获取定位权限，以免在后面出现权限不足导致闪退等问题
-(void)cheackLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) // 用户暂未对定位权限做出选择
    {
        self.locationManager = [CLLocationManager new];
        [self.locationManager requestWhenInUseAuthorization];
    }
}



@end
