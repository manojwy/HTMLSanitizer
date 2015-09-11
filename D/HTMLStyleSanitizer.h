//
//  HTMLStyleSanitizer.h
//  D
//
//  Created by Suhas D Shetty on 11/09/15.
//  Copyright © 2015 Suhas D Shetty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLStyleSanitizer : NSObject

- (NSMutableString *)sanitizeStyle:(NSString *)input;

@end
