//
//  TLWebViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/10.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLWebViewController.h"
#import "UIBarButtonItem+Back.h"
#import "WKWebView+Post.h"
#import "WKWebViewJavascriptBridge+TLJSBridge.h"
#import "WebViewJavascriptBridge.h"

#define     WEBVIEW_NAVBAR_ITEMS_FIXED_SPACE        9

@interface TLWebViewController ()

@property (nonatomic, strong) WebViewJavascriptBridge *jsBradge;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;

@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;

@property (nonatomic, strong) UILabel *authLabel;

@end

@implementation TLWebViewController

- (id)init
{
    if (self = [super init]) {
        self.useMPageTitleAsNavTitle = YES;
        self.showLoadingProgress = YES;
        self.showPageInfo = YES;
    }
    return self;
}

- (id)initWithUrl:(NSString *)urlString
{
    if (self = [self init]) {
        [self setUrl:urlString];
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        [self loadRequest:request];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain actionBlick:nil]];
    
    [self.view addSubview:self.authLabel];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    self.jsBradge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.jsBradge setWebViewDelegate:self];
    [(WKWebViewJavascriptBridge *)self.jsBradge registerNativeAction];
    
//    @weakify(self);
//    [self addRightBarButtonWithImage:[UIImage imageNamed:@"nav_more"] actionBlick:^{
//        @strongify(self);
//        [LCShareKit showWebViewShareViewWithUrl:self.webView.URL.absoluteString eventAction:^(NSInteger eventType) {
//            @strongify(self);
//            [self.webView reload];
//        }];
//    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(GRAY_BG);
    self.webView.scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(GRAY_BG);
    for (UIView *view in self.webView.scrollView.subviews) {
        NSString *className = NSStringFromClass([view class]);
        if ([className isEqualToString:@"WKContentView"]) {
            view.dk_backgroundColorPicker = DKColorPickerWithKey(GRAY_BG);
            break;
        }
    }
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView.scrollView addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)dealloc
{
    @try {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView.scrollView removeObserver:self forKeyPath:@"backgroundColor"];
    }
    @catch (NSException *exception) {
        NSLog(@"【TLWebVC】移除kvo失败");
    }
    NSLog(@"【TLWebVC】dealloc");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.isHidden ? 0 : TABBAR_HEIGHT;
    CGFloat width = self.view.bounds.size.width;
    [self.progressView setY:statusBarHeight + navBarHeight];
    [self.authLabel setFrame:CGRectMake(20, statusBarHeight + navBarHeight + 13, width - 40, self.authLabel.frame.size.height)];
    [self.webView setHeight:SCREEN_HEIGHT - NAVBAR_HEIGHT - STATUSBAR_HEIGHT - tabBarHeight];
}

#pragma mark - # Public Methods
- (void)setUrl:(NSString *)url
{
    _url = url;
    [self.progressView setProgress:0.0f];
    [self.webView loadRequest:[NSURLRequest requestWithURL:TLURL(url)]];
}

- (void)setShowLoadingProgress:(BOOL)showLoadingProgress
{
    _showLoadingProgress = showLoadingProgress;
    [self.progressView setHidden:!showLoadingProgress];
}

- (void)loadRequest:(NSURLRequest *)request
{
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if (string) {
        [self.webView loadHTMLString:string baseURL:baseURL];
    }
}

- (void)clearCookies
{
    // 删除cookie信息
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    // 删除cookie文件夹，兼容wkwebview删除cookie出现延迟的问题
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
}

#pragma mark - # Delegate
//MARK: WKNavigationDelegate
// 开始加载页面
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

// 开始返回页面内容
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [self p_addBackButtonIfNeed];
}

// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.requestSuccess = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (self.useMPageTitleAsNavTitle) {
        [self.navigationItem setTitle:webView.title];
    }
    if (self.showPageInfo) {
        if (webView.URL.host.length > 0) {
            [self.authLabel setText:[NSString stringWithFormat:@"网页由 %@ 提供", webView.URL.host]];
        }
        else {
            [self.authLabel setText:@""];
        }
        [self.authLabel setHeight:[self.authLabel sizeThatFits:CGSizeMake(self.authLabel.width, MAXFLOAT)].height];
    }
    
//    if ([LCAppConfig sharedInstance].night) {
//        [webView evaluateJavaScript:@"javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=80,sel='body,body *';styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return'background-color:#343434 !important;color:RGB('+colorArr.join('%,')+'%) !important;'};function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName('head')[0],styleElem=styleElem;if(!styleElem){s=doc.createElement('style');s.setAttribute('type','text/css');styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)};if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML='';styleElem.appendChild(doc.createTextNode(sel+' {'+decl+'}'))};return styleElem}})();" completionHandler:nil];
//    }
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    self.requestSuccess = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (error.code != NSURLErrorCancelled) {
        @weakify(self);
        [self.webView showErrorViewWithTitle:@"请求失败，请点击重试" retryAction:^(id userData) {
            @strongify(self);
            [self setUrl:self.url];
        }];
    }
}

// 页面跳转处理
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    if ([urlString hasPrefix:@"itms-apps://itunes.apple.com"]
        || [urlString hasPrefix:@"https://itunes.apple.com"]
        || [urlString hasPrefix:@"itms-services:"]
        || [urlString hasPrefix:@"tel:"]
        || [urlString hasPrefix:@"mailto:"]
        || [urlString hasPrefix:@"mqqwpa:"]
        || [urlString hasPrefix:@"alipay:"] || [urlString hasPrefix:@"alipays:"]
        || [urlString containsString:@"target=safari"]
        ) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    // 统跳url拦截
    if ([[LCRouter router] canRouterUrl:navigationAction.request.URL.absoluteString]) {
        [[LCRouter router] openUrl:navigationAction.request.URL.absoluteString];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    //如果是跳转一个新页面
    else if (navigationAction.targetFrame == nil) {
        if ([[LCRouter router] canOpenUrl:navigationAction.request.URL.absoluteString]) {
            [[LCRouter router] openUrl:navigationAction.request.URL.absoluteString];
        }
        else {
            TLWebViewController *webVC = [[TLWebViewController alloc] initWithRequest:navigationAction.request];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (navigationAction.sourceFrame) {
        [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem fixItemSpace:-WEBVIEW_NAVBAR_ITEMS_FIXED_SPACE], self.backButtonItem, self.closeButtonItem]];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    [self p_addBackButtonIfNeed];
}

//MARK: WKUIDelegate
/// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:webView.URL.host ? webView.URL.host : @"来自网页的弹窗" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];

    [self presentViewController:alertController animated:YES completion:^{}];
}

/// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:webView.URL.host ? webView.URL.host : @"来自网页的弹窗" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:webView.URL.host ? webView.URL.host : @"来自网页的弹窗" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *__textField;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        __textField = textField;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(__textField.text);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

/// 创建新的webView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(nonnull WKWebViewConfiguration *)configuration forNavigationAction:(nonnull WKNavigationAction *)navigationAction windowFeatures:(nonnull WKWindowFeatures *)windowFeatures
{
    if (navigationAction.targetFrame == nil) {
        if ([[LCRouter router] canOpenUrl:navigationAction.request.URL.absoluteString]) {
            [[LCRouter router] openUrl:navigationAction.request.URL.absoluteString];
        }
        else {
            TLWebViewController *webVC = [[TLWebViewController alloc] initWithRequest:navigationAction.request];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
    else {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - # Private Methods
- (void)p_addBackButtonIfNeed
{
    if (self.webView.canGoBack) {
        if (self.navigationController.childViewControllers.count > 1) {
            [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem fixItemSpace:-WEBVIEW_NAVBAR_ITEMS_FIXED_SPACE], self.backButtonItem, self.closeButtonItem]];
        }
        else {
            [self.navigationItem setLeftBarButtonItem:self.backButtonItem];
        }
    }
    else {
        if (self.navigationController.childViewControllers.count == 1) {
            [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem new]];
        }
    }
}

#pragma mark - # Event Response
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (self.showLoadingProgress && [keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else if ([keyPath isEqualToString:@"backgroundColor"] && object == self.webView.scrollView) {
        UIColor *color = [change objectForKey:@"new"];
        if (!CGColorEqualToColor(color.CGColor, [UIColor clearColor].CGColor)) {
            [object setBackgroundColor:[UIColor clearColor]];
        }
    }
}

- (void)navBackButotnDown
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.closeAction) {
            self.closeAction();
        }
    }
}

- (void)navCloseButtonDown
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.closeAction) {
        self.closeAction();
    }
}

#pragma mark - # Getters
- (WKWebView *)webView
{
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVBAR_HEIGHT) configuration:config];
        [_webView setAllowsBackForwardNavigationGestures:YES];
        [_webView setNavigationDelegate:self];
        [_webView setUIDelegate:self];
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH, 10.0f)];
        [_progressView setTransform:CGAffineTransformMakeScale(1.0f, 2.0f)];
        [_progressView setProgressTintColor:RGBAColor(2.0, 187.0, 0.0, 1.0f)];
        [_progressView setTrackTintColor:[UIColor clearColor]];
        [_progressView setProgress:0];
    }
    return _progressView;
}

- (UIBarButtonItem *)backButtonItem
{
    if (_backButtonItem == nil) {
        _backButtonItem = [[UIBarButtonItem alloc] initWithBackTitle:@"返回" target:self action:@selector(navBackButotnDown)];
    }
    return _backButtonItem;
}

- (UIBarButtonItem *)closeButtonItem
{
    if (_closeButtonItem == nil) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(navCloseButtonDown)];
    }
    return _closeButtonItem;
}

- (UILabel *)authLabel
{
    if (_authLabel == nil) {
        _authLabel = [[UILabel alloc] init];
        [_authLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_authLabel setTextAlignment:NSTextAlignmentCenter];
        [_authLabel setTextColor:[UIColor grayColor]];
        [_authLabel setNumberOfLines:0];
    }
    return _authLabel;
}

- (void)tabBarItemDidDoubleClick
{
    if (self.webView.scrollView.contentOffset.y > 0) {
        [self.webView.scrollView scrollToTopWithAnimation:YES];
    }
    else {
        [self setUrl:self.webView.URL.absoluteString];
    }
}

@end
