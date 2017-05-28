//
//  BTLogin2RegisterViewController.m
//  注册
//
//  Created by Carroll on 16/3/11.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2RegisterViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2Button.h"
#import "BTNoticeShowManager.h"
#import "BTLogin2RequestAPI.h"
#import "BTLogin2PasswdSettingViewController.h"
#import "BTLogin2Helper.h"
#import "BTHelper.h"
#import "BTWebViewController.h"
#import "BTNavigationViewController.h"

@interface BTLogin2RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTLogin2TextField *phoneNumberTextField;
@property (nonatomic, strong) BTLogin2TextField *captchaTextField;
@property (nonatomic, strong) UIButton *getCatpcahtButton;
@property (nonatomic, strong) BTLogin2Button *submitNextButton;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UILabel *userAgreemantTextLabel;
@property (nonatomic, strong) UIButton *userAgreemantButton;


@end

@implementation BTLogin2RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isSetStatusBarStyleLight = YES;
    
    [self.timer invalidate];
}
- (void)configureVC
{    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.phoneNumberTextField = BTLogin2TextField.new;
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.textTips = @"输入手机号码";
    self.phoneNumberTextField.textAlignment = NSTextAlignmentLeft;
    [self.phoneNumberTextField addTarget:self action:@selector(phoneNumberTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.captchaTextField = BTLogin2TextField.new;
    self.captchaTextField.delegate = self;
    self.captchaTextField.textTips = @"输入验证码";
    self.captchaTextField.textAlignment = NSTextAlignmentLeft;
    [self.captchaTextField setTextAlignment:NSTextAlignmentLeft];
    [self.captchaTextField addTarget:self action:@selector(captchaTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.captchaTextField addTarget:self action:@selector(userPasswordTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.captchaTextField addTarget:self action:@selector(userPasswordTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];

    self.getCatpcahtButton = UIButton.new;
    [self.getCatpcahtButton setEnabled:NO];
    [self.getCatpcahtButton setTitleColor:[UIColor red_0xf84646] forState:UIControlStateNormal];
    [self.getCatpcahtButton setTitleColor:Common_LightGray_Color forState:UIControlStateHighlighted];
    [self.getCatpcahtButton setTitleColor:Common_LightGray_Color forState:UIControlStateDisabled];
    [self.getCatpcahtButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCatpcahtButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.getCatpcahtButton addTarget:self action:@selector(didTapGetCatpcahtButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitNextButton = BTLogin2Button.new;
    self.submitNextButton.enabled = NO;
    self.submitNextButton.textTips = @"下一步";
    [self.submitNextButton addTarget:self action:@selector(didTapSubmiteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userAgreemantButton = UIButton.new;
    [self.userAgreemantButton setTitle:@"美骑用户协议" forState:UIControlStateNormal];
    [self.userAgreemantButton setTitleColor:[UIColor red_0xf84646] forState:UIControlStateNormal];

    [self.userAgreemantButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.userAgreemantButton addTarget:self action:@selector(didTapUserAgreemantButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userAgreemantTextLabel = UILabel.new;
    self.userAgreemantTextLabel.text = @"我已阅读并同意";
    self.userAgreemantTextLabel.font = [UIFont fontSize12];
    self.userAgreemantTextLabel.textColor = [UIColor gray_0x7a7a7a];
    
    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.phoneNumberTextField];
    [self.view addSubview:self.captchaTextField];
    [self.view addSubview:self.getCatpcahtButton];
    [self.view addSubview:self.submitNextButton];
    [self.view addSubview:self.userAgreemantButton];
    [self.view addSubview:self.userAgreemantTextLabel];
    
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(186/Screen_AutoScaleValue);
        if (Iphone_4 || Iphone_5) {
            make.top.equalTo(self.view.mas_top).offset(35);
        }
        make.height.equalTo(@(110/Screen_AutoScaleValue));
        make.left.equalTo(self.view.mas_left).offset(146/2);
        make.right.equalTo(self.view.mas_right).offset(-146/2);
    }];
    
    [self.captchaTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoneNumberTextField.mas_bottom);
        make.height.width.equalTo(self.phoneNumberTextField);
    }];
    
    [self.getCatpcahtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.captchaTextField);
        make.right.equalTo(self.captchaTextField).offset(-20);
    }];
    
    [self.submitNextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.captchaTextField.mas_bottom).offset(156/Screen_AutoScaleValue);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.phoneNumberTextField);
    }];
    
    [self.userAgreemantButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitNextButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.submitNextButton);
    }];
    
    [self.userAgreemantTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userAgreemantButton.mas_left);
        make.centerY.equalTo(self.userAgreemantButton);
    }];
    
}

#pragma mark - Delgate

- (void)phoneNumberTextFieldEditChanged:(UITextField *)textField
{
    BOOL checkPhoneNumber = [BTLogin2Helper checkPhoneNumInput:textField.text];
    self.getCatpcahtButton.enabled = checkPhoneNumber;
    self.getCatpcahtButton.highlighted = !checkPhoneNumber;
}

- (void)captchaTextFieldEditChanged:(UITextField *)textField
{
    BOOL checked = (textField.text.length > 5 && [BTLogin2Helper checkPhoneNumInput:self.phoneNumberTextField.text]);
    
    self.submitNextButton.selected = self.submitNextButton.enabled = checked;
}

- (void)didTapGetCatpcahtButton:(UIButton *)button
{
    
    if (![BTLogin2Helper checkPhoneNumInput:self.phoneNumberTextField.text]) {
        [[BTNoticeShowManager shareManager] showNotice:@"请输入正确的手机号码"];
        return;
    }
    button.enabled = NO;
    [self checkPhoneNumberIsRegister];
}

- (void)didTapSubmiteButton:(UIButton *)button
{
    [self checkPhoneNumberCode];
    
    // 注册界面点击下一步统计
    [[BTMobClick shareInstance] clickEventType:@"register" module:nil];
}

- (void)didTapUserAgreemantButton:(UIButton *)button
{
    BTWebViewController *web = [[BTWebViewController alloc]initWithNibName:NSStringFromClass([BTWebViewController class]) bundle:nil];
    web.urlStr = [NSString stringWithFormat:@"%@/m-law.html",[BTUrl sharedUtility].indexHostBaseUrl];
    BTNavigationViewController *nav = [[BTNavigationViewController alloc]initWithRootViewController:web];
    [self.navigationController presentViewController:nav animated:YES completion:nil];

}

// 验证手机号码是否已经注册;
- (void)checkPhoneNumberIsRegister
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    [[BTLogin2RequestAPI manager] registWithCheckPhoneNumber:self.phoneNumberTextField.text Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] ==0) {
            self.getCatpcahtButton.enabled = YES;
            [self sendPhoneNumberCode];
        }
        else if ([respondObject[@"status"] integerValue] ==7)
        {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
            self.getCatpcahtButton.enabled = YES;
            [BTHelper hideAllLoadingView];
        }
        else {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
             self.getCatpcahtButton.enabled = YES;
            [BTHelper hideAllLoadingView];
        }
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.getCatpcahtButton.enabled = YES;
        [BTHelper hideAllLoadingView];
    }];
}

// 发送验证码
- (void)sendPhoneNumberCode
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    [[BTLogin2RequestAPI manager] registWithSendPhoneNumberCode:self.phoneNumberTextField.text Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] ==0) {
            [[BTNoticeShowManager shareManager] showNotice:@"验证码已发送"];
            
            self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(resetGetCatpcahtButtonStatus:) userInfo:nil repeats:YES];  
            self.getCatpcahtButton.enabled = NO;
            self.submitNextButton.enabled = YES;
            
        } else {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
        }
        
        [BTHelper hideAllLoadingView];
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.getCatpcahtButton.enabled = YES;
        self.submitNextButton.enabled = NO;
        [BTHelper hideAllLoadingView];
    }];
}

// 检查验证码
- (void)checkPhoneNumberCode
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    [[BTLogin2RequestAPI manager] registWithAvlidatePhoneNumberCode:self.captchaTextField.text WithPhoneNumber:self.phoneNumberTextField.text Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] ==0) {
            
            NSDictionary *VCParamters = @{@"phoneNumber": self.phoneNumberTextField.text, @"code": self.captchaTextField.text};
            
            BTLogin2PasswdSettingViewController *vc = [[BTLogin2PasswdSettingViewController alloc]initWithParamters:VCParamters];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }  else {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
            self.getCatpcahtButton.enabled = YES;
            self.submitNextButton.enabled = NO;
        }
        
        [BTHelper hideAllLoadingView];
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {  
        self.getCatpcahtButton.enabled = YES;
        self.submitNextButton.enabled = NO;
        [BTHelper hideAllLoadingView];
    }];
}

#pragma mark - delegate

- (void)userPasswordTextFieldEditingDidBegin:(UITextView *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldEditingDidBegin)]){
        
        [self.delegate textFieldEditingDidBegin];
    }
}

- (void)userPasswordTextFieldEditingDidEnd:(UITextView *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldEditingDidEnd)]){
        [self.delegate textFieldEditingDidEnd];
    }
}

- (void)resetGetCatpcahtButtonStatus:(NSTimer *)time
{
    static int i = 60;
    i--;
    
    [self.getCatpcahtButton setTitle:F(@"%ds重新获取", i) forState:UIControlStateNormal];
    
    if (i == 0) {
        i = 60;
        self.getCatpcahtButton.enabled = YES;
        self.submitNextButton.enabled = NO;
        [self.timer invalidate];
        [self.getCatpcahtButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }

}

#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.phoneNumberTextField resignFirstResponder];
    [self.captchaTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.phoneNumberTextField) {
        
        [self.captchaTextField becomeFirstResponder];
        [self.phoneNumberTextField resignFirstResponder];
        
    }else if (textField == self.captchaTextField) {
        
        [self.captchaTextField resignFirstResponder];
        [self.phoneNumberTextField resignFirstResponder];
        [self didTapSubmiteButton:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.phoneNumberTextField.returnKeyType = UIReturnKeyNext;
    self.captchaTextField.returnKeyType = UIReturnKeyGo;
}


@end
