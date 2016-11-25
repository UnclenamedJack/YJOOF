//
//  resultVC.m
//  ProjectOne-weibao
//
//  Created by jack on 16/5/25.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "resultVC.h"

@interface resultVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation resultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.textView.hidden == NO && self.webView.hidden == NO) {
        if ([self.result hasPrefix:@"http"]) {
            NSURL *url = [NSURL URLWithString:self.result];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
            self.textView.hidden = YES;
        }else{
            self.textView.text = self.result;
            self.webView.hidden = YES;
        }
    }
}
- (void)setResult:(NSString *)result {
    _result = result;
    if (self.webView == nil) {
        return;
    }
    if ([result hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:result];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        self.textView.hidden = YES;
    }
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
