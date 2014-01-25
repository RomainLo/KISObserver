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

@protocol KISObservation;

/** Retain and handle a list of observations. */
@interface KISObservationHandler : NSObject

/** The array of handled observations. */
@property (nonatomic, readonly, copy) NSArray *observations;

/**
 Add an observation to the end of the 'observations' array.
 @param observation The observation to add and handle.
 @exception Parameter can't be nil.
 */
- (void)addObservation:(id<KISObservation>)observation; // id<KISObservation> for orthogonality.

/**
 Remove an observation related to an object for given keypaths.
 @param object The observable object of the notification to remove.
 @param keyPaths The keypath of the notification to remove.
 @exception Parameters can't be nil.
 */
- (void)removeObservationOfObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths;

/** Remove all observation. */
- (void)removeAllObservations;

/**
 Say YES if it contains an observation on a object for given keypaths.
 @param object The observable object of the notification to find.
 @param keyPaths The keyPaths of the notification to find.
 */
- (BOOL)isObservingObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths;

@end
