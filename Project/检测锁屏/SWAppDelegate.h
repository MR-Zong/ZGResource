//
//  SWAppDelegate.h
//  lockstatenotificationstest
//
//  Created by Spencer Williams on 1/17/13.
//  Copyright (c) 2013 Spencer Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) startCaptureAndUpload;
- (void) stopCaptureAndUpload;

@end
