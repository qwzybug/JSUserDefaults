//
//  CJSONDeserializer_StringExtensions.m
//  JSUserDefaults
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CJSONDeserializer_StringExtensions.h"


@implementation CJSONDeserializer (StringExtensions)

- (id)deserializeString:(NSString *)inData withEncoding:(NSStringEncoding)encoding error:(NSError **)outError;
{
	NSData *data = [inData dataUsingEncoding:encoding];
	return [self deserialize:data error:outError];
}

@end
