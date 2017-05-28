//
//  BTLogin2RecoverPasswdUsePhoneNumberViewController.m
//  使用手机找回密码
//
//  Created by Carroll on 16/3/15.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2RecoverPasswdUsePhoneNumberViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2RequestAPI.h"
#import "BTLogin2ResetPasswdViewController.h"
#import "BTNoticeShowManager.h"
#import "BTHelper.h"

@interface BTLogin2RecoverPasswdUsePhoneNumberViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTLogin2TextField *captchaTextField;
@property (nonatomic, strong) UIButton *getCatpcahtButton;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation BTLogin2RecoverPasswdUsePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)configureVC
{
    self.title = @"找回密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
    [self addRightBarButtonWithText:@"下一步"];
    
    self.phoneNumberLabel = UILabel.new;
    self.phoneNumberLabel.text = F(@"%@****%@", [self.paramters[@"phoneNumber"] substringToIndex:4], [self.paramters[@"phoneNumber"] substringFromIndex:8]);
    self.phoneNumberLabel.font = [UIFont systemFontOfSize:15];
    [self.phoneNumberLabel setTextColor:[UIColor grayColor]];
    
    self.captchaTextField = BTLogin2TextField.new;
    self.captchaTextField.delegate = self;
    self.captchaTextField.textTips = @"输入验证码";
    UIView *spacerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.captchaTextField setLeftView:spacerView];
    [self.captchaTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.captchaTextField setTextAlignment:NSTextAlignmentLeft];
    [self.captchaTextField addTarget:self action:@selector(didEditingChangedCaptchaTextField:) forControlEvents:UIControlEventEditingChanged];
    
    self.getCatpcahtButton = UIButton.new;
    [self.getCatpcahtButton setTitleColor:RGB(71, 71, 71) forState:UIControlStateNormal];
    [self.getCatpcahtButton setTitleColor:Common_LightGray_Color forState:UIControlStateHighlighted];
    [self.getCatpcahtButton setTitleColor:Common_LightGray_Color forState:UIControlStateDisabled];
    [self.getCatpcahtButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCatpcahtButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.getCatpcahtButton addTarget:self action:@selector(didTapSubmiteButton:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.captchaTextField];
    [self.view addSubview:self.phoneNumberLabel];
    [self.view addSubview:self.getCatpcahtButton];
    
    [self.captchaTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(210/2);
        make.height.equalTo(@(110/2));
        make.width.equalTo(@(450/2));
    }];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.captchaTextField.mas_top).offset(-44/2); 
        make.centerX.equalTo(self.view);
    }];
    
    [self.getCatpcahtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.captchaTextField);
        make.right.equalTo(self.captchaTextField).offset(-20);
    }];
    
}

#pragma mark - Delgate

- (void)didEditingChangedCaptchaTextField:(UITextField *)textField
{
//    self.getCatpcahtButton.enabled = validated;
//    self.getCatpcahtButton.highlighted = !validated;
}

- (void)didTapSubmiteButton:(UIButton *)button
{
    self.getCatpcahtButton.enabled = NO;
    
    [self sendPhoneNumberCode];
}

-(void)rightAction:(UIButton *)sender
{
    
    if (self.captchaTextField.text.length != 6 ) {
        [[BTNoticeShowManager shareManager] showNotice:@"请输入6位数验证码"];
        return;
    }
    
    [self validatePhoneNumberCode];
}

#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.captchaTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.captchaTextField) {
        
        [self.captchaTextField resignFirstResponder];
        [self rightAction:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.captchaTextField.returnKeyType = UIReturnKeyGo;
}

- (void)resetGetCatpcahtButtonStatus:(NSTimer *)time
{
    static int i = 60;
    i--;
    
    [self.getCatpcahtButton setTitle:F(@"%ds重新获取", i) forState:UIControlStateNormal];
    
    if (i == 0) {
        i = 60;
        self.getCatpcahtButton.enabled = YES;
        [self.timer invalidate];
        [self.getCatpcahtButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}

#pragma mark - HttpRequest


// 发送验证码
- (void)sendPhoneNumberCode
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    
    [[BTLogin2RequestAPI loginManager] registWithSendPhoneNumberCode:self.paramters[@"phoneNumber"] Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] ==0) {
            [[BTNoticeShowManager shareManager] showNotice:@"验证码已发送"];
            self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(resetGetCatpcahtButtonStatus:) userInfo:nil repeats:YES];  
        }
        else {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
            self.getCatpcahtButton.enabled = YES;
        }
        [BTHelper hideAllLoadingView];
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.getCatpcahtButton.enabled = YES;
        [BTHelper hideAllLoadingView];
    }];
    
}

// 验证验证码
- (void)validatePhoneNumberCode
{
    
    BTLogin2ResetPasswdViewController *resetPasswordVC = BTLogin2ResetPasswdViewController.new;
    
    [BTHelper showHttpRequestLoadingOnController:self.view];
    
    [[BTLogin2RequestAPI loginManager] registWithAvlidatePhoneNumberCode:self.captchaTextField.text WithPhoneNumber:self.paramters[@"phoneNumber"] Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] ==0) {
            resetPasswordVC.paramters = @{@"code": self.captchaTextField.text, @"phoneNumber": self.paramters[@"phoneNumber"]};
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
        }
        else {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
            self.getCatpcahtButton.enabled = YES;
        }
        
        [BTHelper hideAllLoadingView];
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BTHelper hideAllLoadingView];
        self.getCatpcahtButton.enabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
