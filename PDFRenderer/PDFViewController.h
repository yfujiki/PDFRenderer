//
//  PDFViewController.h
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFRenderer.h"

@interface PDFViewController : UIViewController

@property (nonatomic, strong) NSString * filePath;
@property (nonatomic, strong) NSString * oldFilePath;

- (void) showPDFFile;

@end
