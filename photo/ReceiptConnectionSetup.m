//
//  ReceiptConnectionSetup.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/21.
//
//

#import "ReceiptConnectionSetup.h"
#import "Printer.h"

@interface ReceiptConnectionSetup () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *url;
@end


@implementation ReceiptConnectionSetup
@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.url.delegate = self;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget : self
                                                                                  action : @selector(tapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSUserDefaults * defaultSettings = [NSUserDefaults standardUserDefaults];
    if ([defaultSettings valueForKey:@"PrinterURL"]) {
        self.url.text = [defaultSettings valueForKey:@"PrinterURL"];
    }
    
    //背景用の設定
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
}

-(IBAction)tapped:(id)sender
{
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)submit:(id)sender {
    if(![[Printer alloc] initWithURL:self.url.text]){
        UIAlertView * failedOnConnection = [[UIAlertView alloc] initWithTitle : @"レジ接続"
                                                                      message : @"失敗しました。"
                                                                     delegate : self
                                                            cancelButtonTitle : nil
                                                            otherButtonTitles : @"編集", nil];
        [failedOnConnection show];
        
    } else {
        UIAlertView * successOnConnection = [[UIAlertView alloc] initWithTitle : @"レジ接続"
                                                                       message : @"成功しました。"
                                                                      delegate : self
                                                             cancelButtonTitle : nil
                                                             otherButtonTitles : @"保存", nil];
        [successOnConnection show];
        NSUserDefaults * defaulSettings = [NSUserDefaults standardUserDefaults];
        [defaulSettings setValue:self.url.text forKey:@"PrinterURL"];
        [defaulSettings synchronize];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Dismiss Keyboard After Editing
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)dismissKeyboard {
    [self.url resignFirstResponder];
}
@end
