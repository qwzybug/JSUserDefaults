//
//  JSUserDefaultsViewController.m
//  JSUserDefaults
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSUserDefaultsViewController.h"

@implementation JSUserDefaultsViewController

@synthesize webView;

- (void)dealloc;
{
	[webView release], webView = nil;
    [super dealloc];
}

- (void)viewDidLoad;
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"html"];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:req];
}

- (IBAction)reloadAction:(id)sender;
{
	[self.webView reload];
}

@end
