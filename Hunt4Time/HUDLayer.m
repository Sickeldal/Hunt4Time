//
//  HUDLayer.m
//  Hunt4Time
//
//  Created by admin on 4/24/13.
//  Copyright 2013 David. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer


-(id) init
{
    if( (self=[super initWithColor:ccc4(255,255,0,128)])) {
        self.position=ccp(0,280);
        self.contentSize=CGSizeMake(480,40);
        
        
    }
    return self;
}

- (void) dealloc
{    
}



@end
