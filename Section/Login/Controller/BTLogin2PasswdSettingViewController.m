//
//  BTLogin2PasswdSettingViewController.m
//  设置密码
//
//  Created by Carroll on 16/3/14.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2PasswdSettingViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2UserNameSettingViewController.h"
#import "BTNoticeShowManager.h"
#import "BTLogin2Helper.h"

@interface BTLogin2PasswdSettingViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTLogin2TextField *passwdField;
@property (nonatomic, strong) NSDictionary *paramters;

@end

@implementation BTLogin2PasswdSettingViewController

-(instancetype)initWithParamters:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.paramters = params;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

- (void)configureVC
{
    
    [self addRightBarButtonWithText:@"下一步"];
    [self addBackButtonWithText:@""];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"设置密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.passwdField = BTLogin2TextField.new;
    self.passwdField.delegate = self;
    self.passwdField.secureTextEntry = YES;
    self.passwdField.textTips = @"6~16个字符";
    self.passwdField.borderTypeOfNumber = 3;
    [self.passwdField becomeFirstResponder];
    [self.passwdField addTarget:self action:@selector(didEditingChangedPasswdTextFieldValue:) forControlEvents:UIControlEventEditingChanged];
    
    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.passwdField];
    
    [self.passwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.height.equalTo(@(110/2));
        make.width.equalTo(@(450/2));
    }];
}

#pragma mark - Delegate

- (void)didEditingChangedPasswdTextFieldValue:(UITextField *)textField
{
    if ([BTLogin2Helper stringContainsEmoji:textField.text]) {
        [[BTNoticeShowManager shareManager] showNotice:@"密码格式不能包含表情字符"];
        return;
    }
}

- (void)rightAction:(UIButton *)sender
{
    NSString *textStr = self.passwdField.text;
    
    if (textStr.length < 6 || textStr.length > 16) {
        [[BTNoticeShowManager shareManager] showNotice:@"请输入正确的密码格式"];
        [self.passwdField becomeFirstResponder];
        return;
    }
    
    NSDictionary *VCParamters = @{ @"phoneNumber": self.paramters[@"phoneNumber"], 
                                   @"code": self.paramters[@"code"],
                                   @"password": self.passwdField.text };
   
    BTLogin2UserNameSettingViewController *vc = [[BTLogin2UserNameSettingViewController alloc]initWithParamters:VCParamters];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    // 注册设置用户名完成
    BTMobClickModule *module = [[BTMobClickModule alloc] init];
    module.ea = @"password";
    [[BTMobClick shareInstance] clickEventType:@"register" module:module];
}

#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.passwdField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.passwdField) {
    
        [self.passwdField resignFirstResponder];
        [self rightAction:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.passwdField.returnKeyType = UIReturnKeyGo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
