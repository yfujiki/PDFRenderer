//
//  PDFRenderer.h
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface PDFRenderer : NSObject

+ (void)drawText:(NSString*)text inFrame:(CGRect)frame fontName:(NSString *)fontName fontSize:(int) fontSize;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
    
+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)createPDF:(NSString*)filePath;

+(void)editPDF:(NSString*)filePath templateFilePath:(NSString*) templatePath;
@end
