//
//  JSUserDefaultsWebView.m
//  NSLocalStorage
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSUserDefaultsWebView.h"

@interface JSUserDefaultsWebView ()

@property (nonatomic, assign) id<UIWebViewDelegate> originalDelegate;

- (NSDictionary *)dictionaryForQueryString:(NSString *)query;

@end


@implementation JSUserDefaultsWebView

@synthesize originalDelegate;

- (void)setValue:(id)value forKey:(id)key;
{
	NSLog(@"Setting %@ for key %@", value, key);
	if ([key isEqual:@"delegate"]) {
		if (value != self) {
			self.originalDelegate = value;
			self.delegate = self;
		}
		else {
			self.delegate = value;
		}
	}
	else {
		[super setValue:value forKey:key];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
	static NSString *sUserDefaultsJS = nil;
	if (!sUserDefaultsJS) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"JSUserDefaults" ofType:@"js"];
		sUserDefaultsJS = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] retain];
	}
	[self stringByEvaluatingJavaScriptFromString:sUserDefaultsJS];
	
	if (self.originalDelegate && [self.originalDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
		[self.originalDelegate webViewDidFinishLoad:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
	NSURL *url = [request URL];
	
	if (![url.scheme isEqual:@"NSUserDefaults"]) {
		if (self.originalDelegate && [self.originalDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
			return [self.originalDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
		else
			return YES;
	}
	
	NSString *command = [url host];
	NSDictionary *query = [self dictionaryForQueryString:[url query]];
	
	if ([command isEqual:@"get"]) {
		NSString *key = [query objectForKey:@"key"];
		NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
		NSString *callback = [NSString stringWithFormat:@"JSUserDefaults.callback('%@', '%@');", key, value];
		[self stringByEvaluatingJavaScriptFromString:callback];
	}
	else if ([command isEqual:@"set"]) {
		[[NSUserDefaults standardUserDefaults] setObject:[query objectForKey:@"value"] forKey:[query objectForKey:@"key"]];
	}
	
	return false;
}

- (NSDictionary *)dictionaryForQueryString:(NSString *)query;
{
	NSArray *components = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:components.count];
	for (NSString *component in components) {
		NSArray *keyValue = [component componentsSeparatedByString:@"="];
		if (keyValue.count != 2) continue;
		NSString *key = [keyValue objectAtIndex:0];
		NSString *value = [keyValue objectAtIndex:1];
		[dictionary setObject:value forKey:key];
	}
	return dictionary;
}

@end
