//
//  Tenpo.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/15.
//
//

#import <Foundation/Foundation.h>

@interface Tenpo : NSObject

@property NSString * ID;
@property NSString * tenpo;
-(Tenpo *) initWithID :(NSString *) ID
                tenpo : (NSString *) tenpo;
@end
