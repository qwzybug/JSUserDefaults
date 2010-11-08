//
//  CJSONDeserializer_StringExtensions.h
//  JSUserDefaults
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CJSONDeserializer.h"

@interface CJSONDeserializer (StringExtensions)

- (id)deserializeString:(NSString *)inData withEncoding:(NSStringEncoding)encoding error:(NSError **)outError;

@end
