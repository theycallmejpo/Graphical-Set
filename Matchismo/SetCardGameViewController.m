//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Juan Posadas on 10/13/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@property (nonatomic, strong) NSMutableArray *freeFrames;
@property (nonatomic) BOOL areCardsRequested;

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSMutableArray *)freeFrames
{
    if (!_freeFrames) _freeFrames = [[NSMutableArray alloc] init];
    return _freeFrames;
}

#define NUM_CARDS 12
- (NSUInteger)startingNumberOfCells
{
    return NUM_CARDS;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setMatchMode];
    [self updateCardsUIWithTouchIndex:-1];
}

- (void) setMatchMode
{
    self.game.gameMode = 3;
}

- (UIView *)createCardView
{
    return [[SetCardView alloc] init];
}

#define OFF_TO_ONSCREEN_DURATION 1
#define OFF_TO_ONSCREEN_DELAY 0.2

- (void)updateCardView:(UIView *)cardView usingCard:(Card *)card animated:(BOOL)animated withDelayCounter: (NSUInteger)delayCounter
{
    if ([cardView isKindOfClass:[SetCardView class]]) {
        SetCardView *setCardView = (SetCardView *)cardView;
        if ([card isKindOfClass:[SetCard class]]) {
            if (!card.isMatched) {
//                [setCardView removeFromSuperview];
//            } else {
                SetCard *setCard = (SetCard *)card;
                setCardView.number = setCard.number;
                setCardView.symbol = setCard.symbol;
                setCardView.shading = setCard.shading;
                setCardView.color = setCard.color;
                setCardView.selected = setCard.isChosen;
            }
            
            if (animated) {
                CGRect dFrame = cardView.frame;
                setCardView.frame = CGRectMake(dFrame.origin.x, dFrame.origin.y - self.gameView.bounds.size.height, dFrame.size.width, dFrame.size.height);
                [UIView animateWithDuration:OFF_TO_ONSCREEN_DURATION
                                      delay:OFF_TO_ONSCREEN_DELAY * delayCounter
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     cardView.frame = dFrame;
                                 }
                                 completion:nil];
            }

        }
    }
}

- (void)updateCardsUIWithTouchIndex:(NSUInteger)index
{
    NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
    NSUInteger delayCounter = -1;
    for (UIView *cardView in self.cardViews) {
        int cardViewIndex = [self.cardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        BOOL isAnimated = NO;
        
        if (self.areCardsRequested && cardViewIndex >= ([self.cardViews count] - 3)) { // -3 for last three cards
            
            isAnimated = YES;
            delayCounter++;
        }
        
        if (card.isMatched) {
            
            if (![matchedCards containsObject:cardView]) {
                [matchedCards addObject:cardView];
//                [cardView removeFromSuperview];
            }
            
            
        }
        [self updateCardView: cardView usingCard: card animated: isAnimated withDelayCounter: delayCounter];
    }
    
    if (self.game.justMatched) {
        [self adjustCardsToGridWithMatchedCards:matchedCards];
    }
    
    self.areCardsRequested = NO;
}

#define ON_TO_OFFSCREEN_DURATION 1.5

- (void)adjustCardsToGridWithMatchedCards: (NSMutableArray *)matchedCards
{
    
        
        [UIView animateWithDuration:ON_TO_OFFSCREEN_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             for (SetCardView *view in matchedCards) {
                                 view.selected = YES;
                                 CGRect oFrame = view.frame;
                                 CGRect dFrame = CGRectMake(oFrame.origin.x, oFrame.origin.y + self.gameView.bounds.size.height , oFrame.size.width, oFrame.size.height);
                                 view.frame = dFrame;
                             }
                         }
                         completion:^(BOOL finished) {
                             for (UIView *view in matchedCards) {
                                 [view removeFromSuperview];
                             }
                             [self setUpGrid];
                             [self populateGrid];
                         }];
        
        
  
    
    
//    [self setUpGrid];
//    [self populateGrid];
}

- (IBAction)addThreeCards:(UIButton *)sender {
    
    BOOL enoughCards = [self.game addThreeCardsFromDeck];
    
    if (enoughCards) {
        self.areCardsRequested = YES;
        [self recreateAndPopulateGrid];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Abuse Repoted"
                                                        message:@"You have abused the +3 cards button. No more cards left in deck!"
                                                       delegate:nil
                                              cancelButtonTitle:@"I'll be careful"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}


@end
