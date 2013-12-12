//
//  Customer.h
//  Kiba
//
//  Created by 1jendryc on 21.11.13.
//  Copyright (c) 2013 KiBa App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Address.h"
#import "CreditRating.h"


@interface Customer : User
-(id)initWithForeName: (NSString*) forename
             surname: (NSString*) surname
             customerId: (int) customerId
             pass: (NSString*) pass
             ident: (NSString*) ident
             adress: (Address*) address
             accounts: (NSMapTable*) accounts
             creditRating: (CreditRating*) creditRating;

// Perso Ident Einloggkennung!
@property NSString *ident;
@property Address *address;
@property NSMapTable *accounts;
@property CreditRating *creditRating;
@property Boolean verificated;

@end
