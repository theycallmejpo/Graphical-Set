//
//  SetCardView.h
//  Graphical -Set
//
//  Created by Juan Posadas on 10/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;
@property (nonatomic) CGPoint center;

@property (nonatomic) BOOL selected;

@end
