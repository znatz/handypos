//
//  Syoukei.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/07.
//
//

#import "Syoukei.h"

@implementation Syoukei
-(Syoukei *) initWithID : (NSString *) i
                  title : (NSString *) t
                  price : (int) p
                   kosu : (int) k {
    self = [super init];
    self.ID = i;
    self.title = t;
    self.price = p;
    self.kosu = k;
    return self;
}
@end
