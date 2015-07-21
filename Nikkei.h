//
//  Nikkei.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/13.
//
//

#import <Foundation/Foundation.h>

@interface Nikkei : NSObject
@property NSString * ID;
@property NSString * title;
@property int price;
@property int kosu;
-(Nikkei *) initWithID : (NSString *) i
                  title : (NSString *) t
                  price : (int) p
                   kosu : (int) k;
@end
