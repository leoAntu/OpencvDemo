//
//  LWFaceRecognizer.h
//  OpenCVExample
//
//  Created by 叮咚钱包富银 on 2018/8/8.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWFaceRecognizer : NSObject
+ (LWFaceRecognizer *)faceRecognizerWithFile:(NSString *)path;

- (BOOL)serializeFaceRecognizerParamatersToFile:(NSString *)path;

- (NSString *)predict:(UIImage*)img confidence:(double *)confidence;

- (void)updateWithFace:(UIImage *)img name:(NSString *)name;

- (NSArray *)labels;
@end
