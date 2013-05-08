//
//  MainMenuScene.m
//  Hunt4Time
//
//  Created by David on 2013-05-03.
//  Copyright (c) 2013 David. All rights reserved.
//

#import "MainMenuScene.h"
#import "WorldOneTutorialLayer.h"

@implementation MainMenuScene


// Scener kan innehålla många olika lager, man fäster "layer" i en "scene" men allt innehåll så som
// text,knappar, bilder, osv  är i "layer"
+(CCScene *) scene {
    
    // Skapar en scene som kommer innehålla all "main menu" innehåll
    CCScene *scene = [CCScene node];
    // Skapar ett layer som kommer innehålla all text,bilder,knappar, osv.
    MainMenuScene *layer = [MainMenuScene node];
    
    [scene addChild: layer];
    
    return scene;
}

// allt man vill ska hända när scenen laddar ( tex lägger in: knappar,bilder osv)
-(id) init
{
    if ((self=[super init])) {
        
    
        [self setUpMenus];
        
        
    }
    return self;
    
}

// Metoden för alla menyitems
- (void)setUpMenus{
    
    //Skapar ett menu Item (@selector(playMenuButtonPressed: kallar på min metod "playMenuButtonPressed")
    CCMenuItem *menuPlay = [CCMenuItemImage itemWithNormalImage:@"Play.png" selectedImage:@"Play.png" target:self selector:@selector(playMenuButtonPressed:)];
    
    
    // lägger till menuitem i min Menu
    CCMenu *MainMenu = [CCMenu menuWithItems:menuPlay, nil];
    
    [MainMenu alignItemsVertically];
    

    [self addChild:MainMenu];
    
}

// Metod som skickar mig vidare till worldOneTutorialLayer
- (void) playMenuButtonPressed: (CCMenuItem *) menuItem{
    NSLog(@"Du tryckte på Play Menuitem");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[WorldOneTutorialLayer scene] ]];
    
}


@end
