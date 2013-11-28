//
//  PlayingCard.m
//  Matchismo
//
//  Created by Juan Posadas on 9/28/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

static const int SUIT_MATCH = 1;
static const int RANK_MATCH = 4;
static const int TWO_MATCH_BONUS = 4;
static const int THREE_MATCH_BONUS = 8;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    NSMutableArray *cards = [NSMutableArray arrayWithArray:otherCards];
    [cards addObject:self];
    
    NSMutableArray *suits = [[NSMutableArray alloc] init];
    NSMutableArray *ranks = [[NSMutableArray alloc] init];
    
    for(PlayingCard *card in cards) {
        if(![suits containsObject:card.suit]) [suits addObject:card.suit];
        
        NSNumber *rank = [NSNumber numberWithInt:card.rank];
        if(![ranks containsObject:rank]) [ranks addObject:rank]; //adding NSUInteger to NSMutableArray
    }
    
    NSInteger cardsLength = [cards count];
    
    if ([ranks count] == 1) {
        score = (cardsLength == 3) ? RANK_MATCH * THREE_MATCH_BONUS : RANK_MATCH * TWO_MATCH_BONUS;
    } else if ([suits count] == 1) {
        score = (cardsLength == 3) ? SUIT_MATCH * THREE_MATCH_BONUS : SUIT_MATCH * TWO_MATCH_BONUS;
    } else if (cardsLength == 3) {
        
        if ([ranks count] == 2) {
            score += RANK_MATCH * TWO_MATCH_BONUS;
        }
        if ([suits count] == 2) {
            score += SUIT_MATCH * TWO_MATCH_BONUS;
        }
        
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
