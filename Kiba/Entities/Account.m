//
//  Account.m
//  Kiba
//
//  Created by 1jendryc on 21.11.13.
//  Copyright (c) 2013 KiBa App. All rights reserved.
//

#import "Account.h"


@implementation Account

-(id)initWithBalance: (NSNumber*) newBalance overDraft: (NSNumber*) newOverDraft accountNr: (NSNumber*) newAccountNr owner: (Customer*) newOwner {
    
    if (self = [super init]) {
        self.balance = newBalance;
        self.overDraft = newOverDraft;
        self.accountNr = newAccountNr;
        self.owner = newOwner;
    }
    return self;
}

/**
 *  Verschickt Geld
 *
 *  @param amount Die Höhe des Betrags.
 */
-(void)sendMoney:(NSNumber *)amount {
    self.balance = [self.balance initWithLong:[self.balance longValue] - [amount longValue]];
}



@end
