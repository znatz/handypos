//
//  Settings.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/08.
//
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
@property NSString * azmode;
@property NSString * tantou;
@property NSString * bumode;
@property NSString * picmode;
@property NSString * nimode;
-(Settings *) initWithAZmode : (NSString *) a
                      tantou : (NSString *) t
                      bumode : (NSString *) b
                     picmode : (NSString *) p
                      nimode : (NSString *) n;
@end
