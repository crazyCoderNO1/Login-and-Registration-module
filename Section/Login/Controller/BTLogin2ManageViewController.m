//
//  BTLogin2ManageViewController.m
//  管理或者或者管理页面，
//
//  Created by Carroll on 16/3/9.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2ManageViewController.h"
#import "BTLogin2ViewController.h"
#import "BTLogin2RegisterViewController.h"
#import "BTLogin2ThirdPartyLoginViewController.h"

@interface BTLogin2ManageViewController ()<BTLogin2VCProtocol,BTRegist2VCProtocol>

@property (nonatomic, strong) BTLogin2ViewController *loginVC;
@property (nonatomic, strong) BTLogin2RegisterViewController *registerVC;
@property (nonatomic, strong) BTLogin2ThirdPartyLoginViewController *thirdPartyLoginVC;

@property (nonatomic, strong) UIImageView *topBannerImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *tabHighlightIconImageView;

@property (nonatomic, strong) UIButton *loginTabButton;
@property (nonatomic, strong) UIButton *registerTabButton;
@property (nonatomic, strong) UIButton *backButton;


@end

@implementation BTLogin2ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter * keyboardCenter = [NSNotificationCenter defaultCenter];
    
    [keyboardCenter addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
   
    [keyboardCenter addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self configureVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isSetStatusBarStyleLight = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)configureVC
{
    self.view.backgroundColor = Common_Background_Gray_Color;
    
    self.topBannerImageView = UIImageView.new;
//    self.topBannerImageView.backgroundColor = [UIColor red_0xf84646];
    self.topBannerImageView.image = [UIImage imageNamed:@"BTLoginManage_bannerBG"];
//    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = CGRectMake(0, 0, Screen_Width, 328/Screen_AutoScaleValue);
//    [self.topBannerImageView.layer addSublayer:gradientLayer];
//    
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0.6, 0);
//    gradientLayer.colors = @[(__bridge id)UIColorFromHex(0xff583c).CGColor, (__bridge id)UIColorFromHex(0xff2b3f).CGColor];
//    gradientLayer.locations = @[@(0.5f), @(1.0f)];
    
    self.logoImageView = UIImageView.new;
    self.logoImageView.image = [UIImage imageNamed:@"BTLoginManage_textLogo"];
    
    self.loginTabButton = UIButton.new;
    self.loginTabButton.tag = 1;
    [self.loginTabButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginTabButton setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 20)];
    
    [self.loginTabButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.loginTabButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerTabButton = UIButton.new;
    self.registerTabButton.tag = 2;
    [self.registerTabButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerTabButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.registerTabButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerTabButton setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 20)];
    
    self.tabHighlightIconImageView = [UIImageView new];
    self.tabHighlightIconImageView.image = [UIImage imageNamed:@"BTLoginManage_focusIcon"];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"nav_back_white.png"] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.backButton.imageView.contentMode = UIViewContentModeBottomLeft;
    
    self.loginVC = BTLogin2ViewController.new;
    
    self.registerVC = BTLogin2RegisterViewController.new;
    self.thirdPartyLoginVC = BTLogin2ThirdPartyLoginViewController.new;
    
    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.topBannerImageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.loginTabButton];
    [self.view addSubview:self.registerTabButton];
    [self.view addSubview:self.tabHighlightIconImageView];
    [self.view addSubview:self.backButton];
    
    [self addChildViewController:self.loginVC];
    [self addChildViewController:self.registerVC];
    [self addChildViewController:self.thirdPartyLoginVC];
    
    [self.view addSubview:self.loginVC.view];
    [self.view addSubview:self.registerVC.view];
    [self.view addSubview:self.thirdPartyLoginVC.view];
    
    int v = Screen_AutoScaleValue;

    [self.topBannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.height.equalTo(@(328/v));
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.topBannerImageView);
        make.width.equalTo(@(124/2));
        make.height.equalTo(@(92/2));
    }];
    
    [self.loginTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBannerImageView.mas_bottom).offset(-(15+14+20));
        make.centerX.equalTo(self.topBannerImageView).offset(-60);
    }];
    
    [self.registerTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBannerImageView.mas_bottom).offset(-(15+14+20));
        make.centerX.equalTo(self.topBannerImageView).offset(60);
    }];
    
    [self.tabHighlightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBannerImageView.mas_bottom); 
        make.centerX.equalTo(self.loginTabButton);
        make.width.equalTo(@(26/v));
        make.height.equalTo(@(15/v));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@(20));
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [self.loginVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBannerImageView.mas_bottom);
        make.left.and.right.equalTo(self.topBannerImageView);
        make.height.equalTo(self.view).offset(-30);
    }];
    
    [self.registerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBannerImageView.mas_bottom);
        make.left.and.right.equalTo(self.topBannerImageView);
        make.height.equalTo(self.view).offset(-30);
    }];
    
    [self.thirdPartyLoginVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40/v); //-20
        make.left.equalTo(self.view).offset(150/v);
        make.right.equalTo(self.view).offset(-150/v);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(165/v));
    }];

}

-(void)updateViewConstraints
{
    if (self.isKeyboardWasShow == YES) {
        [self.topBannerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(-100);
            make.height.equalTo(@(328/Screen_AutoScaleValue));
        }];
        
    }
    else {
        
        [self.topBannerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.equalTo(self.view);
            make.height.equalTo(@(328/Screen_AutoScaleValue));
        }];

    }
    
    [super updateViewConstraints];
}

#pragma mark Tab

- (void)didTapButton:(UIButton *)button
{
    [self tabHighlightWithTag:button.tag];
}

- (void)tabHighlightWithTag:(NSInteger)tag
{
    if (tag == 1) { // 登录
        
        self.loginVC.view.hidden = NO;
        self.registerVC.view.hidden = YES;
        self.thirdPartyLoginVC.isLoginVC = YES;
        
        [self.tabHighlightIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topBannerImageView.mas_bottom); 
            make.centerX.equalTo(self.loginTabButton);
            make.width.equalTo(@(26/Screen_AutoScaleValue));
            make.height.equalTo(@(15/Screen_AutoScaleValue));
        }];
    } else { // 注册
        self.loginVC.view.hidden = YES;
        self.registerVC.view.hidden = NO;
        self.thirdPartyLoginVC.isLoginVC = NO;
        
        [self.tabHighlightIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topBannerImageView.mas_bottom); 
            make.centerX.equalTo(self.registerTabButton);
            make.width.equalTo(@(26/Screen_AutoScaleValue));
            make.height.equalTo(@(15/Screen_AutoScaleValue));
        }];
    }
}


#pragma mark - Delegate

-(void)textFieldEditingDidBegin
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    self.isKeyboardWasShow = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)textFieldEditingDidEnd
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    self.isKeyboardWasShow = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Properties

-(void)setIsGotoLogin:(BOOL)isGotoLogin
{
    _isGotoLogin = isGotoLogin;
    
    [self addSubviews];
    
    [self tabHighlightWithTag:_isGotoLogin ? 1 : 2];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
