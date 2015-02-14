//
//  Rate.m
//  FaceSearch
//
//  Created by Charles Northup on 10/15/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "Rate.h"
#import "math.h"

@interface Rate ()

@property (strong, nonatomic)SearchTemplate* searchFace;
@property (nonatomic)RatingMode* ratingMode;

@end

@implementation Rate


-(id)initWithArray:(NSArray*)users withRatingMode:(RatingMode)preferedMode
{
    self = [super init];
    
    if (self)
    {
        self.ratedUsers = [self divvyOutWork:users withRatingMode:preferedMode];
    }
    return self;
}

-(NSArray*)divvyOutWork:(NSArray*)work withRatingMode:(RatingMode)mode
{
    //int threadNeed = ;
    
    ///NSOperationQueue* queue = [NSOperationQueue new];
   // dispatch_queue_t backgrounQueue = dispatch_queue_create("com.application.rating.core1", DISPATCH_QUEUE_CONCURRENT);
    
    int threadNeed = 0;
    int arrayCount = (int)work.count - 1;
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t groupQueue = dispatch_group_create();
    NSMutableArray* partialArray = [NSMutableArray new];

    if (arrayCount > 100)
    {
        int leftOver = arrayCount % 50;
        if (leftOver != 0)
        {
            threadNeed = (arrayCount/50)+1;
        }
        else
        {
            threadNeed = arrayCount/50;
        }
        
        for (int x = 0; x < threadNeed; x++)
        {
            NSMutableArray* smallArray = [NSMutableArray new];
            int p = x * 50;
            int g;
            if (arrayCount - p > 50)
            {
                g = 50;
            }
            else
            {
                g = arrayCount - p;
            }
            for (int z = p; z < g; z++)
            {
                [smallArray addObject:[work objectAtIndex:z]];

            }
            
            dispatch_group_async(groupQueue, backgroundQueue, ^{
                [partialArray addObjectsFromArray:[self scoreUsers:smallArray withRating:mode]];
            });
            
        }
        dispatch_group_notify(groupQueue, backgroundQueue, ^{
            [partialArray sortUsingComparator:^NSComparisonResult(FFUser* obj1, FFUser* obj2)
             {
                 if (obj1.score.doubleValue > obj2.score.doubleValue)
                 {
                     return NSOrderedAscending;
                 }
                 else if(obj1.score.doubleValue < obj2.score.doubleValue)
                 {
                     return NSOrderedDescending;
                 }
                 else
                 {
                     return NSOrderedSame;
                 }
             }];
            
        });
        return partialArray;
    }
    else
    {
        return [self scoreUsers:work withRating:mode];
    }

}


#pragma --mark Creating Score


-(NSMutableArray*)scoreUsers:(NSArray*)users withRating:(RatingMode)ratingMode
{
    NSMutableArray* scoredUsers = [NSMutableArray new];
    for (FFUser* user in users)
    {
        switch (ratingMode)
        {
            case LinearAlgorith:
                [scoredUsers addObject:[self linearRating:user]];
                break;
                
            case SimpleDecayAlgortih:
                [scoredUsers addObject:[self simpleDecayRating:user]];
                
                break;
                
            case ComplexDecayAlgorith:
                [scoredUsers addObject:[self complexDecayRating:user]];
                
                break;
                
                
            default:
                NSLog(@"did not select rating mode");
                return nil;
                break;
        }
    }
    [scoredUsers sortUsingComparator:^NSComparisonResult(FFUser* obj1, FFUser* obj2)
    {
        if (obj1.score.doubleValue > obj2.score.doubleValue)
        {
            return NSOrderedAscending;
        }
        else if(obj1.score.doubleValue < obj2.score.doubleValue)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    return scoredUsers;
}

-(FFUser*)linearRating:(FFUser*)user
{
    switch (self.searchFace.earRank.intValue) {
        case 0:
            NSLog(@"Did not rank ear");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:[Rate hardLinearEquation:user.earShape template:self.searchFace.earShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:[Rate easyLinearEquation:user.earShape template:self.searchFace.earShape]];
            break;
    }
    
    switch (self.searchFace.eyeRank.intValue) {
        case 0:
            NSLog(@"Did not rank eye");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate hardLinearEquation:user.eyeShape template:self.searchFace.eyeShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate easyLinearEquation:user.eyeShape template:self.searchFace.eyeShape]];
            break;
    }
    
    switch (self.searchFace.eyeBrowRank.intValue) {
        case 0:
            NSLog(@"Did not rank eyebrow");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate hardLinearEquation:user.eyeBrowShape template:self.searchFace.eyeBrowShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate easyLinearEquation:user.eyeBrowShape template:self.searchFace.eyeBrowShape]];
            break;
    }
    
    switch (self.searchFace.hairRank.intValue) {
        case 0:
            NSLog(@"Did not rank hair");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate hardLinearEquation:user.hairShape template:self.searchFace.hairShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate easyLinearEquation:user.hairShape template:self.searchFace.hairShape]];
            break;
    }
    
    switch (self.searchFace.lipRank.intValue) {
        case 0:
            NSLog(@"Did not rank lip");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate hardLinearEquation:user.lipShape template:self.searchFace.lipShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate easyLinearEquation:user.lipShape template:self.searchFace.lipShape]];
            break;
    }
    
    switch (self.searchFace.noseRank.intValue) {
        case 0:
            NSLog(@"Did not rank nose");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate hardLinearEquation:user.noseShape template:self.searchFace.noseShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate easyLinearEquation:user.noseShape template:self.searchFace.noseShape]];
            break;
    }
    
    switch (self.searchFace.headShapeRank.intValue) {
        case 0:
            NSLog(@"Did not rank headshape");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate hardLinearEquation:user.headShape template:self.searchFace.headShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate easyLinearEquation:user.headShape template:self.searchFace.headShape]];
            break;
    }
    
    switch (self.searchFace.facialHairRank.intValue) {
        case 0:
            NSLog(@"Did not rank facial hair");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate hardLinearEquation:user.facialHairShape template:self.searchFace.facialHairShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithInt:user.score.intValue + [Rate easyLinearEquation:user.facialHairShape template:self.searchFace.facialHairShape]];
            break;
    }
    
    return user;
}

-(FFUser*)complexDecayRating:(FFUser*)user
{
    switch (self.searchFace.earRank.intValue) {
        case 0:
            NSLog(@"Did not rank ear");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:[Rate harshComplexDecay:user.earShape template:self.searchFace.earShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:[Rate easyComplexDecay:user.earShape template:self.searchFace.earShape]];
            break;
    }
    
    switch (self.searchFace.eyeRank.intValue) {
        case 0:
            NSLog(@"Did not rank eye");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshComplexDecay:user.eyeShape template:self.searchFace.eyeShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easyComplexDecay:user.eyeShape template:self.searchFace.eyeShape]];
            break;
    }
    
    switch (self.searchFace.eyeBrowRank.intValue) {
        case 0:
            NSLog(@"Did not rank eyebrow");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshComplexDecay:user.eyeBrowShape template:self.searchFace.eyeBrowShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easyComplexDecay:user.eyeBrowShape template:self.searchFace.eyeBrowShape]];
            break;
    }
    
    switch (self.searchFace.hairRank.intValue) {
        case 0:
            NSLog(@"Did not rank hair");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshComplexDecay:user.hairShape template:self.searchFace.hairShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easyComplexDecay:user.hairShape template:self.searchFace.hairShape]];
            break;
    }
    
    switch (self.searchFace.lipRank.intValue) {
        case 0:
            NSLog(@"Did not rank lip");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshComplexDecay:user.lipShape template:self.searchFace.lipShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easyComplexDecay:user.lipShape template:self.searchFace.lipShape]];
            break;
    }
    
    switch (self.searchFace.noseRank.intValue) {
        case 0:
            NSLog(@"Did not rank nose");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshComplexDecay:user.noseShape template:self.searchFace.noseShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easyComplexDecay:user.noseShape template:self.searchFace.noseShape]];
            break;
    }
    
    switch (self.searchFace.headShapeRank.intValue) {
        case 0:
            NSLog(@"Did not rank headshape");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshComplexDecay:user.headShape template:self.searchFace.headShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easyComplexDecay:user.headShape template:self.searchFace.headShape]];
            break;
    }
    
    switch (self.searchFace.facialHairRank.intValue) {
        case 0:
            NSLog(@"Did not rank facial hair");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshComplexDecay:user.facialHairShape template:self.searchFace.facialHairShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easyComplexDecay:user.facialHairShape template:self.searchFace.facialHairShape]];
            break;
    }
    
    return user;
}

-(FFUser*)simpleDecayRating:(FFUser*)user
{
    switch (self.searchFace.earRank.intValue) {
        case 0:
            NSLog(@"Did not rank ear");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:[Rate harshSimpleDecay:user.earShape template:self.searchFace.earShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:[Rate easySimpleDecay:user.earShape template:self.searchFace.earShape]];
            break;
    }
    
    switch (self.searchFace.eyeRank.intValue) {
        case 0:
            NSLog(@"Did not rank eye");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshSimpleDecay:user.eyeShape template:self.searchFace.eyeShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easySimpleDecay:user.eyeShape template:self.searchFace.eyeShape]];
            break;
    }
    
    switch (self.searchFace.eyeBrowRank.intValue) {
        case 0:
            NSLog(@"Did not rank eyebrow");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshSimpleDecay:user.eyeBrowShape template:self.searchFace.eyeBrowShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easySimpleDecay:user.eyeBrowShape template:self.searchFace.eyeBrowShape]];
            break;
    }
    
    switch (self.searchFace.hairRank.intValue) {
        case 0:
            NSLog(@"Did not rank hair");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshSimpleDecay:user.hairShape template:self.searchFace.hairShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easySimpleDecay:user.hairShape template:self.searchFace.hairShape]];
            break;
    }
    
    switch (self.searchFace.lipRank.intValue) {
        case 0:
            NSLog(@"Did not rank lip");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshSimpleDecay:user.lipShape template:self.searchFace.lipShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easySimpleDecay:user.lipShape template:self.searchFace.lipShape]];
            break;
    }
    
    switch (self.searchFace.noseRank.intValue) {
        case 0:
            NSLog(@"Did not rank nose");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshSimpleDecay:user.noseShape template:self.searchFace.noseShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easySimpleDecay:user.noseShape template:self.searchFace.noseShape]];
            break;
    }
    
    switch (self.searchFace.headShapeRank.intValue) {
        case 0:
            NSLog(@"Did not rank headshape");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshSimpleDecay:user.headShape template:self.searchFace.headShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easySimpleDecay:user.headShape template:self.searchFace.headShape]];
            break;
    }
    
    switch (self.searchFace.facialHairRank.intValue) {
        case 0:
            NSLog(@"Did not rank facial hair");
            break;
        case 1:
        case 2:
        case 3:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate harshSimpleDecay:user.facialHairShape template:self.searchFace.facialHairShape]];
            break;
            
        default:
            user.score = [NSNumber numberWithDouble:user.score.doubleValue + [Rate easySimpleDecay:user.facialHairShape template:self.searchFace.facialHairShape]];
            break;
    }
    
    return user;
}



#pragma --mark New RatingEquations

+(double)harshSimpleDecay:(NSNumber*)user template:(NSNumber*)template
{
    double z = 0.0;
    int x = abs(user.intValue - template.intValue);
    z = (14 * exp(((-x) + .29)*(1/5)))-.75;
    return z;
}

+(double)easySimpleDecay:(NSNumber*)user template:(NSNumber*)template
{
    double z = 0.0;
    int x = abs(user.intValue - template.intValue);
    z = 14.141 - (15 * exp((x - 14) * (1/3)));
    return z;
}

+(double)harshComplexDecay:(NSNumber*)user template:(NSNumber*)template
{
    double z = 0.0;
    int x = abs(user.intValue - template.intValue);
    z = 14 * exp((-x) * (1/3));
    return z;
}

+(double)easyComplexDecay:(NSNumber*)user template:(NSNumber*)template
{
    double z = 0.0;
    int x = abs(user.intValue - template.intValue);
    z = 14 - (14 * exp((x) * (1/3)));
    return z;
}

+(int)hardLinearEquation:(NSNumber*)user template:(NSNumber*)template
{
    int x = abs(user.intValue - template.intValue);
    
    if (x <= 4)
    {
        return 14 - (1.5 * x);
    }
    else if(4 < x < 10)
    {
        return 12 - x;
    }
    else
    {
        return 7 - (x * .5);
    }
}

+(int)easyLinearEquation:(NSNumber*)user template:(NSNumber*)template
{
    int z = abs(user.intValue - template.intValue);
    
    if (z <= 4)
    {
        return 14 - (.5 * z);
    }
    else if(4 < z < 10)
    {
        return 16 - z;
    }
    else
    {
        return 21 - (z * 1.5);
    }
}



#pragma --mark Orginal Rating

+(NSArray*)rateUsers:(NSArray*)users searchFace:(SearchTemplate*)searchFace;
{
    NSMutableArray* array = [NSMutableArray new];
    for (FFUser* user in users)
    {
        user.score = [NSNumber numberWithDouble:[Rate rateEquation:user searchFace:searchFace]];
        [array addObject:user];
    }
    array = [NSMutableArray arrayWithArray:[array sortedArrayUsingComparator:^NSComparisonResult(FFUser* obj1, FFUser* obj2) {
        if (obj1.score < obj2.score) {
            return NSOrderedDescending;
        }
        else if (obj1.score > obj2.score) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }]];
    return array;
}

+(double)rateEquation:(FFUser*)user searchFace:(SearchTemplate*)search
{
    /** array for both of rank and value goes like this
     * [eyes, nose, ears, hair, chin, lips, eyebrows]
     **/
    
    double calculatedValue = 0.0;
    for (int q = 0; q < 6; q++)
    {
        NSNumber* number = [search.featuresRank objectAtIndex:q];
        
        switch (number.intValue) {
            case 0:
                NSLog(@"nothing");
                break;
                
            case 1:
                calculatedValue = calculatedValue + [Rate equationForFirstFeature:[search.featuresValue objectAtIndex:q] userValue:[user.featuresValue objectAtIndex:q]];
                break;
                
            case 2:
                calculatedValue = calculatedValue + [Rate equationForSecondFeature:[search.featuresValue objectAtIndex:q] userValue:[user.featuresValue objectAtIndex:q]];
                break;
                
            case 3:
                calculatedValue = calculatedValue + [Rate equationForThirdFeature:[search.featuresValue objectAtIndex:q] userValue:[user.featuresValue objectAtIndex:q] allMatter:search.allFeaturesMatter];
                break;
                
            case 4:
                calculatedValue = calculatedValue + [Rate equationForFourthFeature:[search.featuresValue objectAtIndex:q] userValue:[user.featuresValue objectAtIndex:q] allMatter:search.allFeaturesMatter];
                break;
                
            case 5:
                calculatedValue = calculatedValue + [Rate equationForFifthFeature:[search.featuresValue objectAtIndex:q] userValue:[user.featuresValue objectAtIndex:q] allMatter:search.allFeaturesMatter];
                break;
                
            case 6:
                calculatedValue = calculatedValue + [Rate equationForSixthFeature:[search.featuresValue objectAtIndex:q] userValue:[user.featuresValue objectAtIndex:q] allMatter:search.allFeaturesMatter];
                break;
                
            default:
                break;
        }
        
    }
    return calculatedValue;
}

+(FFUser*)prepareForRating:(FFUser*)user searchFace:(SearchTemplate*)searchFace
{
    for (int x = 0; x > 10; x++)
    {
        [user.featuresValue addObject:@"placeHolder"];
    }
    [user.featuresValue insertObject:user.eyeShape atIndex:searchFace.eyeRank.intValue];
    [user.featuresValue insertObject:user.earShape atIndex:searchFace.earRank.intValue];
    [user.featuresValue insertObject:user.lipShape atIndex:searchFace.lipRank.intValue];
    [user.featuresValue insertObject:user.eyeBrowShape atIndex:searchFace.eyeBrowRank.intValue];
    [user.featuresValue insertObject:user.noseShape atIndex:searchFace.noseRank.intValue];
    [user.featuresValue insertObject:user.hairShape atIndex:searchFace.hairRank.intValue];
    
    NSPredicate* filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isEqualToString:@"placeHolder"])
        {
            return nil;
        }
        else
        {
            return evaluatedObject;
        }
    }];
    
    user.featuresValue = (NSMutableArray*)[user.featuresValue filteredArrayUsingPredicate:filter];
    
    return user;
}


#pragma --mark Decay Rate

+(double)decayEquation:(SearchTemplate*)search other:(FFUser*)otherUser
{
    double z = 0.0;
    BOOL allMatter = YES;
    for (NSNumber* value in search.featuresValue)
    {
        if (value.doubleValue == 0.0)
        {
            allMatter = NO;
        }
    }
    if (allMatter == YES)
    {
//        for (NSNumber* rank in search.featuresRank) {
//            
//        }
        for (int r = 0; r < 3; r++)
        {
            int x = abs((int)[search.featuresValue objectAtIndex:r] - (int)[otherUser.featuresValue objectAtIndex:r]);
            z += 14 * exp((-x) * (1/3));
        }
        for (int r = 3; r < 6; r++)
        {
            int x = abs((int)[search.featuresValue objectAtIndex:r] - (int)[otherUser.featuresValue objectAtIndex:r]);
            z += 14 - (14 * exp((x) * (1/3)));
        }
    }

   // int x = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    //this is the equation
    //             -(x * 0.3
    //  y = 14 * e^
    //return 14 * exp((x) * 0.3);
    return z;
}

+(double)decayRateAlgorith:(SearchTemplate*)search other:(FFUser*)otherUser
{
    if (search.gender == YES)
    {
        double z = 0.0;
        BOOL allMatter = YES;
        for (NSNumber* value in search.featuresValue)
        {
            if (value.doubleValue == 0.0)
            {
                allMatter = NO;
            }
        }
        if (allMatter == YES)
        {
            for (int r = 0; r < 3; r++)
            {
                int x = abs((int)[search.featuresValue objectAtIndex:r] - (int)[otherUser.featuresValue objectAtIndex:r]);
                z += (14 * exp(((-x) + .29)*(1/5)))-.75;
            }
            for (int r = 3; r < 6; r++)
            {
                int x = abs((int)[search.featuresValue objectAtIndex:r] - (int)[otherUser.featuresValue objectAtIndex:r]);
                z += 14.141 - (15 * exp((x - 14) * (1/3)));
            }
        }
        return z;
    }
    else
    {
        double z = 0.0;
        BOOL allMatter = YES;
        for (NSNumber* value in search.featuresValue)
        {
            if (value.doubleValue == 0.0)
            {
                allMatter = NO;
            }
        }
        if (allMatter == YES)
        {
            for (int r = 0; r < 3; r++)
            {
                int x = abs((int)[search.featuresValue objectAtIndex:r] - (int)[otherUser.featuresValue objectAtIndex:r]);
                z += (14 * exp(((-x) + .29)*(1/5)))-.75;
            }
            for (int r = 3; r < 7; r++)
            {
                int x = abs((int)[search.featuresValue objectAtIndex:r] - (int)[otherUser.featuresValue objectAtIndex:r]);
                z += 14.141 - (15 * exp((x - 14) * (1/3)));
            }
        }
        return z;
        
    }

}


#pragma --mark Equation my dad recommeneded

+(int)equationForFirstFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue
{
    int x = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    if (x <= 4)
    {
        return 14 - (1.5 * x);
    }
    else if(4 < x < 10)
    {
        return 12 - x;
    }
    else
    {
        return 7 - (x * .5);
    }
}

+(int)equationForSecondFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue
{
    int y = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    if (y <= 4)
    {
        return 14 - (1.5 * y);
    }
    else if(4 < y < 10)
    {
        return 12 - y;
    }
    else
    {
        return 7 - (y * .5);
    }
}

+(int)equationForThirdFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue allMatter:(BOOL)value
{
    int w = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    if (value == YES)
    {
        if (w <= 4)
        {
            return 14 - (1.5 * w);
        }
        else if(4 < w < 10)
        {
            return 12 - w;
        }
        else
        {
            return 7 - (w * .5);
        }
    }
    else
    {
        
        if (w <= 4)
        {
            return 14 - (.5 * w);
        }
        else if(4 < w < 10)
        {
            return 16 - w;
        }
        else
        {
            return 21 - (w * 1.5);
        }
    }
}

+(int)equationForFourthFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue allMatter:(BOOL)value

{
    if (searchValue != nil)
    {
        int v = abs((int)searchValue.integerValue - (int)userValue.integerValue);
            
        if (v <= 4)
        {
            return 14 - (.5 * v);
        }
        else if(4 < v < 10)
        {
            return 16 - v;
        }
        else
        {
            return 21 - (v * 1.5);
        }
    }
    
    else
    {
        return 0;
    }
}

+(int)equationForFifthFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue allMatter:(BOOL)value
{
    if (searchValue != nil)
    {
        int u = abs((int)searchValue.integerValue - (int)userValue.integerValue);
        
        if (u <= 4)
        {
            return 14 - (.5 * u);
        }
        else if(4 < u < 10)
        {
            return 16 - u;
        }
        else
        {
            return 21 - (u * 1.5);
        }
    }
    
    else
    {
        return 0;
    }
}

+(int)equationForSixthFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue allMatter:(BOOL)value
{
    
    if (searchValue != nil)
    {
        int z = abs((int)searchValue.integerValue - (int)userValue.integerValue);
        
        if (z <= 4)
        {
            return 14 - (.5 * z);
        }
        else if(4 < z < 10)
        {
            return 16 - z;
        }
        else
        {
            return 21 - (z * 1.5);
        }
    }
    
    else
    {
        return 0;
    }
}

@end