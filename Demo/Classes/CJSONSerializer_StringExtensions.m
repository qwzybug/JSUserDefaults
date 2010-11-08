//
//  CJSONSerializer_StringExtensions.m
//  JSUserDefaults
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CJSONSerializer_StringExtensions.h"


@implementation CJSONSerializer (StringExtensions)

- (NSString *)serializeObject:(id)object asStringWithEncoding:(NSStringEncoding)encoding error:(NSError **)err;
{
	NSString *result = nil;
	NSData *data = [self serializeObject:object error:err];
	if (data) {
		result = [[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:encoding] autorelease];
	}
	return result;
}

@end
