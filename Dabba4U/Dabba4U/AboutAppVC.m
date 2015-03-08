//
//  AboutAppVC.m
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import "AboutAppVC.h"

@interface AboutAppVC ()

@end

@implementation AboutAppVC

-(void)setData{
    [self setTitle:@"About the app"];
    
    // get a reference to our file
    NSString *myPath = [[NSBundle mainBundle]pathForResource:@"aboutUs" ofType:@"txt"];
    
    // read the contents into a string
    NSString *myFile = [[NSString alloc]initWithContentsOfFile:myPath encoding:NSUTF8StringEncoding error:nil];
    
    // display our file
    [infoLabel setText:myFile];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 0;
    [infoLabel sizeToFit];
    [infoLabel setBackgroundColor:[UIColor clearColor]];

    [scroller setBackgroundColor:[UIColor clearColor]];
    [scroller setContentSize:CGSizeMake(scroller.frame.size.width, infoLabel.frame.size.height)];
    [scroller setScrollEnabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
