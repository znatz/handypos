//
//  Printer.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/20.
//
//

#import <Foundation/Foundation.h>
#import "ESCPOSPrinter.h"

@interface Printer : NSObject
@property NSString * url;
@property ESCPOSPrinter * printer;
- (Printer *) initWithURL : (NSString *) url;
- (void) printHeader ;
-(void) printContentsWith: (NSMutableArray *) ts syoukei : (NSMutableArray *) ss ;
-(void) printToKichenWith: (NSMutableArray *) ts syoukei : (NSMutableArray *) ss ;
-(void) printFooter ;
-(void) close ;
@end
