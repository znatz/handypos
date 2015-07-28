//
//  FTPController.m
//  HandyPOS
//
//  Created by POSCO on 12/12/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FTPController.h"
#import "DataUpdate.h"
#import "NetworkManager.h"

@interface FTPController()<NSStreamDelegate>
//@property (nonatomic, strong, readwrite) NSInputStream *readStream;
//@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong, readwrite) NSInputStream  *networkStream;
@property (nonatomic, strong, readwrite) NSOutputStream *  fileStream;
@property (nonatomic, copy,   readwrite) NSString       *filePath;

@end

@implementation FTPController

NSString *UserName;
NSString *DLFlag;
NSString *strURL;
NSString *strName;
NSString *strPass;
bool Connection;
bool blnMode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"データ通信";
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    strURL=@"ftp://posco-web.com/httpdocs/posco/Master.sqlite";
    strName=@"a10254787";
    strPass=@"sB9pwjW4";
    blnMode=true;
    
}
////////DL・UL処理///////////

-(IBAction)DownLoad:(id)sender{//DLボタン
    DLFlag=@"0";
    UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"マスタ更新" message:@"マスタが上書きされてしまいますがよろしいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    [av show];
}

-(IBAction)UpLoad:(id)sender{//ULボタン
    DLFlag=@"1";
    UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"売上送信" message:@"売上データを送信してよろしいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    [av show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self startReceive];
        break;
    }
}

- (void)receiveDidStart
{
    // Clear the current image so that we get a nice visual cue if the receive fails.
    //[self.activityIndicator startAnimating];
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void)updateStatus:(NSString *)statusString
{
    assert(statusString != nil);
}

- (void)receiveDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"確認" message:@"受信に成功しました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [av show];
    }
    //[self.activityIndicator stopAnimating];
    [[NetworkManager sharedInstance] didStopNetworkOperation];
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

- (BOOL)isReceiving
{
    return (self.networkStream != nil);
}

- (void)startReceive
// Starts a connection to download the current URL.
{
    BOOL                success;
    NSURL *             url;
    
    assert(self.networkStream == nil);      // don't tap receive twice in a row!
    assert(self.fileStream == nil);         // ditto
    assert(self.filePath == nil);           // ditto
    
    // First get and check the URL.
    ////url = [[NetworkManager sharedInstance] smartURLForString:self.urlText.text];
    url = [[NetworkManager sharedInstance] smartURLForString:strURL];
    success = (url != nil);
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        //self.statusLabel.text = @"Invalid URL";
    } else {
        
        // Open a stream for the file we're going to receive into.
        
        //self.filePath = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* str = [paths objectAtIndex:0];
        self.filePath = [str stringByAppendingPathComponent:@"Master.sqlite"];
        NSLog(@"%@",self.filePath);
        assert(self.filePath != nil);
        
        self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:NO];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a CFFTPStream for the URL.
        
        self.networkStream = CFBridgingRelease(CFReadStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url));
        assert(self.networkStream != nil);
        
        ////if ([self.usernameText.text length] != 0) {
        if ([strName length] != 0) {
            ////success = [self.networkStream setProperty:self.usernameText.text forKey:(id)kCFStreamPropertyFTPUserName];
            success = [self.networkStream setProperty:strName forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            ////success = [self.networkStream setProperty:self.passwordText.text forKey:(id)kCFStreamPropertyFTPPassword];
            success = [self.networkStream setProperty:strPass forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
        }
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Tell the UI we're receiving.
        [self receiveDidStart];
        
    }
}

- (void)stopReceiveWithStatus:(NSString *)statusString
// Shuts down the connection and displays the result (statusString == nil)
// or the error status (otherwise).
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self receiveDidStopWithStatus:statusString];
    self.filePath = nil;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSInteger       bytesRead;
            uint8_t         buffer[32768];
            
            [self updateStatus:@"Receiving"];
            
            // Pull some data off the network.
            
            bytesRead = [self.networkStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead == -1) {
                [self stopReceiveWithStatus:@"Network read error"];
            } else if (bytesRead == 0) {
                [self stopReceiveWithStatus:nil];
            } else {
                NSInteger   bytesWritten;
                NSInteger   bytesWrittenSoFar;
                
                // Write to the file.
                
                bytesWrittenSoFar = 0;
                do {
                    bytesWritten = [self.fileStream write:&buffer[bytesWrittenSoFar] maxLength:(NSUInteger) (bytesRead - bytesWrittenSoFar)];
                    assert(bytesWritten != 0);
                    if (bytesWritten == -1) {
                        [self stopReceiveWithStatus:@"File write error"];
                        break;
                    } else {
                        bytesWrittenSoFar += bytesWritten;
                    }
                } while (bytesWrittenSoFar != bytesRead);
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopReceiveWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

#pragma mark * UI Actions

- (IBAction)getOrCancelAction:(id)sender
{
#pragma unused(sender)
    if (self.isReceiving) {
        [self stopReceiveWithStatus:@"Cancelled"];
    } else {
        [self startReceive];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
// A delegate method called by the URL text field when the editing is complete.
// We save the current value of the field in our settings.
{
#pragma unused(textField)
    NSString *  newValue;
    NSString *  oldValue;
    
    //assert(textField == self.urlText);
    
    ////newValue = self.urlText.text;
    newValue = strURL;
    oldValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"GetURLText"];
    
    // Save the URL text if it's changed.
    
    assert(newValue != nil);        // what is UITextField thinking!?!
    assert(oldValue != nil);        // because we registered a default
    
    if ( ! [newValue isEqual:oldValue] ) {
        [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:@"GetURLText"];
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
// A delegate method called by the URL text field when the user taps the Return
// key.  We just dismiss the keyboard.
//{
//#pragma unused(textField)
    //assert(textField == self.urlText || (textField == self.usernameText) || (textField == self.passwordText));
    ////[self.urlText resignFirstResponder];
    //[strURL resignFirstResponder];
    //return NO;
//}

#pragma mark * View controller boilerplate

///////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}    


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

