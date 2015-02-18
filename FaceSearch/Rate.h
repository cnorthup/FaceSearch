//
//  Rate.h
//  FaceSearch
//
//  Created by Charles Northup on 10/15/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFUser.h"
#import "SearchTemplate.h"

@class Rate;

@protocol RatingDelegate <NSObject>

@required

-(void)ratingComplete:(NSArray*)users;
-(void)errorWhileRatingUsers;

@end


@interface Rate : NSObject

enum myRatingSwitch
{
    LinearAlgorith        = 0,
    SimpleDecayAlgortih   = 1,
    ComplexDecayAlgorith  = 2
};
typedef enum myRatingSwitch RatingMode;

@property (strong, nonatomic) NSArray* ratedUsers;
@property (weak, nonatomic) id <RatingDelegate> delegate;


-(void)createTestUsers;


@end