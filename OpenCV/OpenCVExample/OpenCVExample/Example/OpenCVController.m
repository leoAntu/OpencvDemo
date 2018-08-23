//
//  OpenCVController.m
//  OpenCVExample
//
//  Created by 叮咚钱包富银 on 2018/8/8.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "OpenCVController.h"
#import "FaceDetector.h"
#import "OpencvRecognizerViewController.h"

@interface OpenCVController ()
@property (weak, nonatomic) IBOutlet UIImageView *cameraView;
@property (nonatomic, strong) FaceDetector *faceDetector;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation OpenCVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.faceDetector = [[FaceDetector alloc] initWithCameraView:_cameraView scale:2.0];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(handleTap:)];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.faceDetector startCapture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.faceDetector stopCapture];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    NSArray *detectedFaces = [self.faceDetector.detectedFaces copy];
    CGSize windowSize = self.view.bounds.size;
    for (NSValue *val in detectedFaces) {
        CGRect faceRect = [val CGRectValue];
        CGPoint tapPoint = [tapGesture locationInView:nil];
        //scale tap point to 0.0 to 1.0
        CGPoint scaledPoint = CGPointMake(tapPoint.x/windowSize.width, tapPoint.y/windowSize.height);
        if(CGRectContainsPoint(faceRect, scaledPoint)){
            NSLog(@"tapped on face: %@", NSStringFromCGRect(faceRect));
            UIImage *img = [self.faceDetector faceWithIndex:[detectedFaces indexOfObject:val]];
            OpencvRecognizerViewController *vc = [[OpencvRecognizerViewController alloc] init];
            vc.inputImage = img;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            NSLog(@"tapped on no face");
        }
    }
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
