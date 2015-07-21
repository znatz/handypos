//
//  Tenpo.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/15.
//
//

#import "Tenpo.h"

@implementation Tenpo
-(Tenpo *) initWithID :(NSString *) ID
                tenpo : (NSString *) tenpo {
    Tenpo * t = [Tenpo alloc];
    t.ID = ID;
    t.tenpo = tenpo;
    return t;
}
@end
