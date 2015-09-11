//
//  ViewController.m
//  D
//
//  Created by Suhas D Shetty on 10/09/15.
//  Copyright © 2015 Suhas D Shetty. All rights reserved.
//

#import "ViewController.h"
#import "HTMLPurifier.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* testHTML = @"<!DOCTYPE html><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta name=\"generator\" content=\"HTML Tidy for HTML5 (experimental) for Mac OS X https://github.com/w3c/tidy-html5/tree/c63cc39\" /><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><title>Magazin-kw2114-DE_FM</title></head><body bgcolor=\"#C7D5E7\" link=\"#2269C3\" vlink=\"#2269C3\" alink=\"#2269C3\" text=\"#000000\" topmargin=\"0\" leftmargin=\"20\" marginheight=\"0\" marginwidth=\"0\"><img src=\"https://mailings.gmx.net/action/view/11231/2o2gy1vt\" border=\"0\" width=\"1\" height=\"1\" alt=\"\" /><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"620\"><!-- Header --><table width=\"620\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td width=\"1\" bgcolor=\"#C4D3E6\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td><td width=\"1\" bgcolor=\"#BFCEE1\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td><td width=\"1\" bgcolor=\"#B9C8DB\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td><td width=\"1\" bgcolor=\"#B2BFCF\"><img src=\"https://img.ui-portal.de/p.gif\" alt=\"\" width=\"1\" height=\"1\" border=\"0\" /></td></tr></table></body></html>";
    
    
        testHTML = @"<a href='javscript:alert(\'test\');'> Manoj</a>";
    
        testHTML = @"<a href=\"javascript:;\" onclick=\"alert('Gotcha');\">Link</a>";
    
        testHTML = @"<a href='http://cloudmagic.com' >Link</a>";
    
        testHTML = @"<img src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA AAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO 9TXL0Y4OHwAAAABJRU5ErkJggg==\" alt=\"Red dot\" />";
    
        testHTML = @"<div style='color:#ff00ff;' yahoo>Suhas</div>";
    
    
//            testHTML = @"<html><head><style>.mycss{color:red;}</style></head><body><div class='mycss' style='color:#ff00ff;' yahoo>Suhas</div></body></html>";
           testHTML = @"<style>.mycss{color:red;}</style><div class='mycss' style='color:#ff00ff;' yahoo>Suhas</div>";
    
    
    
    NSString* cleanedHTML = [HTMLPurifier cleanHTML:testHTML];
    
    NSLog(@"Output: %@", cleanedHTML);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
