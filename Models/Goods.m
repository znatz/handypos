//
//  Goods.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/07.
//
//

#import "Goods.h"

@implementation Goods
-(Goods *) initWithID : (NSString *) ID
                price : (int) p
                genka : (int) g
                title :(NSString *) t
                bumon :(NSString *) b
             contents : (NSData *) c
                 kosu : (int) k {
    self = [super init];
    self.ID = ID;
    self.price = p;
    self.genka = g;
    self.title = t;
    self.bumon = b;
    self.contents = c;
    self.kosu = k;
    return self;
}
@end
