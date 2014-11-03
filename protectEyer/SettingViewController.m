//
//  SettingViewController.m
//  protectEyer
//
//  Created by mac on 14-10-13.
//  Copyright (c) 2014年 wjy. All rights reserved.
//

#import "SettingViewController.h"
#import "FileService.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

UIImageView * passwordProtectionPositive;
UIImageView * passwordProtectionNegative;
UIButton * button_passwordReset;
UIButton * button_passwordProtectionOpen;
UIButton * button_passwordProtectionClose;

NSString *password1;
NSString *password2;

//监听密码保护状态
bool passwordProtection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    passwordProtection=[FileService getPasswordFlag];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    passwordProtectionNegative = [[UIImageView alloc]initWithFrame:CGRectMake(60, 140, 130, 18)];
    [passwordProtectionNegative setImage:[UIImage imageNamed:@"setting_close_word"]];
    
    passwordProtectionPositive = [[UIImageView alloc]initWithFrame:CGRectMake(60, 140, 130, 18)];
    [passwordProtectionPositive setImage:[UIImage imageNamed:@"setting_open_word"]];
    
    button_passwordReset = [[UIButton alloc]initWithFrame:CGRectMake(25, 230, 270, 50)];
    [button_passwordReset setImage:[UIImage imageNamed:@"setting_reset_password"] forState:UIControlStateNormal];
    [button_passwordReset addTarget:self action:@selector(touch_passwordReset) forControlEvents:UIControlEventTouchUpInside];
    
    button_passwordProtectionOpen = [[UIButton alloc]initWithFrame:CGRectMake(220, 130, 50, 40)];
    [button_passwordProtectionOpen setImage:[UIImage imageNamed:@"setting_open"] forState:UIControlStateNormal];
    [button_passwordProtectionOpen addTarget:self action:@selector(touch_passwordProtectionOpen) forControlEvents:UIControlEventTouchUpInside];
    
    
    button_passwordProtectionClose = [[UIButton alloc]initWithFrame:CGRectMake(220, 130, 50, 40)];
    [button_passwordProtectionClose setImage:[UIImage imageNamed:@"setting_close"] forState:UIControlStateNormal];
    [button_passwordProtectionClose addTarget:self action:@selector(touch_passwordProtectionClose) forControlEvents:UIControlEventTouchUpInside];
    
    if([FileService getPasswordFlag]){
        [self.view addSubview:button_passwordProtectionClose];
        [self.view addSubview:passwordProtectionPositive];
    }else{
        [self.view addSubview:button_passwordProtectionOpen];
        [self.view addSubview:passwordProtectionNegative];
    }
    [self.view addSubview:button_passwordReset];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置密码保护状态
- (void)setPasswordProtection:(bool)passwordProtection {
    
    if (passwordProtection == true) {
        [self.view addSubview:passwordProtectionPositive];
        [passwordProtectionNegative removeFromSuperview];
        [self.view addSubview:button_passwordProtectionClose];
        [button_passwordProtectionOpen removeFromSuperview];
        
    }
    else{
        [passwordProtectionPositive removeFromSuperview];
        [self.view addSubview:passwordProtectionNegative];
        [button_passwordProtectionClose removeFromSuperview];
        [self.view addSubview:button_passwordProtectionOpen];
    }
}



//打开密码保护
- (void)touch_passwordProtectionOpen{
    
    passwordProtection = true;
    [FileService changePasswordFlag];
    [self setPasswordProtection:passwordProtection];
}



//关闭密码保护
- (void)touch_passwordProtectionClose{
    
    passwordProtection = false;
    [FileService changePasswordFlag];
    [self setPasswordProtection:passwordProtection];
    
}


//重置密码
- (void)touch_passwordReset{
    if(![FileService getPasswordFlag]){
        [FileService changePasswordFlag];
    }
    UIAlertView *alert1=[[UIAlertView alloc]
                         initWithTitle:@"设置"
                         message:@"请输入新密码"
                         delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil
                         ];
    alert1.tag=1;
    alert1.alertViewStyle=UIAlertViewStyleSecureTextInput;
    [alert1 show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
        if(buttonIndex==0){
            password1=[alertView textFieldAtIndex:0].text;
            
            UIAlertView *alert2=[[UIAlertView alloc]
                                 initWithTitle:@"设置"
                                 message:@"请确认新密码"
                                 delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil
                                 ];
            alert2.tag=2;
            alert2.alertViewStyle=UIAlertViewStyleSecureTextInput;
            [alert2 show];
            
        }
    }else if(alertView.tag==2){
        if (buttonIndex==0) {
            password2=[alertView textFieldAtIndex:0].text;
            if ([password1 isEqualToString:password2]) {
                [FileService changePassword:password1];
                UIAlertView *alert=[[UIAlertView alloc]
                                    initWithTitle:@"提示"
                                    message:@"密码修改成功"
                                    delegate:nil
                                    cancelButtonTitle:@"确定"
                                    otherButtonTitles:nil
                                    ];
                [alert show];

            }else{
                UIAlertView *alert=[[UIAlertView alloc]
                                    initWithTitle:@"警告"
                                    message:@"密码不一致"
                                    delegate:nil
                                    cancelButtonTitle:@"确定"
                                    otherButtonTitles:nil
                                    ];
                [alert show];
            }
        }
    }
    
}

@end
