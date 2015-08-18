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

@implementation ConnectionManager

+ (void) fetchDBFile1 : (NSString *)dbfileName fromViewController : (UIViewController*) parentView
{
    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/app/database";

    NSString *url    = [NSString stringWithFormat:@"%@/%@", dbURI, dbfileName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // ダウンロード先のURLを設定したNSURLRequestインスタンスを生成する
//    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil];
    NSError * error;
    NSMutableURLRequest *request = [[manager requestSerializer] requestWithMethod:@"GET" URLString:url parameters:nil error:&error];
    
    // ダウンロード処理を実行するためのAFHTTPRequestOperationインスタンスを生成する
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             // ダウンロードに成功したらコンソールに成功した旨を表示する
                                                                             NSLog(@"ダウンロード完了！");
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             // エラーの場合はエラーの内容をコンソールに出力する
                                                                             NSLog(@"Error: %@", error);
                                                                         }];
    
    
    // データを受信する度に実行される処理を設定する
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        // ダウンロード中の進捗状況をコンソールに表示する
        NSLog(@"bytesRead: %@, totalBytesRead: %@, totalBytesExpectedToRead: %@, progress: %@",
              @(bytesRead),
              @(totalBytesRead),
              @(totalBytesRead),
              @((float)totalBytesRead / totalBytesExpectedToRead));
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
}


+ (void) fetchDBFile : (NSString *)dbfileName fromViewController : (UIViewController*) parentView
{
    NSString * dbURI = @"http://posco-cloud.sakura.ne.jp/TEST/IOS/OrderSystem/app/database";

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", dbURI, dbfileName]];
    NSLog(@"%@", url);
    NSURLRequest *myRequest;
    
    myRequest = [NSURLRequest requestWithURL:url
                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                             timeoutInterval:30.0];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    
    
    // sqliteの保存場所を指定
    NSString *documentDir;
    documentDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    dbfileName = [NSString stringWithFormat:@"%@", dbfileName];
    NSString *downloadDestinationPath = [documentDir stringByAppendingPathComponent:dbfileName];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadDestinationPath append:NO];
    
    
    [operation
     setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                     id responseObject)
    {
        NSLog(@"ダウンロード成功！ dbの保存先:%@", downloadDestinationPath);
    }
     failure:^(AFHTTPRequestOperation *operation,
               NSError *error)
    {
        NSLog(@"Error ->: %@", [error localizedDescription]);
    }];
    
//    UIProgressView * progressbar  = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    UIProgressView * progressbar  = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressbar.frame = CGRectMake(10, 100, 200, 10);
    [[parentView view] addSubview:progressbar];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        double percentDone = (double)totalBytesRead / (double)totalBytesExpectedToRead;
//        NSLog(@"progress updated(percentDone) : %f", percentDone);
        progressbar.progress = percentDone;
    }];
    [operation start];
    [operation waitUntilFinished];
    progressbar.hidden = YES;
}

+ (void) fetchAllDB : (UIViewController *) parentView {
//    [self fetchDBFile:@"Master.sqlite" fromViewController : parentView];
//    [self fetchDBFile:@"Azukari.sqlite" fromViewController : parentView];
    [self fetchDBFile1:@"Master.sqlite" fromViewController : parentView];
    [self fetchDBFile1:@"Azukari.sqlite" fromViewController : parentView];
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
