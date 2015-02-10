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

@interface Rate : NSObject

+(double)rateEquation:(FFUser*)user searchFace:(SearchTemplate*)search;


@end