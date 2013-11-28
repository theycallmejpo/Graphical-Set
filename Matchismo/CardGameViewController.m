//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Juan Posadas on 9/27/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *matchingsLabel;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) NSMutableArray *attachments;
@property (strong, nonatomic) NSMutableArray *initialLenghts;
@property (nonatomic) BOOL isPiledUp;

@end

#define PILE_UP_SCALE 0.4
#define PILE_UP_LENGTH 3
#define ROTATION_DURATION 0.5
# define REDEAL_DURATION 1.0

@implementation CardGameViewController

- (Grid *)gameGrid
{
    if (!_gameGrid) {
        _gameGrid = [[Grid alloc] init];
    }
    return _gameGrid;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (NSMutableArray *)attachments
{
    if (!_attachments) _attachments = [[NSMutableArray alloc] init];
    return _attachments;
}

- (NSMutableArray *)initialLenghts
{
    if (!_initialLenghts) _initialLenghts = [[NSMutableArray alloc] init];
    return _initialLenghts;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

- (NSString *)firstLabel
{
    return @"Flip a Card!";
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self startingNumberOfCells]
                                                          usingDeck:[self createDeck]];
    return _game;
}

/* Initialization of deck of playing cards */
- (Deck *)playingDeck
{
    if (!_playingDeck) _playingDeck = [self createDeck];
    return _playingDeck;
}

- (Deck *)createDeck
{
    return nil;
}

#pragma mark - Abstract classes

- (void)updateCardView:(UIView *)cardView usingCard:(Card *)card animated:(BOOL)animated withDelayCounter: (NSUInteger)delayCounter{}
- (void)updateCardsUIWithTouchIndex:(NSUInteger)index {}
- (void)setMatchMode {}
- (UIView *)createCardView {return nil;}


- (void) removeAllViewsFromSuperView: (UIView *)view
{
    NSArray *subViews = [view subviews];
    for (UIView *toRemove in subViews) {
        [toRemove removeFromSuperview];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
//    NSLog(@"piled up: %d", self.isPiledUp);
    if (!self.isPiledUp) {
        
        
        CGPoint tapLocation = [gesture locationInView:self.gameView];
        UIView *view = [self.gameView hitTest:tapLocation withEvent:Nil];
    
        int chosenCardViewIndex = [self.cardViews indexOfObject:view];
    
        [self.game chooseCardAtIndex:chosenCardViewIndex];
        [self updateScore];
        [self updateCardsUIWithTouchIndex:chosenCardViewIndex];
    } else {
        
        NSArray *subviews = [self.gameView subviews];
        [UIView animateWithDuration:REDEAL_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             for (UIView *view in subviews) {
                                 int index = [subviews indexOfObject:view];
                                 
                                 int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
                                 int y = self.gameView.bounds.size.height * 1.5;
                                 
                                 view.center = CGPointMake(x, index >= ([subviews count] / 2) ? y : -y);
                                 
                             }
                         }
                         completion:^(BOOL finished) {
                             [self setUpGrid];
                             [self populateGrid];
                             self.isPiledUp = NO;
                             
                             [self.animator removeAllBehaviors];
                             

                         }];

            }
}

- (void)pan:(UIPanGestureRecognizer *)sender
{
    if (self.isPiledUp) {
        
        CGPoint gesturePoint = [sender locationInView:self.gameView];
        
        if (sender.state == UIGestureRecognizerStateChanged) {
            
            for (UIAttachmentBehavior *attch in self.attachments) {
                attch.anchorPoint = gesturePoint;
        
            }
        }
        
    }
}

- (void)updateScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

/* Restart Game function */


- (IBAction)restartGame
{
    self.game = nil;
    [self.initialLenghts removeAllObjects];
    [self.attachments removeAllObjects];
    
    NSArray *subviews = [self.gameView subviews];
    [UIView animateWithDuration:REDEAL_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         for (UIView *view in subviews) {
                             int index = [subviews indexOfObject:view];
                             
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height * 1.5;
                             
                             view.center = CGPointMake(x, index >= ([subviews count] / 2) ? y : -y);
                                 
                         }
                     }
                     completion:^(BOOL finished) {
                         [self recreateAndPopulateGrid];
                         [self setMatchMode];
                         [self updateScore];
                    }];
}

static const CGFloat CELL_WIDTH = 35.0;
static const CGFloat CELL_HEIGHT = 50.0;


- (void)setUpGrid
{
    self.gameGrid.size = CGSizeMake(self.gameView.bounds.size.width, self.gameView.bounds.size.height);
    self.gameGrid.cellAspectRatio = CELL_WIDTH / CELL_HEIGHT;
    self.gameGrid.minimumNumberOfCells = [self numberOfCellsForGrid];
}

- (NSUInteger)numberOfCellsForGrid
{

    if ([self.game returnNumberOfCardsInPLay] != 0) {
        return [self.game returnNumberOfCardsInPLay];
    }
    
    return self.startingNumberOfCells;
}

- (void)addViewToCardViews
{
    UIView *cardView = [self createCardView];
    cardView.opaque = NO;
    [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [cardView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    
    [self.gameView addSubview:cardView];
    [self.cardViews addObject:cardView];
    
}

- (void)populateCardViews
{
    for (int index = 0; index < [self.game returnNumberOfCards]; index++) {
        [self addViewToCardViews];
    }
}

- (void)populateGrid
{
    NSUInteger cols = self.gameGrid.columnCount;
    int frameIndex = 0;
    
    for (UIView *view in self.cardViews) {
        
        int index = [self.cardViews indexOfObject:view];
        
        Card *card = [self.game cardAtIndex:index];
        
        if (card && !card.isMatched) {
            NSUInteger row = frameIndex / cols;
            NSUInteger col = frameIndex % cols;
            
            CGRect frame = [self.gameGrid frameOfCellAtRow:row inColumn:col];
            view.frame = frame;
            frameIndex++;
        }
    }
}

- (void)recreateAndPopulateGrid
{
    [self removeAllViewsFromSuperView:self.gameView];
    [self.cardViews removeAllObjects];
    
    [self setUpGrid];
    [self populateCardViews];
    [self populateGrid];
    [self updateCardsUIWithTouchIndex:-1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpGrid];
    [self populateCardViews];
    [self populateGrid];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustViewsForOrientation)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self adjustViewsForOrientation];
}


- (void) adjustViewsForOrientation {
    
    NSArray *subviews = [self.gameView subviews];
    [UIView animateWithDuration:ROTATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         for (UIView *view in subviews) {
                             
                             int x = self.gameView.bounds.size.width / 2;
                             int y = self.gameView.bounds.size.height / 2;
                             
                             view.center = CGPointMake(x, y);
                         }
                     }
                     completion:^(BOOL finished) {
                         [self setUpGrid];
                         [self populateGrid];
                     }];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
    
    CGFloat scale = sender.scale;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint center = CGPointMake(self.gameView.bounds.size.width / 2, self.gameView.bounds.size.height / 2);
        [self attachViewsToPoint:center];
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        for (UIAttachmentBehavior *attch in self.attachments) {
            
            int index = [self.attachments indexOfObject:attch];
            CGFloat initialLength = [[self.initialLenghts objectAtIndex:index] floatValue];
        
            attch.length = initialLength * scale;
        }
            
    
    } else if (sender.state == UIGestureRecognizerStateEnded) {

        
        if (scale < PILE_UP_SCALE) {
            
            for (UIAttachmentBehavior *attch in self.attachments) {
                attch.length = PILE_UP_LENGTH;
            }
            self.isPiledUp = YES;
            
        } else {
            
            for (UIAttachmentBehavior *attch in self.attachments) {
                int index = [self.attachments indexOfObject:attch];
                CGFloat initialLength = [[self.initialLenghts objectAtIndex:index] floatValue];
                attch.length = initialLength;
            }
        }
        
    }

}

- (void)attachViewsToPoint: (CGPoint)anchorPoint
{
    
    for (UIView *view in [self.gameView subviews]) {
        if (view) {
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToAnchor:anchorPoint];
        
            [self.attachments addObject:attachment];
            [self.animator addBehavior:attachment];
            
            [self.initialLenghts addObject:[NSNumber numberWithFloat:attachment.length]];
        }
    }

}






@end














