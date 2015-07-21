//
//  Goods.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/07.
//
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject
@property NSString * ID;
@property int price;
@property int genka;
@property NSString * title;
@property NSString * bumon;
@property NSData * contents;
@property int kosu;
-(Goods *) initWithID : (NSString *) ID
                price : (int) p
                genka : (int) g
                title :(NSString *) t
                bumon :(NSString *) b
             contents : (NSData *) c
                 kosu : (int) k;
@end
