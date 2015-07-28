//
//  NetworkManager.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/09.
//
//

#import <UIKit/UIKit.h>

@interface ConnectionManager : NSObject
+ (void) fetchDBFile:(NSString *) dbfileName ;
+ (void) fetchAllDB ;
+ (void) uploadFile : (NSString *) dbfileName;
+ (void)uploadKey : (NSString *) key value : (NSString *) value;
@end
