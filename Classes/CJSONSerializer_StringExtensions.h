//
//  CJSONSerializer_StringExtensions.h
//  JSUserDefaults
//
//  Created by Devin Chalmers on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CJSONSerializer.h"

@interface CJSONSerializer (StringExtensions) 

- (NSString *)serializeObject:(id)object asStringWithEncoding:(NSStringEncoding)encoding error:(NSError **)err;

@end
