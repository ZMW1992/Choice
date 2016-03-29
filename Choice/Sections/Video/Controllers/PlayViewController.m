//
//  PlayViewController.m
//  Choice
//
//  Created by lanouhn on 16/1/14.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()



@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *aURL = [NSString stringWithFormat:@"http://v.youku.com/v_show/id_%@.html", self.url];
    
    
    UIWebView *webView = [[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 240)]autorelease];
    [self.view addSubview:webView];
    
//    webView.backgroundColor = [UIColor yellowColor];
    
    webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:aURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    [webView release];
    
    
    
    
//    
//    UILabel *aLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 60, 320, 40)]autorelease];
//    
//    aLabel.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:aLabel];
//    [aLabel release];
    
    
    

    
    // 禁用拖拽时的反弹效果
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    
    UIScrollView *scollview=(UIScrollView *)[[webView subviews]objectAtIndex:0];
    
    scollview.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
    // 禁止webView滚动
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setScrollEnabled:NO];
    
    
    
    
    
//    UILabel *bLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 320, 320, 40)]autorelease];
//    
//    bLabel.backgroundColor = [UIColor yellowColor];
//    
//    [scollview addSubview:bLabel];
//    [bLabel release];
    
    // Do any additional setup after loading the view.
}


- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
