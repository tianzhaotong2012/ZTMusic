//
//  ZTAppDelegate.m
//  ZTMusic
//
//  Created by 李伯坤 on 2018/7/30.
//  Copyright © 2018年 李伯坤. All rights reserved.
//

#import "ZTAppDelegate.h"
#import "ZTLauncherManager.h"

#import <AVFoundation/AVFoundation.h>
#import "ZTPlayerManager.h"

@interface ZTAppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskId;
@property (nonatomic, strong) NSTimer *bgTaskTimer;

@end

@implementation ZTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
//    [[LCSDKManager sharedInstance] launchWithOptions:launchOptions];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    [audioSession setActive:YES error:nil];
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[ZTPlayerManager sharedInstance].player setVolume:audioSession.outputVolume];
    
    [[ZTLauncherManager sharedInstance] launchInWindow:self.window];
    
    return YES;
}


@end
