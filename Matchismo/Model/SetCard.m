//
//  SetCard.m
//  Matchismo
//
//  Created by Juan Posadas on 10/13/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

static const int SET_SCORE = 7;
static const int SET_MATCH_BONUS = 3;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    NSMutableArray *cards = [NSMutableArray arrayWithArray:otherCards];
    [cards addObject:self];
    
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    NSMutableArray *symbols = [[NSMutableArray alloc] init];
    NSMutableArray *shadings = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (SetCard *card in cards) {
        if (![numbers containsObject:@(card.number)]) [numbers addObject:@(card.number)];
        if (![symbols containsObject:@(card.symbol)]) [symbols addObject:@(card.symbol)];
        if (![shadings containsObject:@(card.shading)]) [shadings addObject:@(card.shading)];
        if (![colors containsObject:@(card.color)]) [colors addObject:@(card.color)];
    }
    
    if ([numbers count] == 1 || [numbers count] == 3) {
        if ([symbols count] == 1 || [symbols count] == 3) {
            if ([shadings count] == 1 || [shadings count] == 3) {
                if ([colors count] == 1 || [colors count] == 3) {
                    score += SET_SCORE * SET_MATCH_BONUS;
                    
                }
            }
        }
    }
    
    return score;
}

- (NSString *)contents
{
    return @"";
}

+ (NSArray *)validNumbers
{
    return @[@0, @1, @2, @3];
}

//+ (NSArray *)validSymbols
//{
//    return @[@"▲", @"■", @"●"];
//}

+ (NSArray *)validSymbols
{
    return @[@0, @1, @2, @3];
}

+ (NSArray *)validShadings
{
    return @[@0, @1, @2, @3];
}

+ (NSArray *)validColors
{
    return @[@0, @1, @2, @3];
}

+ (NSUInteger)maxNumber
{
    return [[self validNumbers] count] - 1;
}

+ (NSUInteger)maxSymbol
{
    return [[self validSymbols] count] - 1;
}

+ (NSUInteger)maxShading
{
    return [[self validShadings] count] - 1;
}

+ (NSUInteger)maxColor
{
    return [[self validColors] count] - 1;
}



@end
