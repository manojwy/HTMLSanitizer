//
//   HTMLPurifier_AttrDef_HTML_MultiLength.h
//   HTMLPurifier
//
//  Created by Lukas Neumann on 12.01.14.


#import "HTMLPurifier_AttrDef_HTML_Length.h"

@interface HTMLPurifier_AttrDef_HTML_MultiLength : HTMLPurifier_AttrDef_HTML_Length

/**
 * @param string $string
 * @param HTMLPurifier_Config $config
 * @param HTMLPurifier_Context $context
 * @return bool|string
 */
-(NSString*) validateWithString:(NSString *)string config:(HTMLPurifier_Config *)config context:(HTMLPurifier_Context *)context;

@end
