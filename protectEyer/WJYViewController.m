//
//  WJYViewController.m
//  protectEyer
//
//  Created by mac on 14-10-9.
//  Copyright (c) 2014年 wjy. All rights reserved.
//

#import "WJYViewController.h"
#import "FileService.h"
#import "Skin.h"

#import <QuartzCore/QuartzCore.h>



@interface WJYViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview_redCircle;
@property (weak, nonatomic) IBOutlet UIImageView *imageview_background;
@property (weak, nonatomic) IBOutlet UIButton *button_tip;
@property (weak, nonatomic) IBOutlet UIButton *button_homepage;
@property (weak, nonatomic) IBOutlet UIButton *button_datapage;
@property (weak, nonatomic) IBOutlet UIButton *button_settingpage;


@property(strong,nonatomic) Skin * skin;
@end

@implementation WJYViewController

UIApplication *app;
WJYAppDelegate *appDelegate;

@synthesize skin;


UIImageView * snail;
UIImageView * imageView_setTimeTip;
UIButton* button_mushroom;
UIButton * button_start;
UIButton * button_stop;
UIButton * button_time;
UIDatePicker * datePicker;
UIButton * button_datePicker;
UITextField * show_time;

NSTimer * showTime_timer;

double totalSeconds;
double leftSeconds;

-(void)changeSkin:(NSNotification *)notification
{
    NSNumber *number = [notification object];
    NSLog(@"已切换第%@皮肤", number);
    
    int num=[number intValue];
     switch (num) {
     case 0:
     skin=[[SkinOne alloc]init];
     case 1:
     skin=[[SkinTwo alloc]init];
     
     default:
     break;
     }
     [self change];
     //再重新调用重载界面 重载界面函数直接调用startview
     
}



-(void)change
{
    [snail setImage:[skin getViewSnail]];
    [_imageview_redCircle setImage:[skin getViewPanel]];
    [button_start setImage:[skin getButtonStart] forState:UIControlStateNormal];
    [button_stop setImage:[skin getButtonStop] forState:UIControlStateNormal];
    
    [_imageview_background setImage:[skin getViewHomepage]];
    
    [_button_homepage setImage:[skin getButtonToHomepage] forState:UIControlStateNormal];
    [_button_settingpage setImage:[skin getButtonToSettingpage] forState:UIControlStateNormal];
    [_button_datapage setImage:[skin getButtonToSettingpage] forState:UIControlStateNormal];
    [_button_tip setImage:[skin getButtonToTippage] forState:UIControlStateNormal];
    [_button_homepage setImage:[skin getButtonToHomepage] forState:UIControlStateNormal];
    
    [imageView_setTimeTip setImage:[UIImage imageNamed:@"setTime_tip"]];
    [snail setImage:[skin getViewSnail]];

    [button_start setImage:[skin getButtonStart] forState:UIControlStateNormal];
    [button_stop setImage:[skin getButtonStop] forState:UIControlStateNormal];
    
    [button_mushroom setImage:[skin getButtonMushroom] forState:UIControlStateNormal];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSkin:) name:@"SkinNotification" object:nil];//注册换皮肤监听
    skin = [[SkinOne alloc] init];
    
    snail=[[UIImageView alloc]initWithFrame:CGRectMake(138, 120, 44, 34)];
    snail.center=CGPointMake(_imageview_redCircle.center.x, _imageview_redCircle.center.y-120);
    
    imageView_setTimeTip=[[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 240, 118)];
   
    
    button_start=[[UIButton alloc]initWithFrame:CGRectMake(100, 198, 120, 120)];//相对位置
    button_start.center=CGPointMake(_imageview_redCircle.center.x, _imageview_redCircle.center.y);
    [button_start addTarget:self action:@selector(touch_start) forControlEvents:UIControlEventTouchUpInside];
    
    
    button_stop=[[UIButton alloc]initWithFrame:CGRectMake(130, 288, 60, 60)];
    button_stop.center=CGPointMake (_imageview_redCircle.center.x, _imageview_redCircle.center.y+50);//相对位置

    [button_stop addTarget:self action:@selector(touch_stop) forControlEvents:UIControlEventTouchUpInside];
    
    button_time=[[UIButton alloc]initWithFrame:CGRectMake(115, 90, 90, 50)];
    button_time.center=CGPointMake(_imageview_redCircle.center.x, _imageview_redCircle.center.y-130);
    [button_time setTitle:@"0时30分" forState:UIControlStateNormal];
    [button_time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_time addTarget:self action:@selector(touch_time) forControlEvents:UIControlEventTouchUpInside];
    
    datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, 160, 120)];
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.alpha=0.5;
    datePicker.datePickerMode=UIDatePickerModeCountDownTimer;
    
    button_datePicker=[[UIButton alloc]initWithFrame:CGRectMake(120, 260, 80, 40)];
    [button_datePicker setTitle:@"确定" forState:UIControlStateNormal];
    [button_datePicker setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button_datePicker addTarget:self action:@selector(touch_datePicker) forControlEvents:UIControlEventTouchUpInside];
    
    show_time=[[UITextField alloc]initWithFrame:CGRectMake(80, 228, 160, 60)];
    show_time.center= CGPointMake( _imageview_redCircle.center.x, _imageview_redCircle.center.y-30);//相对位置
    show_time.textAlignment=UITextAlignmentCenter;
    show_time.font=[UIFont fontWithName:@"Times New Roman" size:25];
    show_time.textColor=[UIColor whiteColor];
    show_time.backgroundColor=[UIColor clearColor];
    
    NSDate *startTime=[FileService getStartTime];
    double totalSeconds=[FileService getTotalSeconds];
    NSDate *now=[NSDate date];
    
    double secondsBetweenDates= [now timeIntervalSinceDate:startTime];
    leftSeconds=(totalSeconds-secondsBetweenDates);

    if (leftSeconds>0){
        [self.view addSubview:snail];
        [self.view addSubview:button_stop];
        [self.view addSubview:show_time];
        [self.view addSubview:datePicker];
        
        [self nailRun:totalSeconds leftSeconds:leftSeconds];
        
        
//        button_mushroom=[[UIButton alloc]initWithFrame:CGRectMake(134, 100, 52, 43)];
//        [button_start setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
//        [button_start addTarget:self action:@selector(touch_start) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
        button_mushroom=[[UIButton alloc]initWithFrame:CGRectMake(134, 100, 52, 43)];
        button_mushroom.center=CGPointMake(_imageview_redCircle.center.x, _imageview_redCircle.center.y-130);//相对坐标
        
        [button_mushroom addTarget:self action:@selector(touch_mushroom:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button_mushroom];
        [self.view addSubview:button_start];
        [self.view addSubview:imageView_setTimeTip];
        
        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
        animation.duration=0.08;
        animation.repeatCount=10000;
        animation.autoreverses=YES;
        animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate(imageView_setTimeTip.layer.transform,-0.04 , 0, 0, 0.03)];
        animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(imageView_setTimeTip.layer.transform, 0.04, 0, 0, 0.03)];
        [imageView_setTimeTip.layer addAnimation:animation forKey:@"shake"];
        
        //监听是否触发home键挂起程序.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pause)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        //监听是否重新进入程序程序.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resume)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    [self change];
}


/*- (void)viewWillDisappear:(BOOL)animated{
    [self pauseLayer];
    NSLog(@"disapper");
}

- (void)viewWillAppear:(BOOL)animated{
    [self resumeLayer];
    NSLog(@"apper");
}*/


/*-(void)pauseLayer //暂停动画
 
 {
 NSLog(@"pause");
 CFTimeInterval pausedTime = [_nail.layer convertTime:CACurrentMediaTime() fromLayer:nil];
 _nail.layer.speed = 0.0;
 _nail.layer.timeOffset = pausedTime;
 }
 
 -(void)resumeLayer //恢复动画
 {
 NSLog(@"resume");
 CFTimeInterval pausedTime = [_nail.layer timeOffset];
 _nail.layer.speed = 1.0;
 _nail.layer.timeOffset = 0.0;
 _nail.layer.beginTime = 0.0;
 CFTimeInterval timeSincePause = [_nail.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
 _nail.layer.beginTime = timeSincePause;
 }*/

-(void) pause{
    NSLog(@"pause");
}

-(void) resume{
    NSLog(@"resume");
    NSDate *startTime=[FileService getStartTime];
    double totalSeconds=[FileService getTotalSeconds];
    NSDate *now=[NSDate date];
    
    double secondsBetweenDates= [now timeIntervalSinceDate:startTime];
    leftSeconds=(totalSeconds-secondsBetweenDates);
    if(leftSeconds>0){
        [self nailRun:totalSeconds leftSeconds:leftSeconds];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nailRun:(double) totalSeconds leftSeconds:(double) leftSeconds
{
    //uiview animationWithDuration
    double rate=(totalSeconds-leftSeconds)/totalSeconds;
    NSLog(@"%f",rate);
    CAKeyframeAnimation *anim=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef movePath=CGPathCreateMutable();
    CGPathAddArc(movePath, nil, _imageview_redCircle.center.x, _imageview_redCircle.center.y, 120, -M_PI/2+M_PI*2*rate,M_PI*3/2, NO); //以红色圆圈为的中心为圆心
    anim.path=movePath;
    
    CAKeyframeAnimation *anim2=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSLog(@"%f",rate);
    if(rate<0.25){
        anim2.values=[NSArray arrayWithObjects:
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2*rate, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*3/2, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0,1)],
                      nil];
    }else if(rate<0.5){
        anim2.values=[NSArray arrayWithObjects:
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2*rate, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*3/2, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0,1)],
                      nil];
    }else if(rate<0.75){
        anim2.values=[NSArray arrayWithObjects:
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2*rate, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*3/2, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0,1)],
                      nil];
    }else{
        anim2.values=[NSArray arrayWithObjects:
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2*rate, 0, 0,1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0,1)],
                      nil];
    }
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations=[NSArray arrayWithObjects:anim,anim2,nil];
    animationGroup.duration=leftSeconds;
    animationGroup.repeatCount=1;
    
    [snail.layer addAnimation:animationGroup forKey:@"move"];
}

- (IBAction)touch_mushroom:(UIButton *)sender {
    
    CATransform3D ca=CATransform3DMakeScale(2, 2, 1);
    CABasicAnimation *anim=[CABasicAnimation animationWithKeyPath:@"transform"];
    anim.toValue=[NSValue valueWithCATransform3D:ca];
    anim.duration=2;
    sender.layer.anchorPoint = CGPointMake(0.5,0.5);
    [sender.layer addAnimation:anim forKey:nil];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(mushroom_animation) userInfo:nil repeats:NO];
    
    [sender setUserInteractionEnabled:NO];
    [imageView_setTimeTip removeFromSuperview];
}

- (void)mushroom_animation{
    button_mushroom.layer.anchorPoint=CGPointMake(0.5,0.5);
    button_mushroom.layer.transform=CATransform3DMakeScale(2, 2, 1);
    [self.view addSubview:button_time];

}

- (void) touch_start
{
    if (totalSeconds==0) {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@"提示"
                            message:@"您还未设置时间"
                            delegate:nil
                            cancelButtonTitle:@"确定"
                            otherButtonTitles:nil
                            ];
        [alert show];
    }else{
        [FileService setTotalSeconds:totalSeconds];
        [FileService setStartTime:[NSDate date]];
        
        [button_start removeFromSuperview];
        [self.view addSubview:button_stop];
        
        [self.view addSubview:snail];
        [self.view addSubview:show_time];
        [self nailRun:totalSeconds leftSeconds:totalSeconds];
        
        leftSeconds=totalSeconds;
        showTime_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(show_time) userInfo:nil repeats:YES];
        
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:totalSeconds];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.repeatInterval=kCFCalendarUnitMinute;
        notification.alertBody=@"时间到了";
        notification.applicationIconBadgeNumber=1;
        [app scheduleLocalNotification:notification];
    }
}

- (void) show_time{
    leftSeconds-=1;
    NSInteger hours=(NSInteger)leftSeconds/3600;
    NSInteger minutes=(NSInteger)leftSeconds/60%60;
    NSInteger seconds=(NSInteger)leftSeconds%3600%60;
    NSLog(@"%ld %ld %ld",hours,minutes,seconds);
    if (hours!=0||minutes!=0||seconds!=0) {
        [show_time setText:[NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hours,(long)minutes,(long)seconds]];
    }else{
        [show_time setText:@"00时00分00秒"];
        [showTime_timer invalidate];
        [self returnToInitate];
    }
    
}

- (void) touch_time
{
    [self.view addSubview:datePicker];

    [self.view addSubview:button_datePicker];
    
}

- (void) touch_datePicker
{
    totalSeconds=datePicker.countDownDuration;
    NSLog(@"TIME:%ld",(long)totalSeconds);
    NSInteger hours=(NSInteger)totalSeconds/3600;
    NSInteger minutes=(NSInteger)totalSeconds/60%60;
    
    NSString *msg=[NSString stringWithFormat:@"%ld时%ld分",(long)hours,(long)minutes];
    [button_time setTitle:msg forState:UIControlStateNormal];
    
    [datePicker removeFromSuperview];
    [button_datePicker removeFromSuperview];
}

- (void) touch_stop{
    if ([FileService getPasswordFlag]) {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@"设置"
                            message:@"请输入密码"
                            delegate:self
                            cancelButtonTitle:@"确定"
                            otherButtonTitles:nil
                            ];
        alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
        [alert show];
    }else{
        //停止服务，回到初始状态
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSString *msg=[alertView textFieldAtIndex:0].text;
        if([msg isEqualToString:[FileService getPassword]]){
            //停止服务，回到初始状态
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:@"提示"
                                message:@"密码错误"
                                delegate:nil
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil
                                ];
            [alert show];
        }
    }
}

- (void)returnToInitate{
    [snail removeFromSuperview];
    [button_stop removeFromSuperview];
    [show_time removeFromSuperview];
    [self.view addSubview:button_start];
}



@end
