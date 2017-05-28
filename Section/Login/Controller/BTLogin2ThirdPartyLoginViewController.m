//
//  BTLogin2ThirdPartyLoginViewController.m
//  第三方登录注册（Wechat, Sina, Tencent）
//
//  Created by Carroll on 16/3/30.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2ThirdPartyLoginViewController.h"
#import "BTWeiboOauthViewController.h"
#import "BTNavigationViewController.h"
#import "BTLogin2RequestAPI.h"
#import "BTHelper.h"
#import "BTNoticeShowManager.h"
#import "BTLogin2UserNameSettingViewController.h"
#import "AppDelegate.h"
#import "BTUserInfo.h"
#import "BTLogin2ViewController.h"
#import "BTNoticeShowManager.h"

#import "BTSubModuleRootViewController.h"
#import "BTTabBarViewController.h"
#import "BTRunloopManager.h"

@interface BTLogin2ThirdPartyLoginViewController ()
<
TencentSessionDelegate, 
WeiboOauthWebDelegate, 
WeiboSDKDelegate, 
WXApiDelegate
>

@property (nonatomic, strong) UILabel *thirdPartyLoginTipsLable;

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *weiboButton;

@end

@implementation BTLogin2ThirdPartyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isSetStatusBarStyleLight = YES;
    AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    delegate.delegate = self;
}

- (void)configureView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.thirdPartyLoginTipsLable = UILabel.new;
    self.thirdPartyLoginTipsLable.font = [UIFont systemFontOfSize:12];
    self.thirdPartyLoginTipsLable.textColor = Common_Gray_Color;
    
    self.leftLineView = UIView.new;
    self.leftLineView.backgroundColor = Common_Gray_Color;
    
    self.rightLineView = UIView.new;
    self.rightLineView.backgroundColor = Common_Gray_Color;
    
    self.wechatButton = UIButton.new;
    [self.wechatButton setImage:[UIImage imageNamed:@"icon_wechat.png"] forState:UIControlStateNormal];
    [self.wechatButton addTarget:self action:@selector(didTapWechatButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatButton setContentMode:UIViewContentModeCenter];
    [self.wechatButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    self.qqButton = UIButton.new;
    [self.qqButton addTarget:self action:@selector(didTapQQButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqButton setImage:[UIImage imageNamed:@"icon_tencent_qq.png"] forState:UIControlStateNormal];
    [self.qqButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

    self.weiboButton = UIButton.new;
    [self.weiboButton setImage:[UIImage imageNamed:@"icon_sina_weibo.png"] forState:UIControlStateNormal];
    [self.weiboButton addTarget:self action:@selector(didTapWeiboButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.weiboButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

    [self addsubViews];
    [self checkThirdPartyIsInstalled];
}

- (void)addsubViews
{
    [self.view addSubview:self.thirdPartyLoginTipsLable];
    [self.view addSubview:self.leftLineView];
    [self.view addSubview:self.rightLineView];
    
    [self.view addSubview:self.qqButton];
    [self.view addSubview:self.wechatButton];
    [self.view addSubview:self.weiboButton];
    
    [self.thirdPartyLoginTipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirdPartyLoginTipsLable);
        make.left.equalTo(self.view);
        make.right.equalTo(self.thirdPartyLoginTipsLable.mas_left).offset(-16/2);
        make.height.equalTo(@0.8);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirdPartyLoginTipsLable);
        make.left.equalTo(self.thirdPartyLoginTipsLable.mas_right).offset(16/2);
        make.right.equalTo(self.view);
        make.height.equalTo(@0.8);
    }];
    
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@41);
        make.height.equalTo(@45);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.thirdPartyLoginTipsLable.mas_bottom).offset(42/2);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@46);
        make.height.equalTo(@42);
        make.right.equalTo(self.qqButton.mas_left).offset(-70/2);
        make.centerY.equalTo(self.qqButton);
    }];
    
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@55);
        make.height.equalTo(@41);
        make.left.equalTo(self.qqButton.mas_right).offset(70/2);
        make.centerY.equalTo(self.qqButton);
    }];
}

#pragma mark -

- (void)checkThirdPartyIsInstalled
{
    self.wechatButton.hidden = ![WXApi isWXAppInstalled];
    self.qqButton.hidden = ![TencentOAuth iphoneQQInstalled];
    self.weiboButton.hidden = ![WeiboSDK isWeiboAppInstalled];
    
    if (self.qqButton.hidden) {
        [self.wechatButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
        }];
    }
    
    if (self.wechatButton.hidden) {
        [self.qqButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
        }];
    }
    
    if (self.qqButton.hidden && self.wechatButton.hidden) {
        [self.weiboButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
        }];
    }
    
    if (self.qqButton.hidden && self.wechatButton.hidden && self.weiboButton.hidden) {
        self.view.hidden = YES;
    }
    
}

#pragma mark - UIButtonDelegate

- (void)didTapWechatButton:(UIButton *)button
{
    // 统计第三方登录
    BTMobClickModule *module = [[BTMobClickModule alloc] init];
    module.el = @"微信";
    [[BTMobClick shareInstance] clickEventType:@"sns_login" module:module];


    [BTHelper showHttpRequestLoadingOnController:self.view];
    SendAuthReq *request = [[SendAuthReq alloc]init];
    request.scope = @"snsapi_userinfo";
    request.state = @"123";
    
    [WXApi sendReq:request];
    
}

- (void)didTapQQButton:(UIButton *)button
{
    // 统计第三方登录
    BTMobClickModule *module = [[BTMobClickModule alloc] init];
    module.el = @"QQ";
    [[BTMobClick shareInstance] clickEventType:@"sns_login" module:module];

    [BTHelper showHttpRequestLoadingOnController:self.view];
    BOOL installed = [TencentOAuth iphoneQQInstalled];

    _tencentOauth = [[TencentOAuth alloc]initWithAppId:@"101166421" andDelegate:self];
    _permission = [NSArray arrayWithObjects:@"get_user_info",@"add_share", @"get_simple_userinfo", nil];
     [_tencentOauth authorize:_permission inSafari:!installed];
}

-(void)didTapWeiboButton:(UIButton *)button
{
    BTMobClickModule *module = [[BTMobClickModule alloc] init];
    module.el = @"微博";
    [[BTMobClick shareInstance] clickEventType:@"sns_login" module:module];

    if([WeiboSDK isWeiboAppInstalled]){
        [BTHelper showHttpRequestLoadingOnController:self.view];
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.shouldShowWebViewForAuthIfCannotSSO = YES;
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        request.userInfo = nil;
        [WeiboSDK sendRequest:request];
    }
    else {
        BTWeiboOauthViewController *controller = [[BTWeiboOauthViewController alloc]initWithNibName:NSStringFromClass([BTWebViewController class]) bundle:nil];
        BTNavigationViewController *nav = [[BTNavigationViewController alloc]initWithRootViewController:controller];
        controller.urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=3106029322&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html&t=%d",(int)[NSDate date].timeIntervalSince1970];
        controller.delegate = self;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 微博

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    WBProvideMessageForWeiboResponse *response = [WBProvideMessageForWeiboResponse responseWithMessage:nil];
    [WeiboSDK sendResponse:response];
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    switch (response.statusCode) {
            
        case WeiboSDKResponseStatusCodeSuccess:
        {
            NSString *platform = @"weibo";
            NSString *uid = [(WBAuthorizeResponse *)response userID];
            NSString *token = [(WBAuthorizeResponse *)response accessToken];
            NSDictionary *params = @{ @"access_token": token, @"uid": uid};
            
            [[AFHTTPRequestOperationManager manager] GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self loginWithPlatform:platform Token:token UID:uid Nickname:responseObject[@"name"] AvatarUrl:responseObject[@"avatar_large"]];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DLog(@"%@",error.description);
            }];
            
            //成功
            break;
        }
            
        case WeiboSDKResponseStatusCodeAuthDeny:
            [[BTNoticeShowManager shareManager] showNotice:@"授权失败"];
              break;
            
        case WeiboSDKResponseStatusCodeUnknown:
            // 未知错误
            [[BTNoticeShowManager shareManager] showNotice:@"已取消"];
              break;
            
        default:
              break;
     }
    
}

#pragma mark - 微信

-(void)onResp:(BaseResp *)resp
{
    [BTHelper hideAllLoadingView];
    SendAuthResp *aResp = (SendAuthResp *)resp;
    
    if (aResp.errCode == 0) {
        NSString *code = aResp.code;
        _wxCode = [NSDictionary dictionary];
        _wxCode = @{ @"code":code };
        [self getAccess_token];
    }
    
}

// TODO:QQ _tencentOauth getuserinfo] 设置后才  -- > 获取用户信息如头像昵称等
-(void)getUserInfoResponse:(APIResponse *)response
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *platform = @"qqweb";
    NSString *token = [userDefaults objectForKey:QQ_ACCESS_TOKEN];
    NSString *userid = [userDefaults objectForKey:QQ_USER_ID];
    
    if (response.retCode == URLREQUEST_SUCCEED) {
        // TODO:存储QQ用户昵称和头像
        NSString *qqNickname = response.jsonResponse[@"nickname"];
        NSString *qqIconUrl = response.jsonResponse[@"figureurl_qq_2"];
        [self loginWithPlatform:platform Token:token UID:userid Nickname:qqNickname AvatarUrl:qqIconUrl];
        
    } else {
        DLog(@"获取用户信息失败！");
    }
}


#pragma mark 获取微信 access_token及用户信息
-(void)getAccess_token
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *wxCode = _wxCode[@"code"];
    
    [params setObject:wxCode forKey:@"code"];
    [params setObject:WX_GRANT_TYPE_VALUE forKey:WX_GRANT_TYPE_KEY];
    [params setObject:WX_APP_ID forKey:WX_APP_ID_KEY];
    [params setObject:WX_APP_SECRET forKey:WX_APP_SECRET_KEY];
    
    [BTHelper showHttpRequestLoadingOnController:self.view];
    
    [manager POST:[NSString stringWithFormat:@"%@access_token?",WX_TOKEN_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [BTHelper hideAllLoadingView];
        NSString *access_token = responseObject[@"access_token"];
        NSString *openid = responseObject[@"openid"];
        NSString *platform = @"weixin";
        NSString *unionid = responseObject[@"unionid"];
        NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
        [paramter setObject:access_token forKey:@"access_token"];
        [paramter setObject:openid forKey:@"openid"];
        
        //获取用户信息
        [manager GET:@"https://api.weixin.qq.com/sns/userinfo" parameters:paramter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // TODO:存储微信用户昵称和头像
            [BTHelper hideAllLoadingView];
            NSString *wxNickname = responseObject[@"nickname"];
            NSString *wxIconUrl = responseObject[@"headimgurl"];
            
            [[BTLogin2RequestAPI loginManager] loginWithPlatformName:platform Token:access_token UID:unionid Success:^(AFHTTPRequestOperation *operation, id respondObject) {
            
                [self getUserInfoRequest];
            
            } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                // 用户未关联第三方账号 (如果用户没有关联，则返回错误信息，此时应打开用户注册或者关联账号页面)
                if ([operation.responseObject[@"status"] integerValue] == 14) {
                    
                    NSDictionary *VCParamters = @{@"platform": platform, 
                                                  @"token": access_token, 
                                                  @"owner_uid": openid,
                                                  @"unionid": unionid ? unionid : @"", // 微信专用
                                                  @"nickname": wxNickname ? wxNickname : @"",
                                                  @"avatarUrl": wxIconUrl };
                    
                    BTLogin2UserNameSettingViewController *userNameSetVC = [[BTLogin2UserNameSettingViewController alloc] initWithParamters:VCParamters];
                    [self.navigationController pushViewController:userNameSetVC animated:YES];
                    
                } else {
                    [[BTNoticeShowManager shareManager] showNotice:operation.responseObject[@"message"]];
                }
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [BTHelper hideAllLoadingView];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BTHelper hideAllLoadingView];
        [[BTNoticeShowManager shareManager] showNotice:@"网络连接失败，请重试"];
    }];
}


#pragma mark QQ

-(void)tencentDidLogin
{
    [BTHelper hideAllLoadingView];
    
    if (_tencentOauth.accessToken && 0 != [_tencentOauth.accessToken length]) {
        
        NSString *token = _tencentOauth.accessToken;
        NSString *uid = _tencentOauth.openId;
        NSString *platform = @"qqweb";
        NSDictionary *param = @{@"access_token": token, @"openid": uid, @"oauth_consumer_key": QQ_APP_ID_VALUE, @"format": @"json"};
        
        //获取用户信息
        [BTHelper showHttpRequestLoadingOnController:self.view];
        
        [[AFHTTPRequestOperationManager manager] GET:@"https://graph.qq.com/user/get_simple_userinfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [BTHelper hideAllLoadingView];
            NSString *qqNickname = responseObject[@"nickname"];
            NSString *qqIconUrl = responseObject[@"figureurl_qq_2"];
            [self loginWithPlatform:platform Token:token UID:uid Nickname:qqNickname AvatarUrl:qqIconUrl];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@",error.description);
        }];
    }
    
}

-(void)tencentDidLogout
{
    DLog(@"登出");
    [BTHelper hideAllLoadingView];
}
-(void) tencentDidNotLogin:(BOOL)cancelled
{
    [BTHelper hideAllLoadingView];
    if (cancelled) return;
    DLog(@"登陆错误错误");
    
}
-(void)tencentDidNotNetWork
{
    [BTHelper hideAllLoadingView];
    DLog(@"网络错误");
}

#pragma mark - Properties

-(void)setIsLoginVC:(BOOL)isLoginVC
{
    _isLoginVC = isLoginVC;
    if (_isLoginVC) {
        self.thirdPartyLoginTipsLable.text = @"第三方账号登录";
    } else {
        self.thirdPartyLoginTipsLable.text = @"其它注册方式";
    }
}

#pragma mark - HttpRequest

- (void)loginWithPlatform:(NSString *)platform Token:(NSString *)token UID:(NSString *)uid Nickname:(NSString *)nickname AvatarUrl:(NSString *)avatarUrl
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    
    
    
    [[BTLogin2RequestAPI loginManager] loginWithPlatformName:platform Token:token UID:uid Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        [self getUserInfoRequest];
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 用户未关联第三方账号 (如果用户没有关联，则返回错误信息，此时应打开用户注册或者关联账号页面)
        if ([operation.responseObject[@"status"] integerValue] == 14) {
            
            NSDictionary *VCParamters = @{@"platform": platform, 
                                          @"token": token, 
                                          @"uid": uid ? uid : @"",
                                          @"nickname": nickname, 
                                          @"avatarUrl": avatarUrl };
            
            BTLogin2UserNameSettingViewController *userNameSetVC = [[BTLogin2UserNameSettingViewController alloc] initWithParamters:VCParamters];
            [self.navigationController pushViewController:userNameSetVC animated:YES];
            
            
        } else {
            [[BTNoticeShowManager shareManager] showNotice:operation.responseObject[@"message"]];
        }
    }];
}

//获取用户信息
- (void)getUserInfoRequest
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    
    [[BTLogin2RequestAPI loginManager] getUserInfo:0 Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        [BTHelper hideAllLoadingView];
        [[BTUserInfo shareInstance]modifyInstanceInfoByDictionary:[respondObject objectForKey:@"Variables"]];
        BTLogin2ViewController *loginVC = [self.parentViewController childViewControllers][0];
        
        if (loginVC.successBlock) {
            loginVC.successBlock();
            //分发登录成功通知，方便用户相关页面刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:kNFLoginSuccess object:nil];
            // 统计登录成功
            [[BTMobClick shareInstance] clickEventType:@"login" module:nil];
            [loginVC dismissViewControllerAnimated:NO completion:nil];
        } else {
            [self enterMainInterface];
        }
    } Fail:^(AFHTTPRequestOperation *operation, id respondObject) {
        [BTHelper hideAllLoadingView];
         [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
