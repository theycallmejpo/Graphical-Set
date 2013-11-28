//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Juan Posadas on 10/9/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

#define NUM_CARDS 20
- (NSUInteger)startingNumberOfCells
{
    return NUM_CARDS;
}

- (void) setMatchMode
{
    self.game.gameMode = 2;
}

- (UIView *)createCardView
{
    return [[PlayingCardView alloc] init];
}

#define MATCHED_ALPHA 0.4
#define FLIP_ANIMATION_TIME 0.4

- (void) updateCardView:(UIView *)cardView usingCard:(Card *)card animated:(BOOL)animated withDelayCounter: (NSUInteger)delayCounter
{
    if ([cardView isKindOfClass:[PlayingCardView class]]) {
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.chosen;
            playingCardView.alpha = playingCard.isMatched ? MATCHED_ALPHA : 1.0;
            
            if (animated && !playingCard.matched) {
                [UIView transitionWithView:playingCardView
                                  duration:FLIP_ANIMATION_TIME
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:NULL
                                completion:NULL];
            }
        }
    }
}

- (void)updateCardsUIWithTouchIndex:(NSUInteger)index
{
    
    for (UIView *cardView in self.cardViews) {
        
        int cardViewIndex = [self.cardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        
        [self updateCardView: cardView usingCard: card animated: (cardViewIndex == index) ? YES : NO withDelayCounter:0];
    }
}
     



@end
