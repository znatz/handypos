//
//  Settings.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/08.
//
//

#import "Settings.h"

@implementation Settings
-(Settings *) initWithAZmode : (NSString *) a
                      tantou : (NSString *) t
                      bumode : (NSString *) b
                     picmode : (NSString *) p
                      nimode : (NSString *) n
{
    self = [super init];
    self.azmode = a;
    self.tantou = t;
    self.bumode = b;
    self.picmode  = p;
    self.nimode = n;
    
    return self;
}
@end
