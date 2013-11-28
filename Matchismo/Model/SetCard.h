//
//  SetCard.h
//  Matchismo
//
//  Created by Juan Posadas on 10/13/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

+ (NSUInteger) maxNumber;
+ (NSUInteger) maxSymbol;
+ (NSUInteger) maxShading;
+ (NSUInteger) maxColor;

@end
