//
//  DabbaListingVC.m
//  Dabba4U
//
//  Created by Akrati Goel on 3/6/15.
//  Copyright (c) 2015 Snapdeal.com. All rights reserved.
//

#import "DabbaListingVC.h"
#import "AppDelegate.h"
#import "DabbaInfoVC.h"

@interface DabbaListingVC ()

@end

@implementation DabbaListingVC

@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Dabba4U"];
    [activityVw setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table View delegate n data source method

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
/**
 Table View Data source for number of rows in Table
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [myDelegate.dataArr count];
}

/**
 Table View Data source for Height of cell for Particular indexPath
 */

-(CGFloat)evaluateHeightForText:(NSString *)str{
    UILabel *sampleLbl = [[UILabel alloc]init ];
    [sampleLbl setFrame:CGRectMake(5.0f, 5.0f, 290.0f, sampleLbl.frame.size.height)];
    
    [sampleLbl setText:str];
    [sampleLbl setLineBreakMode:NSLineBreakByWordWrapping];
    [sampleLbl setBackgroundColor:[UIColor orangeColor]];
    [sampleLbl setFont:[UIFont systemFontOfSize:15.0f]];
    sampleLbl.numberOfLines = 0;
    // resize label
    [sampleLbl sizeToFit];
    CGFloat hight;
    hight = sampleLbl.frame.size.height;
    
    return hight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight;
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];

    hight = [self evaluateHeightForText:[[myDelegate.dataArr objectAtIndex:indexPath.row] objectForKey:@"address"]];
    
    CGFloat tst = 65.0f+hight+30.0f+5.0f;
    return tst;
}

-(void)callAction:(UIButton*)sender{
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *mobNum = [NSString stringWithFormat:@"%@",[[myDelegate.dataArr objectAtIndex:[sender tag]] objectForKey:@"phone"]];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:mobNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

/**
 Table View Data source for Cell at indexPath
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *nameLbl;
        nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(18.0f, 5.0f, 255.0f, 25.0f)];
        nameLbl.backgroundColor = [UIColor clearColor];
        [nameLbl setFont:[UIFont systemFontOfSize:15.0f]];
        [nameLbl setTag:1];
        [cell.contentView addSubview:nameLbl];
        
        UIImageView *foodTypeImg;
        foodTypeImg = [[UIImageView alloc]initWithFrame:CGRectMake(280.0f, 9.0f, 25.0f, 25.0f)];
        foodTypeImg.backgroundColor = [UIColor clearColor];
        [foodTypeImg setTag:4];
        [cell.contentView addSubview:foodTypeImg];
        
        UIButton *phoneBtn;
        phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(18.0f, 35.0f, 290.0f, 25.0f)];
        phoneBtn.backgroundColor = [UIColor clearColor];
        [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [phoneBtn setTitleColor:[UIColor colorWithRed:0.082 green:0.494 blue:0.984 alpha:1] forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:phoneBtn];
        
        UIImageView *phoneImg;
        phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(120.0f, 33.0f, 25.0f, 25.0f)];
        phoneImg.backgroundColor = [UIColor clearColor];
        [phoneImg setImage:[UIImage imageNamed:@"call.png"]];
        [cell.contentView addSubview:phoneImg];

        UILabel *addressLbl;
        addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(18.0f, 65.0f, 290.0f, 25.0f)];
        addressLbl.backgroundColor = [UIColor clearColor];
        [addressLbl setTag:3];
        [addressLbl setTextColor:[UIColor grayColor]];
        [addressLbl setFont:[UIFont systemFontOfSize:15.0f]];
        [cell.contentView addSubview:addressLbl];
        
        UILabel *qtyLbl;
        qtyLbl = [[UILabel alloc]initWithFrame:CGRectMake(18.0f, 95.0f, 290.0f, 25.0f)];
        qtyLbl.backgroundColor = [UIColor clearColor];
        [qtyLbl setFont:[UIFont systemFontOfSize:15.0f]];
        [qtyLbl setTag:5];
        [cell.contentView addSubview:qtyLbl];
    }
    NSArray *currentViews = [cell.contentView subviews];
    NSInteger selectedRow = indexPath.row;
    
    AppDelegate *myDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *addStr = [NSString stringWithFormat:@"%@",[[myDelegate.dataArr objectAtIndex:selectedRow] objectForKey:@"address"]];
    
    BOOL isVeg = [[[myDelegate.dataArr objectAtIndex:selectedRow] objectForKey:@"food_type"] boolValue];
    UIImage *vegImg = [UIImage imageNamed:@"veg.png"];
    UIImage *nvImg = [UIImage imageNamed:@"nv.png"];
    for(id myView in currentViews)
    {
        if(([myView isKindOfClass:[UILabel class]]) && ([myView tag]==1)){
            //Name 
            [(UILabel *)myView setText:[NSString stringWithFormat:@"%@",[[myDelegate.dataArr objectAtIndex:selectedRow] objectForKey:@"name"]]];
        }
        if(([myView isKindOfClass:[UIButton class]]) ){
            //phone
            [(UIButton *)myView setTitle:[NSString stringWithFormat:@"%@",[[myDelegate.dataArr objectAtIndex:selectedRow] objectForKey:@"phone"]] forState:UIControlStateNormal];
            [(UIButton *)myView setTag:indexPath.row];
        }
        if(([myView isKindOfClass:[UILabel class]]) && ([myView tag]==3)){
            //Address
            UILabel *sampleLbl = (UILabel*) myView;
            [sampleLbl setText:addStr];
            sampleLbl.lineBreakMode = NSLineBreakByWordWrapping;
            sampleLbl.numberOfLines = 0;
            [sampleLbl sizeToFit];
        }
        if(([myView isKindOfClass:[UIImageView class]]) && ([myView tag]==4)){
            //Food Type
            if (isVeg) {
                [myView setImage:vegImg];
            }
            else{
                [myView setImage:nvImg];
            }
        }
        if(([myView isKindOfClass:[UILabel class]]) && ([myView tag]==5)){
            //Qty
            [(UILabel *)myView setText:[NSString stringWithFormat:@"No. of people served: %@",[[myDelegate.dataArr objectAtIndex:selectedRow] objectForKey:@"num_people"]]];
            CGFloat ht = [self evaluateHeightForText:addStr];
            [(UILabel *)myView setFrame:CGRectMake(18.0f, ht + 65.0f + 5.0f, 290.0f, 25.0f)];
        }
    }

    [cell setBackgroundColor:[UIColor clearColor]];
    
    [tableView setShowsVerticalScrollIndicator:FALSE];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DabbaInfoVC *dabbaInfoVC = [[DabbaInfoVC alloc]initWithNibName:@"DabbaInfoVC" bundle:nil];
    [dabbaInfoVC setTagVal:indexPath.row];
    [self.navigationController pushViewController:dabbaInfoVC animated:YES];
}

@end
