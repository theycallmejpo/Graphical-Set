//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Juan Posadas on 9/30/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score; //redeclare from interface
@property (nonatomic, readwrite) NSInteger matchScore;
@property (nonatomic) Deck *deck;
@property (nonatomic, strong) NSMutableArray *cards; //elements of class Card


@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)playingCards
{
    if (!_playingCards) _playingCards = [[NSMutableArray alloc] init];
    return _playingCards;
}

- (NSMutableArray *)flippedCards
{
    if (!_flippedCards) _flippedCards = [[NSMutableArray alloc] init];
    return _flippedCards;
}

- (NSMutableArray *)flippedCardsIndeces
{
    if (!_flippedCardsIndeces) _flippedCardsIndeces = [[NSMutableArray alloc] init];
    return _flippedCardsIndeces;
}

static const int DEFAULT_MODE = 2;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
                [self.playingCards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        
        self.gameMode = DEFAULT_MODE;
        self.justMatched = NO;
        self.matchScore = 0;
        self.deck = deck;
    }
    
    return self;
}

- (NSUInteger)returnNumberOfCardsInPLay
{
    return [self.playingCards count];
}

- (NSUInteger)returnNumberOfCards
{
    return [self.cards count];
}

- (BOOL)addThreeCardsFromDeck;
{
    for (int i = 0; i < 3; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
            [self.playingCards addObject:card];
        } else {
            return NO;
        }\
    }
    
    return YES;
}

static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    //Remove all objects if there has just been a match
    if (self.justMatched) {
        [self.flippedCards removeAllObjects];
        [self.flippedCardsIndeces removeAllObjects];
    } else if (self.justMismatched) {
        [self.flippedCards removeObjectsInRange:NSMakeRange(0, [self.flippedCards count] - 1)];
        [self.flippedCardsIndeces removeObjectsInRange:NSMakeRange(0, [self.flippedCardsIndeces count] - 1)];
    }
    
    self.justMatched = NO;
    self.justMismatched = NO;
    self.matchScore = 0;
    
    if (!card.isMatched) {
        
        if (card.isChosen) {
            
            card.chosen = NO;
            [self.flippedCards removeObject:card];
            [self.flippedCardsIndeces removeObject:@(index)];
            
        } else if([self.flippedCards count] == self.gameMode - 1){
            
            int matchScore = [card match:self.flippedCards];
            
            if (matchScore) {
                self.score += matchScore;
                card.matched = YES;
                [self.playingCards removeObject:card];
                for(Card *otherCard in self.flippedCards) {
                    otherCard.matched = YES;
                    [self.playingCards removeObject:otherCard];
                }
                [self.flippedCards addObject:card];
                [self.flippedCardsIndeces addObject:@(index)];
                self.justMatched = YES;
                self.matchScore = matchScore;
            } else {
                self.score -= MISMATCH_PENALTY;
                for(Card *otherCard in self.flippedCards) {
                    otherCard.matched = NO;
                    otherCard.chosen = NO;
                }
                
                [self.flippedCards addObject:card];
                [self.flippedCardsIndeces addObject:@(index)];
                self.justMismatched = YES;
                self.matchScore = MISMATCH_PENALTY;
                
            }
            
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
            
        } else {
            
            if(!card.chosen) {
                [self.flippedCards addObject:card];
                [self.flippedCardsIndeces addObject:@(index)];
            }
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
        
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (Card *)playingCardAtIndex:(NSUInteger) index {
    return (index < [self.playingCards count] ? self.playingCards[index] : nil);
}

- (instancetype)init
{
    return nil;
}

@end
