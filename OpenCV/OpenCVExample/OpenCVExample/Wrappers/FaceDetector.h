//
//  FaceDetector.h
//  OpenCVExample
//
//  Created by 叮咚钱包富银 on 2018/8/8.
//  Copyright © 2018年 leo. All rights reserved.
//
#import <opencv2/highgui/cap_ios.h> //opencv的头文件必须放oc头文件之间，否则有报错
#import <Foundation/Foundation.h>

@interface FaceDetector : NSObject
@property (nonatomic, strong) CvVideoCamera* videoCamera;

- (instancetype)initWithCameraView:(UIImageView *)cameraView scale:(CGFloat)scale;
- (NSArray *)detectedFaces;
- (UIImage *)faceWithIndex:(NSInteger)idx;
- (void)startCapture;
- (void)stopCapture;
@end
