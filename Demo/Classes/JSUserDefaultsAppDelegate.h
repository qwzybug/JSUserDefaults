//
//  JSUserDefaultsAppDelegate.h
//  JSUserDefaults
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSUserDefaultsViewController;

@interface JSUserDefaultsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    JSUserDefaultsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet JSUserDefaultsViewController *viewController;

@end

