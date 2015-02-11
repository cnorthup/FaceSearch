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
  * [eyes, nose, ears, hair, lips, eyebrows, headshape, facial hair, glasses shape]
  *GENDER 
  *   yes = female
  *   no  = male
**/
@property (strong, nonatomic) NSMutableArray* featuresValue;
@property (strong, nonatomic) NSMutableArray* extraMaleFeatureValue;


@property (strong, nonatomic) NSNumber* hairShape;
@property (strong, nonatomic) NSNumber* lipShape;
@property (strong, nonatomic) NSNumber* earShape;
@property (strong, nonatomic) NSNumber* eyeShape;
@property (strong, nonatomic) NSNumber* noseShape;
@property (strong, nonatomic) NSNumber* eyeBrowShape;

@property (strong, nonatomic) NSNumber* facialHairShape;
@property (strong, nonatomic) NSNumber* headShape;
@property (strong, nonatomic) NSNumber* glassesShape;

@property (nonatomic) BOOL gender;


@property (strong, nonatomic) NSNumber* score;


@end
