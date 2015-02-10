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
  * [eyes, nose, ears, hair, chin, lips, eyebrows, headshape, facial hair, glasses shape]
**/
@property (strong, nonatomic) NSArray* featuresRank;
@property (strong, nonatomic) NSArray* featuresValue;
@property (strong, nonatomic) NSNumber* headShape;
@property (strong, nonatomic) NSNumber* hairShape;
@property (strong, nonatomic) NSNumber* lipShape;
@property (strong, nonatomic) NSNumber* earShape;
@property (strong, nonatomic) NSNumber* eyeShape;
@property (strong, nonatomic) NSNumber* facialHairShape;
@property (strong, nonatomic) NSNumber* noseShape;
@property (strong, nonatomic) NSNumber* glassesShape;
@property (nonatomic) BOOL gender;


@property (strong, nonatomic) NSNumber* score;


@end
