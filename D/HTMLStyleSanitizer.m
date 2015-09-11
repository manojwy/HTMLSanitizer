//
//  HTMLStyleSanitizer.m
//  D
//
//  Created by Suhas D Shetty on 11/09/15.
//  Copyright © 2015 Suhas D Shetty. All rights reserved.
//

#import "HTMLStyleSanitizer.h"

@interface HTMLStyleSanitizer ()

@property (nonatomic, strong) NSArray *allowablecsslist1;
@property (nonatomic, strong) NSArray *allowablecsslist2;

@property (nonatomic, strong) NSRegularExpression *replaceRegex1;
@property (nonatomic, strong) NSRegularExpression *replaceRegex2;

@end

@implementation HTMLStyleSanitizer

- (instancetype)init {
    self = [super init];
    
    self.allowablecsslist1 = [self regexesForPatterns:@[@"(\\w\\/\\/)", @"(\\w\\/\\/*\\*)", @"(\\/\\*\\/)"]];
    self.allowablecsslist2 = [self regexesForPatterns:@[@"(eval|cookie|\bwindow\b|\bparent\b|\bthis\b)", //suspicious javascript-type words
                                                        @"behaviou?r|expression|moz-binding|@import|@charset|(java|vb)?script|[\\<]|\\\\\\w", @"[\\<>]", // back slash, html tags,
                                                        @"[\\x7f-\\xff]", // high bytes -- suspect
                                                        @"[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]", //low bytes -- suspect
                                                        @"&\\#", // bad charset
                                                        ]];
    
    self.replaceRegex1 = [self regexeForPattern:@"(\\/\\*.*?\\*\\/)"];
    self.replaceRegex2 = [self regexeForPattern:@"\\n\\s\\s+"];
    
    return self;
}

#pragma mark - sanitize style

- (NSMutableString *)sanitizeStyle:(NSString *)input {
    if (input.length == 0) {
        return nil;
    }
    input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableString *output = [[NSMutableString alloc] init];
    NSArray *components = [input componentsSeparatedByString:@"}"];
    
    NSInteger textLen = 0;
    for (NSString *component in components) {
        
//        NSLog(@"%@", component);
        textLen += component.length;
        
        NSString *splitter = @"";
        
        if (textLen < input.length) {
            splitter = [input substringWithRange:NSMakeRange(textLen, 1)];
            if (splitter && [splitter isEqualToString:@"}"]) {
                textLen = textLen + 1;
            } else {
                splitter = @"";
            }
        }
        
        NSString *object = [component stringByAppendingString:splitter];
        //        object = stripNULs(object)
        NSString *escapedText = [object stringByRemovingPercentEncoding];
        if (escapedText == nil) {
            escapedText = object;
        }
        
        
        if (escapedText.length > 3) {
            NSMutableString *validStyle = [[NSMutableString alloc] initWithString:escapedText];
            [self validateStyleString:validStyle];
            
            if (validStyle.length > 1) { // verify text contains somethign other than '}'
                [output appendString:validStyle];
            } else {
                [output appendString:splitter];
            }
        } else {
            
            NSString *ttext = [@" " stringByAppendingString:escapedText];
            [output appendString:ttext];
        }
    }

    // remove leading closing brances with out open
    while ([output hasPrefix:@"}"]) {
        [output deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    return output;
}

#pragma mark - validate and reset

- (void)validateStyleString:(NSMutableString *)input {
    if (input.length == 0) {
        return;
    }
    
    for (NSRegularExpression *regex in self.allowablecsslist1) {
        
        NSRange range = [regex rangeOfFirstMatchInString:input options:0 range:NSMakeRange(0, input.length)];
        if (range.location != NSNotFound) {
            //if matched
            [input setString:@""];
            return;
        }
    }
    
    [self.replaceRegex1 replaceMatchesInString:input options:0 range:NSMakeRange(0, input.length) withTemplate:@""];
    [input replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, input.length)];
    
    for (NSRegularExpression *regex in self.allowablecsslist2) {
        
        NSRange range = [regex rangeOfFirstMatchInString:input options:0 range:NSMakeRange(0, input.length)];
        if (range.location != NSNotFound) {
            //if matched
            [input setString:@""];
            return;
        }
    }
    
    // This is done to remove any unnecessary spaces and newlines in the
    // inline CSS styles. Test case: Uber ride receipt
    [self.replaceRegex2 replaceMatchesInString:input options:0 range:NSMakeRange(0, input.length) withTemplate:@" "];
}


#pragma mark - regexesForPatterns

- (NSArray *)regexesForPatterns:(NSArray *)patterns {
    
    NSMutableArray *regexes = [[NSMutableArray alloc] init];
    for (NSString *pattern in patterns) {
        NSRegularExpression *regex = [self regexeForPattern:pattern];
        NSAssert(regex, @"regex is nil for pattern: %@", pattern);
        [regexes addObject:regex];
    }
    return regexes;
}

- (NSRegularExpression *)regexeForPattern:(NSString *)pattern {
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSAssert(!error, @"error creating pattern %@", pattern);
    return regex;
}


@end


