//
//  BTLogin2ViewController.m
//  登录
//
//  Created by Carroll on 16/3/9.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2ViewController.h"
#import "BTLogin2RequestAPI.h"
#import "BTLogin2RecoverPasswdViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2Button.h"

#import "BTNoticeShowManager.h"
#import "BTHelper.h"
#import "BTUserInfo.h"
#import "BTSubModuleRootViewController.h"
#import "BTTabBarViewController.h"
#import "AppDelegate.h"
#import "BTRunloopManager.h"

@interface BTLogin2ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTLogin2TextField *userField;
@property (nonatomic, strong) BTLogin2TextField *passwdField;

@property (nonatomic, strong) BTLogin2Button *submiteButton;
@property (nonatomic, strong) UIButton *ForgertPasswordSubmiteButton;

@end

@implementation BTLogin2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isSetStatusBarStyleLight = YES;
}

- (void)configureVC
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRightBarButtonWithText:@"取消"];
    
    self.userField = BTLogin2TextField.new;
    self.userField.delegate = self;
    self.userField.textTips = @"手机/邮箱/用户名";
    self.userField.type = textFieldTypeDefault;
    self.userField.textAlignment = NSTextAlignmentLeft;
    [self.userField addTarget:self action:@selector(userNameTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];

    self.passwdField = BTLogin2TextField.new;
    self.passwdField.delegate = self;
    self.passwdField.textTips = @"输入密码";
    self.passwdField.type = textFieldTypePassword;
    self.passwdField.textAlignment = NSTextAlignmentLeft;
    self.passwdField.secureTextEntry = YES;
    [self.passwdField addTarget:self action:@selector(userPasswordTextFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwdField addTarget:self action:@selector(userPasswordTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.passwdField addTarget:self action:@selector(userPasswordTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];

    self.submiteButton = BTLogin2Button.new;
    self.submiteButton.textTips = @"登录";
    self.submiteButton.enabled = NO;
    [self.submiteButton addTarget:self action:@selector(didTapSubmiteButton:) forControlEvents:UIControlEventTouchUpInside];

    self.ForgertPasswordSubmiteButton = UIButton.new;
    [self.ForgertPasswordSubmiteButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.ForgertPasswordSubmiteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.ForgertPasswordSubmiteButton setTitleColor:[UIColor gray_0x7a7a7a] forState:UIControlStateNormal];
    [self.ForgertPasswordSubmiteButton addTarget:self action:@selector(didTapForgetPwSubmiteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubviews];
}

-(void)rightAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.userField];
    [self.view addSubview:self.passwdField];
    [self.view addSubview:self.submiteButton];
    [self.view addSubview:self.ForgertPasswordSubmiteButton];
    
    [self.userField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(186/2);
        if (Iphone_4 || Iphone_5) {
             make.top.equalTo(self.view.mas_top).offset(35);
        }
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(110/2));
        make.left.equalTo(self.view.mas_left).offset(146/2);
        make.right.equalTo(self.view.mas_right).offset(-146/2);
    }];
    
    [self.passwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userField.mas_bottom); 
        make.centerX.equalTo(self.view);
        make.width.and.height.equalTo(self.userField);
    }];
    
    [self.submiteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (Iphone_4 || Iphone_5) {
            make.top.equalTo(self.passwdField.mas_bottom).offset(30);
        } else {
            make.top.equalTo(self.passwdField.mas_bottom).offset(156/2);
        }
        
        make.height.equalTo(@45);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.userField);
    }];
    
    [self.ForgertPasswordSubmiteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwdField.mas_bottom).offset(8);
        make.right.equalTo(self.passwdField.mas_right);
    }];
    
}

#pragma mark - Delegate

- (void)userNameTextFieldEditChanged:(UITextField *)textField
{
    BOOL checked = (textField.text.length >= 3 && self.passwdField.text.length >= 6) ? YES : NO;
    self.submiteButton.selected = checked;
    self.submiteButton.enabled = checked;
}

- (void)userPasswordTextFieldEditChanged:(UITextField *)textField
{
    BOOL checked = (textField.text.length >= 3 && self.passwdField.text.length >= 6) ? YES : NO;
    self.submiteButton.selected = checked;
    self.submiteButton.enabled = checked;
}

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

- (void)didTapSubmiteButton:(UIButton *)button
{
    
    [self checkUserName:self.userField WithUasrPassword:self.passwdField withSuccess:^(id returnValue) {
        DLog(@"checkUserName");

        [BTHelper showHttpRequestLoadingOnController:self.view];
        
        [[BTLogin2RequestAPI loginManager] login2WithUserName:returnValue[@"username"] Password:returnValue[@"passwd"] Success:^(AFHTTPRequestOperation *operation, id respondObject) {
            
            
            DLog(@"button--button");

            if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] ==0) {
                //分发登录成功通知，方便用户相关页面刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:kNFLoginSuccess object:nil];
                [self enterMainInterface];
                
                if (self.successBlock) {
                    self.successBlock();
                }
                // 统计登录成功
               [[BTMobClick shareInstance] clickEventType:@"login" module:nil];
                
            } 
            else {
                [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
            }
            
            [BTHelper hideAllLoadingView];
            
        } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [BTHelper hideAllLoadingView];
            
        }];
    }];
    
}

- (void)checkUserName:(UITextField *)userNameField WithUasrPassword:(UITextField *)passwdField  withSuccess:(ReturnValueBlock)success{
    NSString *username = userNameField.text;
    NSString *passwd = passwdField.text;
    
    if (username.length <= 2 || passwd.length <= 5) {
        [[BTNoticeShowManager shareManager] showNotice:@"请输入正确的用户名和密码"];
        return;
    } else {
        success(@{@"username": username, @"passwd": passwd});
    }
}

- (void)didTapForgetPwSubmiteButton:(UIButton *)button
{
    [self.navigationController pushViewController:BTLogin2RecoverPasswdViewController.new animated:YES];
}

#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.userField resignFirstResponder];
    [self.passwdField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField == self.userField) {
        
        [self.passwdField becomeFirstResponder];
        [self.userField resignFirstResponder];

    }else if (textField == self.passwdField) {
    
        [self.passwdField resignFirstResponder];
        [self.userField resignFirstResponder];
        [self didTapSubmiteButton:nil];
       
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.userField.returnKeyType = UIReturnKeyNext;
    self.passwdField.returnKeyType = UIReturnKeyGo;
}

#pragma mark - Properties

- (void)setSuccessBlock:(LoginSuccessBlock)successBlock
{
    _successBlock = successBlock;
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    appDelegate.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
