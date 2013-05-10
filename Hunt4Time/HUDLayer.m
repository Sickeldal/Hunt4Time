//
//  HUDLayer.m
//  Hunt4Time
//
//  Created by admin on 4/24/13.
//  Copyright 2013 David. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer
//synthesize mina lives
@synthesize lives;


-(id) init
{
    //Skapar min huddisplay
    //Färgen på huden
    if( (self=[super initWithColor:ccc4(255,255,0,0)])) {
        //position på huden
        self.position=ccp(0,280);
        //längd och bredd på huden
        self.contentSize=CGSizeMake(480,40);
        
        //Skapar min "0" och anger storlkek på texten
        scoreLabel=[CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:24];
        
        //Position på min "0" alltså positionen på min counter
        scoreLabel.position=ccp(62,20);
        scoreLabel.anchorPoint=ccp(0,0.5);
        [self addChild:scoreLabel];
        
        //Skapar min "Score" och anger storleken på texten
        CCLabelTTF *scoreText = [CCLabelTTF labelWithString:@"Score:" fontName:@"Marker Felt" fontSize:24];
        
        //Position på min "Score" label
        scoreText.position=ccp(5,20);
        scoreText.anchorPoint=ccp(0,0.5);
        [self addChild:scoreText];
        
        //Ska försöka få detta att fungera, mina lives ska ha en hjärtsymbol.
        //Fungerar inte ännu
        lives = [NSMutableArray arrayWithCapacity:3];
        
        for(int i=0;i<3;i++)
        {
            CCSprite * life = [CCSprite spriteWithFile:@"Life-bar.png"];
            // Tänk på setPosition
            [life setPosition:ccp(180,20)];
            [self addChild:life];
            [lives addObject:life];
        }
        
        //[life setPosition:ccp(18+ 28*i,465)];
        
        
        
    }
    return self;
}

-(void)addToScore:(int)number
{
    score=score+number;
    [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
}


- (void) dealloc
{    
}



@end
