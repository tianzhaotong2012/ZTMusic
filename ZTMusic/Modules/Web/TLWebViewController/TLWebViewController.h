//
//  TLWebViewController.h
//  TLChat
//
//  Created by lbk on 16/2/10.
//  Copyright © 2016年 lbk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface TLWebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property(nonatomic,weak) UINavigationController *navigationController;

@property (nonatomic, strong) WKWebView *webView;

/// 是否使用网页标题作为nav标题，默认YES
@property (nonatomic, assign) BOOL useMPageTitleAsNavTitle;

/// 是否显示加载进度，默认YES
@property (nonatomic, assign) BOOL showLoadingProgress;

/// 是否禁止历史记录，默认NO
@property (nonatomic, assign) BOOL disableBackButton;

/// 是否显示网页的来源信息，默认YES
@property (nonatomic, assign) BOOL showPageInfo;

@property (nonatomic, assign) BOOL requestSuccess;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, copy) void (^closeAction)(void);

- (id)initWithUrl:(NSString *)urlString;

- (id)initWithRequest:(NSURLRequest *)request;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)clearCookies;

@end
