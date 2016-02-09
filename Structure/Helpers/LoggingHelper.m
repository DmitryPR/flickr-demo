//
//  LoggingHelper.m
//  Flickr
//
//  Created by Dmitry Preobrazhenskiy on 08/02/16.
//  Copyright © 2016 Dmitry Preobrazhenskiy. All rights reserved.
//

#import "LoggingHelper.h"

@interface LoggingHelper ()
@property(nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation LoggingHelper

#pragma mark - Initialisation

- (instancetype)init {
    self = [super init];
    if(self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        self.formatter = formatter;
    }

    return self;
}

#pragma mark - Public methods

#pragma mark - Private methods

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    :
            logLevel = @"e:";
            break;
        case DDLogFlagWarning  :
            logLevel = @"w:";
            break;
        case DDLogFlagInfo     :
            logLevel = @"i:";
            break;
        case DDLogFlagDebug    :
            logLevel = @"d:";
            break;
        default                :
            logLevel = @"v:";
            break;
    }

    return [NSString stringWithFormat:@"<%@> %@ %@(%lu)\n%@", [self.formatter stringFromDate:logMessage->_timestamp], logLevel, logMessage->_function, logMessage->_line, logMessage->_message];
}

#pragma mark - System Stuff

@end
