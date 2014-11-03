//
//  SkinViewController.m
//  protectEyer
//
//  Created by Albert on 14/10/29.
//  Copyright (c) 2014年 wjy. All rights reserved.
//

#import "SkinViewController.h"

@interface SkinViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
@implementation SkinViewController

@synthesize scrollView=_scrollView;
@synthesize pageControl;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height )];
    _scrollView.pagingEnabled=YES;  //设置移动的时候是一张一张的
    _scrollView.bounces=NO;
    [_scrollView setDelegate:self];
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    UIImageView *imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,_scrollView.frame.size.width, _scrollView.frame.size.height)];
    [imageview1 setImage:[UIImage imageNamed:@"1_background"]];
    
    UIImageView *imageview2=[[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width,0,_scrollView.frame.size.width, _scrollView.frame.size.height)];
    [imageview2 setImage:[UIImage imageNamed:@"2_background"]];
    
    UIImageView *imageview3=[[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.height*2,0,_scrollView.frame.size.width, _scrollView.frame.size.height)];
    [imageview3 setImage:[UIImage imageNamed:@"mushroom"]];
    
    [_scrollView addSubview:imageview1];
    [_scrollView addSubview:imageview2];
    [_scrollView addSubview:imageview3];
    
    [pageControl setFrame:CGRectMake(0,0,_scrollView.frame.size.width, _scrollView.frame.size.height)];
    pageControl.numberOfPages=3;
    pageControl.currentPage=0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    

}
#pragma
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset=_scrollView.contentOffset;
    CGRect bounds=_scrollView.frame;
    [pageControl setCurrentPage:offset.x/bounds.size.width];
}
//页面跟随着pagecontrol变化
- (IBAction)pageTurn:(UIPageControl *)sender {
    CGRect rect =CGRectMake(sender.currentPage * _scrollView.frame.size.width, 0,_scrollView.frame.size.width , _scrollView.frame.size.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectSkin:(id)sender {
    NSInteger skinpage = pageControl.currentPage;
    NSNumber *skinnumber = [NSNumber numberWithInt:skinpage];
    NSLog(@"第%@种皮肤",skinnumber);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SkinNotification" object:skinnumber];
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
