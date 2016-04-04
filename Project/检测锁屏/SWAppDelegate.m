//
//  SWAppDelegate.m
//  lockstatenotificationstest
//
//  Created by Spencer Williams on 1/17/13.
//  Copyright (c) 2013 Spencer Williams. All rights reserved.
//

#import "SWAppDelegate.h"

//call back
static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
    CFStringRef nameCFString = (CFStringRef)name;
    NSString *notificationName =  (__bridge NSString*)nameCFString;
    NSLog(@"Darwin notification NAME = %@",name);
    
    if ([notificationName isEqualToString:@"com.apple.springboard.lockcomplete"]) {
        [((SWAppDelegate *)[[UIApplication sharedApplication] delegate]) startCaptureAndUpload];
    } else if ([notificationName isEqualToString:@"com.apple.springboard.lockstate"]) {
        [((SWAppDelegate *)[[UIApplication sharedApplication] delegate]) stopCaptureAndUpload];
    }
}

@interface SWAppDelegate()
- (void)registerForDeviceLockNotifications;
@end

@implementation SWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self registerForDeviceLockNotifications];
    
    return YES;
}
  						
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self stopCaptureAndUpload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self startCaptureAndUpload];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self stopCaptureAndUpload];
}

- (void)registerForDeviceLockNotifications
{
    NSLog(@"registering for device lock notifications");
    
    // Screen lock notifications
    // note that the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
    // this implementation courtesy of:
    // http://stackoverflow.com/questions/14229955/is-there-a-way-to-check-if-the-ios-device-is-locked-unlocked/14271472#14271472
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockcomplete"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockstate"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}


- (void)startCaptureAndUpload
{
    NSLog(@"start capture and upload");
}
- (void)stopCaptureAndUpload
{
    NSLog(@"stop capture and upload");
}

@end
