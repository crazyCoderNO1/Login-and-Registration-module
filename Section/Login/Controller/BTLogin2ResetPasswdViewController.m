//
//  BTLogin2ResetPasswdViewController.m
//  重置密码
//
//  Created by Carroll on 16/3/15.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2ResetPasswdViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2RequestAPI.h"
#import "BTNoticeShowManager.h"
#import "BTLogin2ManageViewController.h"

@interface BTLogin2ResetPasswdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTLogin2TextField *passwdField;

@end

@implementation BTLogin2ResetPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

- (void)configureVC
{
    self.title = @"重置密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
    [self addRightBarButtonWithText:@"确定"];
    
    self.passwdField = BTLogin2TextField.new;
    self.passwdField.delegate = self;
    self.passwdField.secureTextEntry = YES;
    self.passwdField.textTips = @"6~16个字符";
    self.passwdField.borderTypeOfNumber = 3;
    
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

-(void)rightAction:(UIButton *)sender
{
    
    [[BTLogin2RequestAPI loginManager] recoverPasswordWithPhoneNumber:self.paramters[@"phoneNumber"] 
                                                                 WithCode:self.paramters[@"code"]
                                                             WithPassword:self.passwdField.text
    Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] == 0) {
            
            BTLogin2ManageViewController *loginVC = BTLogin2ManageViewController.new;
            loginVC.isGotoLogin = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            
        } else {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
        }
       
    } Fail:nil];
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
