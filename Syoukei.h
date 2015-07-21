//
//  Syoukei.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/07.
//
//

#import <Foundation/Foundation.h>

@interface Syoukei : NSObject
@property NSString * ID;
@property NSString * title;
@property int price;
@property int kosu;
-(Syoukei *) initWithID : (NSString *) i
                  title : (NSString *) t
                  price : (int) p
                   kosu : (int) k;
@end
