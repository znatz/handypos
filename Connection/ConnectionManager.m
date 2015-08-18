//
//  NetworkManager.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/09.
//
//

#import "ConnectionManager.h"
#import "MainViewController.h"
#import "UIViewController+Utils.h"
#import "AFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/UIActivityIndicatorView+AFNetworking.h>
#import <DACircularProgress/DACircularProgressView.h>
#import <DACircularProgress/DALabeledCircularProgressView.h>

@implementation ConnectionManager

#pragma mark - Get All Database files

+ (void) fetchDBFile : (NSString *)dbfileName fromViewController : (UIViewController*) parentView
{
#pragma mark -Local Variables
    UIView          * dimview;
    NSString        * dbURI, * url, * documentDirectory, * filePath;
    NSError         * error;
    NSArray         * paths;
    NSFileManager   * fileManager;
    NSMutableURLRequest           * request;
    
    AFHTTPRequestOperationManager * manager;
    AFHTTPRequestOperation        * operation;
    
#pragma mark -Dim Background
    dimview                 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, parentView.view.frame.size.width, parentView.view.frame.size.height)];
    dimview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    dimview.tag             = 10;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[parentView view] addSubview:dimview];
    });
    
    
#pragma mark -Prepare Download Operation
    dbURI        = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/app/database";
    url          = [NSString stringWithFormat:@"%@/%@", dbURI, dbfileName];
    
    manager      = [AFHTTPRequestOperationManager manager];
    request      = [[manager requestSerializer] requestWithMethod:@"GET" URLString:url parameters:nil error:&error];
    
    
    operation    = [manager HTTPRequestOperationWithRequest : request
                                                    success : ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            for (UIView * v in parentView.view.subviews)
                                                            {
                                                                if (v.tag == 10) [v removeFromSuperview];
                                                            }
                                                        });
                                                    }
                                                    failure : ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            for (UIView * v in parentView.view.subviews)
                                                            {
                                                                if (v.tag == 10) [v removeFromSuperview];
                                                            }
                                                        });
                                                    }];
    
    
#pragma mark -Show Progress
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // ダウンロード中の進捗状況をコンソールに表示する
            for (UIView * v in [parentView view].subviews) {
                if ([v isKindOfClass:[DALabeledCircularProgressView class]]) {
                    [v removeFromSuperview];
                }
            }
            
            double percentDone = (double)totalBytesRead / (double)totalBytesExpectedToRead ;
            DALabeledCircularProgressView * progressbar = [[DALabeledCircularProgressView alloc]
                                                           initWithFrame : CGRectMake([parentView view].frame.size.width/5,
                                                                                      [parentView view].frame.size.height/5,
                                                                                      [parentView view].frame.size.width*3/5,
                                                                                      [parentView view].frame.size.width*3/5)];
            
            progressbar.progressTintColor               = [UIColor whiteColor];
            progressbar.trackTintColor                  = [UIColor brownColor];
            progressbar.roundedCorners                  = YES;
            progressbar.thicknessRatio                  = 0.1f;
            progressbar.progress                        = percentDone;
            progressbar.progressLabel.text              = [NSString stringWithFormat:@"%d％", (int)round(percentDone * 100) ];

            if (percentDone < 1) [[parentView view] addSubview:progressbar];
        });
    }];
    
    
    
    paths                   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectory       = paths[0];
    filePath                = [documentDirectory stringByAppendingPathComponent:dbfileName];
    fileManager             = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    [manager.operationQueue addOperation:operation];
    [operation waitUntilFinished];
    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

+ (void) fetchAllDB : (UIViewController *) parentView {
    [self fetchDBFile:@"Master.sqlite" fromViewController : parentView];
    [self fetchDBFile:@"Azukari.sqlite" fromViewController : parentView];
}


+ (void)uploadFile : (NSString *) dbfileName;
{
    NSString * dbURI, * tanto, * documentDir, * uploadLocationPath;
    NSDictionary * params;
    NSData * data;
    AFHTTPRequestOperationManager * manager;
    
    tanto               = [[NSUserDefaults standardUserDefaults] objectForKey:@"tantoID"];
    params              = @{ @"tanto": tanto};
    
    dbURI               = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/public/iosReceiver";

    manager             = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    documentDir         = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    uploadLocationPath  = [documentDir stringByAppendingPathComponent:dbfileName];
    data                = [[NSFileManager defaultManager] contentsAtPath:uploadLocationPath];

    [manager POST : dbURI
       parameters : params
constructingBodyWithBlock : ^( id <AFMultipartFormData> formData )
     {
        [formData appendPartWithFileData:data name:@"file" fileName:dbfileName mimeType:@"application/x-sqlite3"];
         
     }
          success : ^(AFHTTPRequestOperation *operation, id responseObject)
     {
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ *****", [error description]);
     }];
    

}


+ (void)uploadKey : (NSString *) key value : (NSString *) value
{
    NSString * dbURI;
    NSDictionary * params;
    AFHTTPRequestOperationManager * manager;
    
    dbURI   = @"http://posco-cloud.sakura.ne.jp/TEST/iosReceiver.php";

    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    params  = @{ key : value};
    
    [manager POST : dbURI
       parameters : params
constructingBodyWithBlock : ^( id <AFMultipartFormData> formData )
    {
     }
          success : ^(AFHTTPRequestOperation *operation, id responseObject)
     {
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ *****", [error description]);
     }];

}



@end
