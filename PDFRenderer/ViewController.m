//
//  ViewController.m
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "PDFViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Copy original PDF to the destination
    
    NSString * srcPath = [[NSBundle mainBundle] pathForResource:@"sample_0" ofType:@"pdf"];
    
    NSLog(@"src : %@", srcPath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);        
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * destPath = [documentsDirectory stringByAppendingPathComponent:@"Old.pdf"];
    
    NSLog(@"dest : %@", destPath);
    
    NSError * error = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:destPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
        if(error)
        {
            NSLog(@"Error while removing file : %@", [error localizedDescription]);
        }
    }
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&error];
    
    if(error)
    {
        NSLog(@"Error while copying file : %@", [error localizedDescription]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)editPDF:(id)sender {
    [self performSegueWithIdentifier:@"showPDF" sender:sender];
}

- (IBAction)createPDF:(id)sender {
    [self performSegueWithIdentifier:@"showPDF" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPDF"])
    {
        UIButton * button = (UIButton *)sender;
        PDFViewController * vc = (PDFViewController *)segue.destinationViewController;
        
        if([button.titleLabel.text isEqualToString:@"Create PDF"])
        {            
            vc.filePath = [self getPDFFilePath];
            NSLog(@"Create PDF");
        }
        else 
        {
            vc.filePath = [self getPDFFilePath]; 
            vc.oldFilePath = [self getTemplatePDFFilePath];
            NSLog(@"Edit PDF");            
        }
    }
}

-(NSString*)getPDFFilePath
{
    NSString* fileName = @"New.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFilePath = [path stringByAppendingPathComponent:fileName];
    
    return pdfFilePath;    
}

-(NSString*)getTemplatePDFFilePath
{
    NSString* fileName = @"Old.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFilePath = [path stringByAppendingPathComponent:fileName];
    
    return pdfFilePath;    
}

@end
