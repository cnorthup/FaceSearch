//
//  SearchTemplate.h
//  FaceSearch
//
//  Created by Charles Northup on 2/10/15.
//  Copyright (c) 2015 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFUser.h"

@interface SearchTemplate : FFUser

@property (strong, nonatomic) NSNumber* headRank;
@property (strong, nonatomic) NSNumber* hairRank;
@property (strong, nonatomic) NSNumber* lipRank;
@property (strong, nonatomic) NSNumber* earRank;
@property (strong, nonatomic) NSNumber* eyeRank;
@property (strong, nonatomic) NSNumber* facialHairRank;
@property (strong, nonatomic) NSNumber* noseRank;
@property (strong, nonatomic) NSNumber* glassesRank;
@property (nonatomic) bool allFeaturesMatter;


@end