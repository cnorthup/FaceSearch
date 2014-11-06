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

@property FFUser* searchFace;

@end

@implementation Rate

+(NSArray*)rateUsers:(NSArray*)users searchFace:(FFUser*)searchFace;
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

+(double)rateEquation:(FFUser*)user searchFace:(FFUser*)search
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


#pragma --mark Decay Rate

+(double)decayEquation:(FFUser*)search :(FFUser*)otherUser
{
    int r = 0;
    double z = 0.0;
    for (NSNumber* value in search.featuresValue)
    {
        int x = abs(value.intValue - (int)[otherUser.featuresValue objectAtIndex:r]);
        z += 14 * exp((-x) * 0.3);
        r++;
    }
   // int x = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    //this is the equation
    //             -(x * 0.3
    //  y = 14 * e^
    //return 14 * exp((-x) * 0.3);
    return z;
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

#pragma --mark Orginal equation

/**
 
+(int)equationForFirstFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue
{
    int x = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    if (x <= 2)
    {
        return x-2;
    }
    else if(2 < x <= 4)
    {
        return x;
    }
    else
    {
        return x + 3;
    }
}

+(int)equationForSecondFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue
{
    int y = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    if (y <= 2)
    {
        return y-2;
    }
    else if(2 < y <= 4)
    {
        return y;
    }
    else
    {
        return y + 3;
    }
}

+(int)equationForThirdFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue allMatter:(BOOL)value
{
    int w = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    //normal values
    int k = 3;
    int l = 5;
    
    //smaller values for when not all features matter
    int g = 2;
    int h = 4;
    
    if (value == YES)
    {
        if (w <= k)
        {
            return w - k;
        }
        else if(k < w <= l)
        {
            return w;
        }
        else
        {
            return w + k;
        }
    }
    else
    {
        
        if (w <= g)
        {
            return w - g;
        }
        else if(g < w <= h)
        {
            return w;
        }
        else
        {
            return w + g;
        }
    }
}

+(int)equationForFourthFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue allMatter:(BOOL)value

{
    if (searchValue != nil)
    {
        int v = abs((int)searchValue.integerValue - (int)userValue.integerValue);
        
        //normal values
        int k = 3;
        int l = 5;
        
        //smaller values for when not all features matter
        int g = 2;
        int h = 4;
        
        
        
        if (value == YES)
        {
            if (v <= k)
            {
                return v - k;
            }
            else if(k < v <= l)
            {
                return v;
            }
            else
            {
                return v + k;
            }
        }
        else
        {
            
            if (v <= g)
            {
                return v - g;
            }
            else if(g < v <= h)
            {
                return v;
            }
            else
            {
                return v + g;
            }
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
        
        //normal values
        int k = 4;
        int l = 6;
        
        //smaller values for when not all features matter
        int g = 3;
        int h = 5;
        
        
        
        if (value == YES)
        {
            if (u <= k)
            {
                return u - k;
            }
            else if(k < u <= l)
            {
                return u;
            }
            else
            {
                return u + k;
            }
        }
        else
        {
            
            if (u <= g)
            {
                return u - g;
            }
            else if(g < u <= h)
            {
                return u;
            }
            else
            {
                return u + g;
            }
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
        
        //normal values
        int k = 4;
        int l = 6;
        
        //smaller values for when not all features matter
        int g = 3;
        int h = 5;
        
        if (value == YES)
        {
            if (z <= k)
            {
                return z - k;
            }
            else if(k < z <= l)
            {
                return z;
            }
            else
            {
                return z + k;
            }
        }
        else
        {
            
            if (z <= g)
            {
                return z - g;
            }
            else if(g < z <= h)
            {
                return z;
            }
            else
            {
                return z + g;
            }
        }
    }
    
    else
    {
        return 0;
    }
}
 
**/


@end