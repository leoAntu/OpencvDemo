//
//  OpencvRecognizerViewController.m
//  OpenCVExample
//
//  Created by 叮咚钱包富银 on 2018/8/8.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "OpencvRecognizerViewController.h"
#import "LWFaceRecognizer.h"

@interface OpencvRecognizerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iamgeIcon;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *wrongBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, strong) LWFaceRecognizer *faceModel;

@end

@implementation OpencvRecognizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.iamgeIcon.image = self.inputImage;
    NSURL *modelURL = [self faceModelFileURL];
    NSLog(@"%@",NSHomeDirectory());
    
    self.faceModel = [LWFaceRecognizer faceRecognizerWithFile:[modelURL path]];

    double confidence;
    if (_faceModel.labels.count == 0) {
        [_faceModel updateWithFace:_inputImage name:@"Person 1"];
    }
    
    NSString *name = [_faceModel predict:_inputImage confidence:&confidence];
    
    _lable1.text = name;
    _label2.text = [@(confidence) stringValue];
}

- (NSURL *)faceModelFileURL {
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [paths lastObject];
    NSURL *modelURL = [documentsURL URLByAppendingPathComponent:@"face-model.xml"];
    return modelURL;
}


@end
