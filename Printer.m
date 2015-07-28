//
//  Printer.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/20.
//
//
/*
 
 */

#import "Printer.h"
#import "ESCPOSPrinter.h"
#import "Syoukei.h"
#import "TransferData.h"
#import "DataModels.h"
#import "ReceiptSettings.h"
#import "DataAzukari.h"
#import "NSString+Ruby.h"

@implementation Printer
-(Printer *) initWithURL : (NSString *) url{
    self = [super init];
    self.printer = [[ESCPOSPrinter alloc] init];
    if ([self.printer openPort:url withPortParam:9100] <0 ) { return nil; }
    [self.printer setEncoding:NSShiftJISStringEncoding];
    return self;
}

-(void) close {
	[self.printer lineFeed:4];
    [self.printer closePort];
}


- (void) printHeader {
	// Command -- Font Size, Alignment
	unsigned char tWidthHeightSize[3] = {0x1D,0x21,0x22};
    
	unsigned char centerAlign[3] = {0x1B,0x61,0x01};
    
	[self.printer printData:centerAlign withLength:sizeof(centerAlign)];
    [self.printer printData:tWidthHeightSize withLength:sizeof(tWidthHeightSize)];
    [self.printer printString:@"領 収 証\r\n\r\n"];
    
}

-(void) printContentsWith: (NSMutableArray *) ts syoukei : (NSMutableArray *) ss {
    
    TransferData * t = ts[0];
    Nebiki * n = [DataModels getNebikkiByReceiptNo:t.receiptNo];
    ReceiptSettings * r = [DataAzukari getReceiptSettings];
    
    
    NSString * date_receipt = [NSString stringWithFormat:@"%@     No.%@\r\n", [t.time substringToIndex:14], t.receiptNo];
    NSString * tantou       = [NSString stringWithFormat:@"No%@%@\r\n\r\n", t.tantoID, [DataModels getTantoNameByID:t.tantoID]];
    [self normal_left:date_receipt];
    [self normal_left:tantou];
    
    NSString * list_header  = @"品 名　     数 量 　    金 額\r\n";
    [self normal_center:list_header];
     
    int i;
    NSString * line = [[NSString alloc] init];

    for (i = 0; i<ss.count; i++ ) {
        Syoukei * s = ss[i];
        
        line     = [NSString stringWithFormat:@"%@\r\n", s.title];
        [self normal_left:line];
        
        NSString * price_count = [NSString stringWithFormat:@"%d X %d", s.price, s.kosu];
        price_count = [price_count rightJustify:20 with:@" "];
        NSString * priceXcount = [self setStringAsCurrency: [NSString stringWithFormat:@"%d",s.price*s.kosu]];
        priceXcount = [priceXcount rightJustify:11 with:@" "];

        line     = [NSString stringWithFormat:@"%@%@\r\n", price_count,priceXcount];
        
        [self normal_left:line];
        
        
//        [self normal_left:line];
    }
    
    [self double_width_left:@"\r\n"];
    
    NSString * total_price_line = [[self setStringAsCurrency:n._goukei] rightJustify:11 with:@" "];
    total_price_line = [NSString stringWithFormat:@"%@%@\r\n", @"合計",total_price_line];

    [self double_width_left:total_price_line];
    
    NSString * tax_amount = [NSString stringWithFormat:@"%d",r.tax * [n._goukei intValue]/100];
    tax_amount = [self setStringAsCurrency:tax_amount];
    tax_amount = [tax_amount rightJustify:25 with:@" "];
    tax_amount = [NSString stringWithFormat:@"%@%@)\r\n", @"(内税", tax_amount];
    [self normal_left:tax_amount];
    
    NSString * azukari = [self setStringAsCurrency:n._azukari];
    azukari = [azukari rightJustify:23 with:@" "];
    azukari = [NSString stringWithFormat:@"%@%@\r\n", @"お預かり", azukari];
    [self normal_left:azukari];
    
    NSString * oturi = [self setStringAsCurrency:n._oturi];
    oturi = [oturi rightJustify:25 with:@" "];
    oturi = [NSString stringWithFormat:@"%@%@\r\n\r\n", @"お釣り", oturi];
    [self normal_right:oturi];
    
}

-(void) printFooter {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"ReceiptComment" ofType:@"txt"];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self normal_left:[NSString stringWithFormat:@"%@", content]];
}

/* Helper Functions ------------------------------------- */
-(NSString *) setStringAsCurrency : (NSString *) input {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];
    [f setCurrencySymbol:@"￥"];
    NSString * formatted = [f stringFromNumber:[[NSNumber alloc] initWithInt:[input intValue]]];
    return formatted;
}

-(void) normal_left : (NSString *) line {
	unsigned char leftAlign[3] = {0x1B,0x61,0x00};
	unsigned char normalSize[3] = {0x1D,0x21,0x00};
    [self.printer printData:leftAlign withLength:3];
	[self.printer printData:normalSize withLength:3];
    [self.printer printString:line];
}

-(void) normal_right : (NSString *) line {
	unsigned char rightAlign[3] = {0x1B,0x61,0x02};
	unsigned char normalSize[3] = {0x1D,0x21,0x00};
    [self.printer printData:rightAlign withLength:sizeof(rightAlign)];
	[self.printer printData:normalSize withLength:sizeof(normalSize)];
    [self.printer printString:line];
}

-(void) normal_center : (NSString *) line {
	unsigned char centerAlign[3] = {0x1B,0x61,0x01};
	unsigned char normalSize[3] = {0x1D,0x21,0x00};
    [self.printer printData:centerAlign withLength:sizeof(centerAlign)];
	[self.printer printData:normalSize withLength:sizeof(normalSize)];
    [self.printer printString:line];
}


-(void) double_width_left : (NSString *) line {
	unsigned char leftAlign[3] = {0x1B,0x61,0x00};
	unsigned char dWidthSize[3] = {0x1D,0x21,0x10};
    [self.printer printData:leftAlign withLength:sizeof(leftAlign)];
	[self.printer printData:dWidthSize withLength:sizeof(dWidthSize)];
    [self.printer printString:line];
}

-(void) double_width_right : (NSString *) line {
	unsigned char rightAlign[3] = {0x1B,0x61,0x02};
	unsigned char dWidthSize[3] = {0x1D,0x21,0x10};
    [self.printer printData:rightAlign withLength:sizeof(rightAlign)];
	[self.printer printData:dWidthSize withLength:sizeof(dWidthSize)];
    [self.printer printString:line];
}

-(void) double_width_center : (NSString *) line {
	unsigned char centerAlign[3] = {0x1B,0x61,0x01};
	unsigned char dWidthSize[3] = {0x1D,0x21,0x10};
    [self.printer printData:centerAlign withLength:sizeof(centerAlign)];
	[self.printer printData:dWidthSize withLength:sizeof(dWidthSize)];
    [self.printer printString:line];
}



@end
