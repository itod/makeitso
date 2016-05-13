//
//  MakeItSoTests.h
//  MakeItSo
//
//  Created by Todd Ditchendorf on 12/25/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#define TDTrue(e) XCTAssertTrue((e), @"")
#define TDFalse(e) XCTAssertFalse((e), @"")
#define TDNil(e) XCTAssertNil((e), @"")
#define TDNotNil(e) XCTAssertNotNil((e), @"")
#define TDEquals(e1, e2) XCTAssertEqual((e1), (e2), @"")
//#define TDEqualsWithAccuracy(e1, e2, acc) XCTAssertEqualWithAccuracy((e1), (e2), (acc), @"")
#define TDEqualObjects(e1, e2) XCTAssertEqualObjects((e1), (e2), @"")

#define ACC 0.00001

#define VERIFY()     @try { [_mock verify]; } @catch (NSException *ex) { NSString *msg = [ex reason]; XCTAssertTrue(0, @"%@", msg); }
