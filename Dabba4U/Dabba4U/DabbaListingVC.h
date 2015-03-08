//
//  DabbaListingVC.h
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DabbaListingVC : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblVw;
    IBOutlet UIActivityIndicatorView *activityVw;
}

@property (nonatomic,strong)NSMutableArray *dataArray;

@end
