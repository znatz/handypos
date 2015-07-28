//
//  Bumon.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import <Foundation/Foundation.h>

@interface Bumon : NSObject
@property NSString * ID;
@property NSString * bumon;
-(Bumon *) initWithID :(NSString *) ID
                bumon : (NSString *) bumon;
@end
