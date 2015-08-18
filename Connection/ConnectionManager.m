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

+ (void) fetchDBFile : (NSString *)dbfileName fromViewController : (UIViewController*) parentView
{
    UIView * dimview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, parentView.view.frame.size.width, parentView.view.frame.size.height)];
    [dimview setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5f]];
    dimview.tag = 10;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[parentView view] addSubview:dimview];
    });
    
    
    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/app/database";

    NSString *url    = [NSString stringWithFormat:@"%@/%@", dbURI, dbfileName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    // ダウンロード先のURLを設定したNSURLRequestインスタンスを生成する
    NSError * error;
    NSMutableURLRequest *request = [[manager requestSerializer] requestWithMethod:@"GET" URLString:url parameters:nil error:&error];
    
    // ダウンロード処理を実行するためのAFHTTPRequestOperationインスタンスを生成する
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 for (UIView * v in parentView.view.subviews) {
                                                                                     if (v.tag == 10) {
                                                                                         [v removeFromSuperview];
                                                                                     }
                                                                                 }
                                                                             });
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 for (UIView * v in parentView.view.subviews) {
                                                                                     if (v.tag == 10) {
                                                                                         [v removeFromSuperview];
                                                                                     }
                                                                                 }
                                                                             });
                                                                         }];
    
    
    
    // データを受信する度に実行される処理を設定する
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // ダウンロード中の進捗状況をコンソールに表示する
            for (UIView * v in [parentView view].subviews) {
                if ([v isKindOfClass:[DALabeledCircularProgressView class]]) {
                    [v removeFromSuperview];
                }
            }
            
            double percentDone = (double)totalBytesRead / (double)totalBytesExpectedToRead ;
            DALabeledCircularProgressView * progressbar = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake([parentView view].frame.size.width/5, [parentView view].frame.size.height/5, [parentView view].frame.size.width*3/5, [parentView view].frame.size.width*3/5)];
            
            progressbar.roundedCorners = YES;
            progressbar.trackTintColor = [UIColor brownColor];
            progressbar.progressTintColor = [UIColor whiteColor];
            progressbar.progress = percentDone;
            progressbar.thicknessRatio = 0.1f;
            progressbar.progressLabel.text = [NSString stringWithFormat:@"%d％", (int)round(percentDone * 100) ];

            if (percentDone < 1) [[parentView view] addSubview:progressbar];
        });
    }];
    
    
    
    
    // <Application_Home>/Documentsディレクトリのパスを取得する
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    // <Application_Home>/Documents/test.zip
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:dbfileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    // ファイルの保存先を「<Application_Home>/Documents/test.zip」に指定する
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    // ダウンロードを開始する
    [manager.operationQueue addOperation:operation];
    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [operation waitUntilFinished];

}

+ (void) fetchAllDB : (UIViewController *) parentView {
    [self fetchDBFile:@"Master.sqlite" fromViewController : parentView];
    [self fetchDBFile:@"Azukari.sqlite" fromViewController : parentView];
}


+ (void)uploadFile : (NSString *) dbfileName;
{
//    NSString * dbURI = @"http://127.0.0.1:3000/fromIOS";
//    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/iosReceiver.php";
    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/public/iosReceiver";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * tanto = [[NSUserDefaults standardUserDefaults] objectForKey:@"tantoID"];
    NSDictionary *params = @{ @"tanto": tanto};
    
    NSString *documentDir;
    documentDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *uploadLocationPath = [documentDir stringByAppendingPathComponent:dbfileName];
    
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:uploadLocationPath];

    [manager POST : dbURI
       parameters : params
constructingBodyWithBlock : ^( id <AFMultipartFormData> formData )
     {
        [formData appendPartWithFileData:data name:@"file" fileName:dbfileName mimeType:@"application/x-sqlite3"];
         
     }
          success : ^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         NSLog(@"response is :  %@",responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ *****", [error description]);
     }];
    

}


+ (void)uploadKey : (NSString *) key value : (NSString *) value
{
    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/iosReceiver.php";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ key : value};
    
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
