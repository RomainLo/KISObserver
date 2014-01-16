// Copyright (c) 2013 RomainLo <romain.lofaso@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

extern NSString * const kKISObservationContext;

@protocol KISObservation <NSObject>

/** The object which observes. */
@property (nonatomic, weak, readonly) id observer;

/** The object which is observed. */
@property (nonatomic, weak, readonly) id observed;

/** The option of the observation. */
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;

/** The list of observed key paths. */
@property (nonatomic, copy, readonly) NSString *keyPaths;

/** The list of observed key paths. */
@property (nonatomic, copy, readonly) NSArray *keyPathArray;

@end

/** Abstract class that hanble the common business logic of a KISObservation. */
@interface KISObservationBase : NSObject <KISObservation>

@property (nonatomic, weak, readonly) id observer;
@property (nonatomic, weak, readonly) id observed;
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;
@property (nonatomic, copy, readonly) NSString *keyPaths;
@property (nonatomic, copy, readonly) NSArray *keyPathArray;

- (instancetype)initWithObserver:(id)observer
								observed:(id)observed
								 options:(NSKeyValueObservingOptions)options
								keyPaths:(NSString *)keyPaths;

- (void)startObservation;

@end
