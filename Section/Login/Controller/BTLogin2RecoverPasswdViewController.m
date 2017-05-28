//
//  BTLogin2RecoverPasswdViewController.m
//  找回密码，在这个页面判断用户使用找回密码的方式跳不去同的控制器
//
//  Created by Carroll on 16/3/14.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2RecoverPasswdViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2Helper.h"
#import "BTLogin2RecoverPasswdUsePhoneNumberViewController.h"
#import "BTLogin2RecoverPasswdUseEmailViewController.h"
#import "BTNoticeShowManager.h"
#import "BTHelper.h"
#import "BTLogin2RequestAPI.h"
#import "BTLogin2ManageViewController.h"
#import "BTAlertHelper.h"

@interface BTLogin2RecoverPasswdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTLogin2TextField *recoverPasswdField;
@end

@implementation BTLogin2RecoverPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)configureVC
{
    self.title = @"找回密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
    [self addRightBarButtonWithText:@"下一步"];
   
    
    self.recoverPasswdField = BTLogin2TextField.new;
    self.recoverPasswdField.delegate = self;
    self.recoverPasswdField.borderTypeOfNumber = 3;
    self.recoverPasswdField.textTips = @"手机号/邮箱";
    
    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.recoverPasswdField];
    
    [self.recoverPasswdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.height.equalTo(@(110/2));
        make.width.equalTo(@(450/2));
    }];
}

#pragma mark - Delegate

-(void)rightAction:(UIButton *)sender
{
    NSString *textStr = self.recoverPasswdField.text;

    BTLogin2RecoverPasswdUsePhoneNumberViewController *usePhoneNumberVC = BTLogin2RecoverPasswdUsePhoneNumberViewController.new;
    BTLogin2RecoverPasswdUseEmailViewController *useEmailVC = BTLogin2RecoverPasswdUseEmailViewController.new;
    
    if ([BTLogin2Helper checkPhoneNumInput:textStr]) {
        
        // 验证手机号码是否已经注册
        [BTHelper showHttpRequestLoadingOnController:self.view];
        
        [[BTLogin2RequestAPI manager] registWithCheckPhoneNumber:textStr Success:^(AFHTTPRequestOperation *operation, id respondObject) {
            
            if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] == 7) {
                usePhoneNumberVC.paramters = @{@"phoneNumber": textStr };
                
                [self.navigationController pushViewController:usePhoneNumberVC animated:YES];
            }
            else {
                
                __weak typeof(self) weakSelf = self;
                [[BTAlertHelper sharedUtility] showAlertView:self title:nil message:@"检测到该号码未注册过美骑，是否现在注册？" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" confirm:^{
                    BTLogin2ManageViewController *vc = BTLogin2ManageViewController.new;
                    vc.isGotoLogin = NO;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } cancle:nil];
            }
            
             [BTHelper hideAllLoadingView];
            
        } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
            [BTHelper hideAllLoadingView];
        }];
        
    } else if ([BTLogin2Helper isValidateEmail:textStr]) {
        
         // 验证email是否已经注册
        [[BTLogin2RequestAPI loginManager] recoverPasswordWithEmail:textStr Success:^(AFHTTPRequestOperation *operation, id respondObject) {
            
            if (![respondObject isKindOfClass:[NSDictionary class]]) {
                [[BTNoticeShowManager shareManager] showNotice:@"发送错误"];
                return;
            }
            if ([respondObject[@"status"] integerValue] == 0) {
                useEmailVC.paramters = @{@"email": textStr };
                [self.navigationController pushViewController:useEmailVC animated:YES];
            }
            else {
                [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
            }
            
            [BTHelper hideAllLoadingView];
            
        } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
            [BTHelper hideAllLoadingView];
        }];
               
    } else {
        [[BTNoticeShowManager shareManager] showNotice:@"请输入正确的手机号码或邮箱地址"];
    }
}

#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.recoverPasswdField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.recoverPasswdField) {
        
        [self.recoverPasswdField resignFirstResponder];
        [self rightAction:nil];

        
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.recoverPasswdField.returnKeyType = UIReturnKeyGo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
