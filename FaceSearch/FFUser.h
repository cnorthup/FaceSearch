//
//  FFUser.h
//  FaceSearch
//
//  Created by Charles Northup on 10/15/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFUser : NSObject

/** array for both of rank and value goes like this
  * [eyes, nose, ears, hair, chin, lips, eyebrows]
**/
@property (strong, nonatomic) NSArray* featuresRank;
@property (strong, nonatomic) NSArray* featuresValue;

@property (nonatomic) bool allFeaturesMatter;

@property (strong, nonatomic) NSNumber* score;


@end
