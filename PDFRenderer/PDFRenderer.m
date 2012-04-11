//
//  PDFRenderer.m
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDFRenderer.h"

@implementation PDFRenderer

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frame fontName:(NSString *)fontName fontSize:(int) fontSize
{        
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    
    // Prepare the text using a Core Text Framesetter.
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fontName, fontSize, NULL);
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGRect frameRect = (CGRect){frame.origin.x, -1 * frame.origin.y, frame.size};
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
            
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Revert coordinate
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(frameSetter);    
}

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    [image drawInRect:rect];
}

+(void)createPDF:(NSString*)filePath
{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);

    [PDFRenderer drawText:@"Hello World" inFrame:CGRectMake(150, 150, 300, 50) fontName:@"Times" fontSize:36];
    
    CGPoint from = CGPointMake(0, 0);
    CGPoint to = CGPointMake(200, 300);
    [PDFRenderer drawLineFromPoint:from toPoint:to];

    UIImage* logo = [UIImage imageNamed:@"apple-icon.png"];
    CGRect frame = CGRectMake(20, 100, 60, 60);
    
    [PDFRenderer drawImage:logo inRect:frame];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)editPDF:(NSString*)filePath templateFilePath:(NSString*) templatePath
{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        
    //open template file
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (__bridge CFStringRef)templatePath, kCFURLPOSIXPathStyle, 0);
    CGPDFDocumentRef templateDocument = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    
    //get bounds of template page
    CGPDFPageRef templatePage = CGPDFDocumentGetPage(templateDocument, 1);
    CGRect templatePageBounds = CGPDFPageGetBoxRect(templatePage, kCGPDFCropBox);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //flip context due to different origins
    CGContextTranslateCTM(context, 0.0, templatePageBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //copy content of template page on the corresponding page in new file
    CGContextDrawPDFPage(context, templatePage);
    
    //flip context back
    CGContextTranslateCTM(context, 0.0, templatePageBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Edit body
    [PDFRenderer drawText:@"Hello World" inFrame:CGRectMake(150, 550, 300, 50) fontName:@"Times" fontSize:36];
    
    CGPoint from = CGPointMake(0, 400);
    CGPoint to = CGPointMake(200, 700);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    
    UIImage* logo = [UIImage imageNamed:@"apple-icon.png"];
    CGRect frame = CGRectMake(20, 500, 60, 60);
    
    [PDFRenderer drawImage:logo inRect:frame];
    
    
    CGPDFDocumentRelease(templateDocument);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}
@end
