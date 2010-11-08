//
//  JSUserDefaultsWebView.m
//  NSLocalStorage
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSUserDefaultsWebView.h"

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

#import "CJSONSerializer_StringExtensions.h"
#import "CJSONDeserializer_StringExtensions.h"

@interface JSUserDefaultsWebView ()

@property (nonatomic, assign) id<UIWebViewDelegate> originalDelegate;

- (NSDictionary *)dictionaryForQueryString:(NSString *)query;

@end


@implementation JSUserDefaultsWebView

@synthesize originalDelegate;

- (void)setValue:(id)value forKey:(id)key;
{
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

#pragma mark -
#pragma mark Web view delegate

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
		NSString *jsonKey = [[CJSONSerializer serializer] serializeObject:key asStringWithEncoding:NSUTF8StringEncoding error:nil];
		id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
		NSString *jsonValue = [[CJSONSerializer serializer] serializeObject:value asStringWithEncoding:NSUTF8StringEncoding error:nil];
		NSString *callback = [NSString stringWithFormat:@"JSUserDefaults.callback(%@, %@);", jsonKey, jsonValue];
		[self stringByEvaluatingJavaScriptFromString:callback];
	}
	else if ([command isEqual:@"set"]) {
		[[NSUserDefaults standardUserDefaults] setObject:[query objectForKey:@"value"] forKey:[query objectForKey:@"key"]];
	}
	
	return false;
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
	static NSString *sUserDefaultsJS = nil;
	if (!sUserDefaultsJS) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"JSUserDefaults" ofType:@"js"];
		sUserDefaultsJS = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] retain];
	}
	[self stringByEvaluatingJavaScriptFromString:sUserDefaultsJS];
	
	if (self.originalDelegate && [self.originalDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
		[self.originalDelegate webViewDidStartLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if (self.originalDelegate && [self.originalDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
		[self.originalDelegate webView:webView didFailLoadWithError:error];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	if (self.originalDelegate && [self.originalDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
		[self.originalDelegate webViewDidFinishLoad:webView];
}

#pragma mark -
#pragma mark Support

- (NSDictionary *)dictionaryForQueryString:(NSString *)query;
{
	NSArray *components = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:components.count];
	for (NSString *component in components) {
		NSArray *keyValue = [component componentsSeparatedByString:@"="];
		if (keyValue.count != 2) continue;
		NSString *key = [[keyValue objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *value = [[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSError *err = nil;
		value = [[CJSONDeserializer deserializer] deserializeString:value withEncoding:NSUTF8StringEncoding error:&err];
		if (!value) {
			NSLog(@"Error: %@", [err localizedDescription]);
			return nil;
		}
		
		[dictionary setObject:value forKey:key];
	}
	return dictionary;
}

@end
