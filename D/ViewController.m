//
//  ViewController.m
//  D
//
//  Created by Suhas D Shetty on 10/09/15.
//  Copyright © 2015 Suhas D Shetty. All rights reserved.
//

#import "ViewController.h"
#import "HTMLPurifier.h"
#import "HTMLPurifier_Config.h"
#import "HTMLPurifier_Context.h"
#import "HTMLStyleSanitizer.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)testHTMLString {
    NSString* testHTML = @"<!DOCTYPE html><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta name=\"generator\" content=\"HTML Tidy for HTML5 (experimental) for Mac OS X https://github.com/w3c/tidy-html5/tree/c63cc39\" /><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><title>Magazin-kw2114-DE_FM</title></head><body bgcolor=\"#C7D5E7\" link=\"#2269C3\" vlink=\"#2269C3\" alink=\"#2269C3\" text=\"#000000\" topmargin=\"0\" leftmargin=\"20\" marginheight=\"0\" marginwidth=\"0\"><img src=\"https://mailings.gmx.net/action/view/11231/2o2gy1vt\" border=\"0\" width=\"1\" height=\"1\" alt=\"\" /><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"620\"><!-- Header --><table width=\"620\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td width=\"1\" bgcolor=\"#C4D3E6\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td><td width=\"1\" bgcolor=\"#BFCEE1\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td><td width=\"1\" bgcolor=\"#B9C8DB\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td><td width=\"1\" bgcolor=\"#B2BFCF\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td></tr></table></body></html>";
    
    
    testHTML = @"<a href='javscript:alert(\'test\');'> Manoj</a>";
    
    testHTML = @"<a href=\"javascript:;\" onclick=\"alert('Gotcha');\">Link</a>";
    
    testHTML = @"<a href='http://cloudmagic.com' >Link</a>";
    
    testHTML = @"<img src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA AAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO 9TXL0Y4OHwAAAABJRU5ErkJggg==\" alt=\"Red dot\" />";
    
    testHTML = @"<div style='color:#ff00ff;' yahoo>Suhas</div>";
    
    
    testHTML = @"<style>.mycss{color:red;}</style><div class='mycss' style='color:#ff00ff;' yahoo>Suhas</div>";
    
    testHTML = @"<style>body {color:#F00;}</style> Some text";
    
    testHTML = @"<img src=\"cid:9TXL0Y4OHwAAAABJRU5ErkJggg==\" alt=\"Red dot\" />";
    
    testHTML = @"<div><head><style>.mycss{color:red;}</style></head><div><div class='mycss' style='color:#ff00ff;' yahoo>Suhas</div></div></div>";
    
    
    
    testHTML = @"<style>p[foo=bar{}*{-o-link:'javascript:alert(1)'}{}*{-o-link-source:current}*{background:red}]{background:green};</style><style>body {color:#F00;}</style>";
    
    
    testHTML = @"<link rel=stylesheet href=data:,*%7bx:expression(write(1))%7d";
    
    
    testHTML = @"<html><head><style type=\"text/css\">.ss{test:rrr;}</style></head>";

    
    
    NSString* cleanedHTML = [HTMLPurifier cleanHTML:testHTML];
    NSLog(@"Output: %@", cleanedHTML);
}


-(void) testStyleString {
    
    NSString * testStyle = @"<style>.mm{test:abc;manoj:javascript;}.test{color:red;}\n//--test</style>";
    
    
    NSLog(@"Input: %@", testStyle);
    
    HTMLStyleSanitizer *styleSanitizer = [[HTMLStyleSanitizer alloc] init];
    
    NSMutableString * cleanStyle = [styleSanitizer sanitizeStyle:testStyle];
    
    NSLog(@"Output: %@", cleanStyle);
}



- (void) testCompleteHTMLWithStyle {
    
    NSString * html = @"<html><head><style type=\"text/css\">.div{color:blue;}</style></head><body><div>Test</div><style type=\"text/css\">.div{color:blue;}</style></body></html>";
    
    NSMutableString * body;
    NSString * style;
    NSMutableString * result = [[NSMutableString alloc] init];
    
    NSRange range = [html rangeOfString:@"<body" options:NSCaseInsensitiveSearch];
    
    if (range.location == NSNotFound) {
        body = html.mutableCopy;
        style = @"";
    } else {
        body = [html substringFromIndex:range.location].mutableCopy;
        style = [html substringToIndex:range.location];
    }
    
    if (style.length > 0) {
        // clean the style to remove the head and other tags
        HTMLStyleSanitizer *styleSanitizer = [[HTMLStyleSanitizer alloc] init];
        NSString* cleanedStyle = [HTMLPurifier cleanHTML:style];
        
        NSUInteger startIndex = 0;
        
        while (startIndex < cleanedStyle.length) {
            // find the content of style tag
            NSRange styleStart = [cleanedStyle rangeOfString:@"<style>" options:NSCaseInsensitiveSearch range:NSMakeRange(startIndex, cleanedStyle.length - startIndex)];
            if (styleStart.location == NSNotFound) {
                break;
            }
            
            NSRange styleEnd = [cleanedStyle rangeOfString:@"</style>" options:NSCaseInsensitiveSearch];
            if (styleEnd.location == NSNotFound) {
                break;
            }
            
            
            NSString * styleContent = [cleanedStyle substringWithRange:NSMakeRange(styleStart.location + 7, styleEnd.location - (styleStart.location + 7))];
            
            if (styleContent.length > 0) {
                // sanitize this and add to the buffer;
                    NSMutableString * style = [styleSanitizer sanitizeStyle:styleContent];
                
                if (style.length > 0) {
                    [result appendFormat:@"<style>%@</style>", style];
                }
            }
            startIndex = styleEnd.location + 8;
        }
    }
    
    if (body.length > 0) {
        NSError * error;
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"<style.*?<\\/style>" options:NSRegularExpressionCaseInsensitive error:&error];
        [regex replaceMatchesInString:body options:0 range:NSMakeRange(0, body.length) withTemplate:@""];
        NSString* html = [HTMLPurifier cleanHTML:body];
        [result appendString:html];
    }
    
    NSLog(@"Complete HTML: %@", result);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testHTMLString];
//    [self testStyleString];
    
    [self testCompleteHTMLWithStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
