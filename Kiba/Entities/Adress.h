//
//  Adress.h
//  Kiba
//
//  Created by 1jendryc on 21.11.13.
//  Copyright (c) 2013 KiBa App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Adress : NSObject

@property NSString* street;
@property NSString* housenr;

// Fachwert?
@property int postalcode;

// Fachwert!
@property NSString* city;


@end