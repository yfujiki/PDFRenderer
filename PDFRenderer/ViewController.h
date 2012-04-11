//
//  ViewController.h
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)editPDF:(id)sender;
- (IBAction)createPDF:(id)sender;

-(NSString*)getPDFFilePath;
-(NSString*)getTemplatePDFFilePath;

@end
