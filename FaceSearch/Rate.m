//
//  Rate.m
//  FaceSearch
//
//  Created by Charles Northup on 10/15/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "Rate.h"
#import "FFUser.h"

@interface Rate ()

@property FFUser* searchFace;

@end

@implementation Rate

+(NSArray*)rateUsers:(NSArray*)users searchFace:(FFUser*)searchFace;
{
    for (FFUser* user in users)
    {
            user.score = [NSNumber numberWithInt:[Rate rateEquation:user searchFace:searchFace]];
    }
    NSArray* array = [users sortedArrayUsingComparator:^NSComparisonResult(FFUser* obj1, FFUser* obj2) {
        if (obj1.score > obj2.score) {
            return NSOrderedDescending;
        }
        else if (obj1.score < obj2.score) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    return array;
}

+(int)rateEquation:(FFUser*)user searchFace:(FFUser*)search
{
    int calculatedValue = 0;
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

#pragma --mark Equation my dad recommeneded

+(int)equationForFirstFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue
{
    int x = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    if (x <= 2)
    {
        return x + 2;
    }
    else if(2 < x <= 4)
    {
        return x;
    }
    else
    {
        return x - 2;
    }
}

+(int)equationForSecondFeature:(NSNumber*)searchValue userValue:(NSNumber*)userValue
{
    int y = abs((int)searchValue.integerValue - (int)userValue.integerValue);
    
    if (y <= 2)
    {
        return y + 2;
    }
    else if(2 < y <= 4)
    {
        return y;
    }
    else
    {
        return y - 2;
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
            return w + k;
        }
        else if(k < w <= l)
        {
            return w;
        }
        else
        {
            return w - k;
        }
    }
    else
    {
        
        if (w <= g)
        {
            return w + g;
        }
        else if(g < w <= h)
        {
            return w;
        }
        else
        {
            return w - g;
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
                return v + k;
            }
            else if(k < v <= l)
            {
                return v;
            }
            else
            {
                return v - k;
            }
        }
        else
        {
            
            if (v <= g)
            {
                return v + g;
            }
            else if(g < v <= h)
            {
                return v;
            }
            else
            {
                return v - g;
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
                return u + k;
            }
            else if(k < u <= l)
            {
                return u;
            }
            else
            {
                return u - k;
            }
        }
        else
        {
            
            if (u <= g)
            {
                return u + g;
            }
            else if(g < u <= h)
            {
                return u;
            }
            else
            {
                return u - g;
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
                return z + k;
            }
            else if(k < z <= l)
            {
                return z;
            }
            else
            {
                return z - k;
            }
        }
        else
        {
            
            if (z <= g)
            {
                return z + g;
            }
            else if(g < z <= h)
            {
                return z;
            }
            else
            {
                return z - g;
            }
        }
    }
    
    else
    {
        return 0;
    }
}



@end