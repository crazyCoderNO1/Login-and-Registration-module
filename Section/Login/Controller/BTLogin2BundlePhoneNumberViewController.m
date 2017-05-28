//
//  BTLogin2BundlePhoneNumberViewController.m
//  绑定手机
//
//  Created by Carroll on 16/3/15.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2BundlePhoneNumberViewController.h"

#import "BTLogin2TextField.h"

@interface BTLogin2BundlePhoneNumberViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTLogin2TextField *captchaTextField;
@property (nonatomic, strong) UIButton *getCatpcahtButton;
@property (nonatomic, strong) UILabel *phoneNumberLabel;

@end

@implementation BTLogin2BundlePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

- (void)configureVC
{
    self.title = @"绑定手机";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];

    [self addBackButton];
    [self addRightBarButtonWithText:@"下一步"];

    self.phoneNumberLabel = UILabel.new;
    self.phoneNumberLabel.text = @"输入手机号码";
    self.phoneNumberLabel.font = [UIFont systemFontOfSize:15];
    [self.phoneNumberLabel setTextColor:RGB(71, 71, 71)];

    self.captchaTextField = BTLogin2TextField.new;
    self.captchaTextField.delegate = self;
    self.captchaTextField.textTips = @"输入验证码";
    UIView *spacerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.captchaTextField setLeftView:spacerView];
    [self.captchaTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.captchaTextField setTextAlignment:NSTextAlignmentLeft];

    self.getCatpcahtButton = UIButton.new;
    [self.getCatpcahtButton setTitleColor:RGB(71, 71, 71) forState:UIControlStateNormal];
    [self.getCatpcahtButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.getCatpcahtButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCatpcahtButton setFont:[UIFont systemFontOfSize:15]];
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

- (void)didTapSubmiteButton:(UIButton *)button
{
    [self.getCatpcahtButton setHighlighted:YES];
}

#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.captchaTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField == self.captchaTextField) {

        [self.captchaTextField resignFirstResponder];

        [self didTapSubmiteButton:nil];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    self.captchaTextField.returnKeyType = UIReturnKeyGo;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
