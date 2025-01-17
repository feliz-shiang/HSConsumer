//
//  GYInstructionViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYInstructionViewController.h"

@interface GYInstructionViewController ()
{
    __weak IBOutlet UILabel *lbTitle;
    __weak IBOutlet UITextView *lbContent;

}

@end

@implementation GYInstructionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lbTitle.text = self.strTitle;
    lbContent.text = self.strContent;
    
 
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0")) {
        lbContent.allowsEditingTextAttributes = YES;
        //设置文本字体，间隔
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lbContent.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8.0;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lbContent.text.length)];
        lbContent.attributedText = attributedString;
    }
   
    lbContent.font = [UIFont systemFontOfSize:15.5];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
