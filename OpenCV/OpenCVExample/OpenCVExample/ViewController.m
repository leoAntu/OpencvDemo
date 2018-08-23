//
//  ViewController.m
//  OpenCVExample
//
//  Created by 叮咚钱包富银 on 2018/8/8.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "OpenCVController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)opencvAction:(id)sender {
    OpenCVController *vc = [[OpenCVController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
