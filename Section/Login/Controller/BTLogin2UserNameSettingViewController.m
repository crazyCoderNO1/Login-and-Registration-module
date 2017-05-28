//
//  BTLogin2UserNameSettingViewController.m
//  设置用户名, 头像等信息, 第三方注册跳转
//
//  Created by Carroll on 16/3/14.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2UserNameSettingViewController.h"
#import "BTLogin2TextField.h"
#import "BTLogin2Helper.h"
#import "BTLogin2RequestAPI.h"
#import "BTNoticeShowManager.h"
#import "MineInfoDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "BTHelper.h"
#import "BTAlertHelper.h"
#import "BTUserInfo.h"

@interface BTLogin2UserNameSettingViewController ()
<
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate
>

@property (nonatomic, strong) UIView *avatarContainerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *changeAvatarButton;

@property (nonatomic, strong) BTLogin2TextField *userNameField;
@property (nonatomic, strong) UILabel *userNameSettingTipsLabel;

@property (nonatomic, strong) NSMutableDictionary *paramters;

@end

@implementation BTLogin2UserNameSettingViewController

-(instancetype)initWithParamters:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.paramters = [[NSMutableDictionary alloc] initWithDictionary:params];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
    
    // 加载第三方头像
    if (self.paramters[@"avatarUrl"]) {
        [BTHelper showHttpRequestLoadingOnController:self.view];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.paramters[@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"BTLoginDefaultAvatar"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [BTHelper hideAllLoadingView];
            if (!error) {
                self.avatarImageView.image = image;
            }
        }];
    }
}

- (void)configureVC
{
    
    [self addBackButtonWithText:nil];
    [self addRightBarButtonWithText:@"完成"];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"设置用户名";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.avatarContainerView = UIView.new;
    self.avatarContainerView.layer.masksToBounds = NO;
    self.avatarContainerView.layer.cornerRadius = 50;
    self.avatarContainerView.layer.borderWidth = 1;
    self.avatarContainerView.layer.borderColor = RGB(227, 227, 227).CGColor;
    
    self.avatarImageView = UIImageView.new;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.image = [UIImage imageNamed:@"BTLoginDefaultAvatar"];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = (170/2) /2;
    
    self.changeAvatarButton = UIButton.new;
    [self.changeAvatarButton setBackgroundImage:[UIImage imageNamed:@"BTLoginChangeAvatarButton"] forState:UIControlStateNormal];
    [self.changeAvatarButton addTarget:self action:@selector(didChangeAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameField = BTLogin2TextField.new;
    self.userNameField.delegate = self;
    self.userNameField.text = self.paramters[@"nickname"] ?: @"";
    self.userNameField.textTips = @"3~20个字符";
    self.userNameField.borderTypeOfNumber = 3;
    [self.userNameField becomeFirstResponder];
    [self.userNameField addTarget:self action:@selector(didEditingChangeValueForUsesrNameField:) forControlEvents:UIControlEventEditingChanged];
    
    self.userNameSettingTipsLabel = UILabel.new;
    self.userNameSettingTipsLabel.text = @"固定用户名，保存后无法修改";
    self.userNameSettingTipsLabel.textColor = RGB(71, 71, 71);
    self.userNameSettingTipsLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubviews];
}

#pragma mark - Layout

- (void)addSubviews
{
    [self.view addSubview:self.avatarContainerView];
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.changeAvatarButton];
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.userNameSettingTipsLabel];
    
    [self.avatarContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self.avatarContainerView);
        make.width.equalTo(@(170/2));
        make.height.equalTo(@(170/2));
    }];
    
    [self.changeAvatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarContainerView.mas_top).offset(70);
        make.left.equalTo(self.avatarContainerView.mas_left).offset(136/2);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.avatarContainerView.mas_bottom).offset(30);
        make.height.equalTo(@(110/2));
        make.width.equalTo(@(450/2));
    }];
    
    [self.userNameSettingTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.userNameField.mas_bottom).offset(15);
    }];
    
}

#pragma mark - Properties

- (void)didEditingChangeValueForUsesrNameField:(UITextField *)textField
{
    if ([BTLogin2Helper stringContainsEmoji:textField.text]) {
        [[BTNoticeShowManager shareManager] showNotice:@"用户名不能包含表情字符"];
        return;
    }
    
    [self.paramters setObject:textField.text forKey:@"username"];
}

#pragma mark - Delegatge

- (void)toRegisterDelegate
{
    // 第三方
    if (self.paramters[@"platform"]) {
        [self resigerByThridParty];
    }
    // 通过用户中心
    else {
        [self regisertByUCenter];
    }
}

-(void)rightAction:(UIButton *)sender
{
    NSString *textStr = self.userNameField.text;
    
    if (textStr.length < 3 || textStr.length > 20) {
        [[BTNoticeShowManager shareManager] showNotice:@"请输入正确的用户名长度"];
        [self.userNameField becomeFirstResponder];
        return;
    }
    
    // UIAlertController
    __weak typeof(self) weakSelf = self;
    [[BTAlertHelper sharedUtility] showAlertView:self title:nil message:F(@"您设定的用户名为\"%@\", 确定后不可修改", self.userNameField.text) cancelButtonTitle:@"取消" otherButtonTitle:@"确定" confirm:^{
        [weakSelf toRegisterDelegate];
    } cancle:nil];

}

- (void)didChangeAvatarButton:(UIButton *)button
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    action.tintColor = Common_Red_Color;
    [action showInView:self.view];
    [self.userNameField resignFirstResponder];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 0:
            [self changeAvatarWithType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self changeAvatarWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatarImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeAvatarWithType:(UIImagePickerControllerSourceType)type
{
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        controller.sourceType = type;
        controller.delegate = self;
        controller.allowsEditing = YES;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}


#pragma mark - TextField Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.userNameField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.userNameField) {
        
        [self.userNameField resignFirstResponder];
        [self rightAction:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.userNameField.returnKeyType = UIReturnKeyGo;
}

#pragma mark - HttpRequest

- (void)regisertByUCenter
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    [[BTLogin2RequestAPI loginManager] registWithUsername:self.paramters[@"username"]
                                                WithPasswored:self.paramters[@"password"] 
                                              WithPhoneNumber:self.paramters[@"phoneNumber"] 
                                                     WithCode:self.paramters[@"code"] 
    Success:^(AFHTTPRequestOperation *operation, id respondObject) {
                                                          
    if ([respondObject isKindOfClass:[NSDictionary class]] && [respondObject[@"status"] integerValue] ==0) {
        // 上传头像
        [self changeUserAvatar];
        
        // 注册设置用户名完成
        BTMobClickModule *module = [[BTMobClickModule alloc] init];
        module.ea = @"username";
        [[BTMobClick shareInstance] clickEventType:@"register" module:module];

    } else {
        [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
    }
    [BTHelper hideAllLoadingView];
                                                          
    } Fail:nil];
}

- (void)resigerByThridParty
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    [[BTLogin2RequestAPI loginManager] registerWithPlatformName:self.paramters[@"platform"] 
                                                           UserName:self.userNameField.text 
                                                                UID:self.paramters[@"uid"]
                                                            Unionid:self.paramters[@"unionid"]
                                                              Token:self.paramters[@"token"] 
    Success:^(AFHTTPRequestOperation *operation, id respondObject) {
                                                                
        if ([respondObject[@"status"] integerValue] ==0) {
            // 上传头像
            [self changeUserAvatar];
            
            // 注册设置用户名完成
            BTMobClickModule *module = [[BTMobClickModule alloc] init];
            module.ea = @"username";
            [[BTMobClick shareInstance] clickEventType:@"register" module:module];

        } else {
            [[BTNoticeShowManager shareManager] showNotice:respondObject[@"message"]];
        }
        
        [BTHelper hideAllLoadingView];
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[BTNoticeShowManager shareManager] showNotice:operation.responseObject[@"message"]];
        [BTHelper hideAllLoadingView];
    }];
}

- (void)changeUserAvatar
{
    [BTHelper showHttpRequestLoadingOnController:self.view];
    
    [[BTLogin2RequestAPI loginManager] changeUserAvatarWithFiledata:self.avatarImageView.image Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        [BTHelper hideAllLoadingView];
        [self getUserInfoAndSave];
        [self enterMainInterface];
        //注册登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNFRegisterSuccess object:nil];
        
    } Fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[BTNoticeShowManager shareManager] showNotice:operation.responseObject[@"message"]];
        [BTHelper hideAllLoadingView];
        
    }];
}


//保存用户信息
- (void)getUserInfoAndSave
{
    [[BTLogin2RequestAPI loginManager] getUserInfo:0 Success:^(AFHTTPRequestOperation *operation, id respondObject) {
        
        [[BTUserInfo shareInstance] modifyInstanceInfoByDictionary:[respondObject objectForKey:@"Variables"]];
        
    } Fail:^(AFHTTPRequestOperation *operation, id respondObject) {
    }];
}

@end
