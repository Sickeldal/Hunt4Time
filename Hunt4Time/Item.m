//
//  Items.m
//  Hunt4Time
//
//  Created by admin on 5/16/13.
//  Copyright 2013 David. All rights reserved.
//

#import "Item.h"


@implementation Item{
    
    
}

-(void)initMushroom{
    
    
    self.mushroom = [self.tileMap layerNamed:@"Mushroom"];
    self.specialTile = [self.tileMap layerNamed:@"SpecialTiles"];
    
}


@end
