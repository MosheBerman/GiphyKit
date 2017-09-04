//
//  UIImage+GIF.swift
//  GIFSearch
//
//  Created by Moshe Berman on 9/1/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation
import ImageIO

//  This extension of UIImageView enables us
//  to display a GIF that's supplied as raw NSData.
//
//  It uses ImageIO to load the GIF frames out and compute the animation duration.
//
public extension UIImage
{
    /// Creates an animated gif from a Data object.
    ///
    /// - Parameter data: The data.
    /// - Returns: A GIF as an animated UIImage instance.
    public class func gif(from data: Data) -> UIImage?
    {
        // NOTE: This method could have been done a few ways -
        // The durations and frames would be more efficiently 
        // extracted in a single loop, and might impact runtime
        // for large GIF sequences.
        //
        //  However, I wasn't sure when I first started coding this
        //  if it was safe to use tuples, because I wasn't sure how
        //  this API would interop with Objective-C.
        //
        //  Also, in terms of Big-O (or Theta) the runtime is considered
        //  to be the same. (i.e. O(2 * frameCount) is the same as O(frameCount)
        //  so I'm ignoring this for now.
        //
        //  As I work this part through, it's become a little more
        //  obvious to me that the "right" way to do this would be 
        //  to have a single method that iterates on the GIF data
        //  rather than one for durations and one for frames.
        //
        //  The counterarguments I'm seeing for keeping them seperate:
        //
        //  - It feels slightly wrong to me to pass in an array of tuples
        //    to `animationDuration(with:)` method, when we don't care for
        //    the frames themselves.
        //  - I don't know if ImageIO would ever return a different
        //    number of frames and durations, in which case, how do the
        //    tuples behave?
        //  - We get slightly clearer error logging in case one of them
        //    fails independently of the other. Again, I'm not sure if
        //    this is even possible, but it's a consideration.
        //
        //  I began changing the code to use a single array of tuples but
        //  you end up with the same question in reverse. "Should this be 
        //  two seperate arrays instead of a tuple?"
        //
        //  It comes down to how many iterations do we need to do in order
        //  that the method signatures are clear and that we aren't passing
        //  around extra data. (For example, passing the UIImages into the 
        //  animation duration calculation methods. They only need durations.)
        //
        //  I think the tradeoffs of having an extra couple of lines of
        //  code at the callsite are worth not having to unzip the tuple 
        //  tuple in a couple of places in order to maintain clarity.
        //
        //  UPDATE: It turns out that it's possible to have different array 
        //  lengths, although I'm not sure why. (Try searching for "St..." 
        //  and watch it crash. In the debugger you might be able to get more
        //  context, but since this isn't production, I'm not going to spend
        //  any more time on that. I've added a fix to prevent a crash, but 
        //  GIFs might skip some frames now.
        
        guard let durations = self.animationDurations(from: data) else
        {
            print("Failed to read the frame durations out from the data.")
            return nil
        }
        
        guard let rawFrames = self.frames(from: data) else
        {
            print("Failed to read the images out from the data.")
            return nil
        }
        
        let duration = self.animationDuration(with: durations)
        
        let frames = self.framesAccountingForPerFrameDuration(with: rawFrames, and: durations)
        
        let gif:UIImage? = UIImage.animatedImage(with: frames, duration: duration)
        
        return gif
    }
    
    // MARK: - Reading Raw GIF Data from the Data Object
    
    /// This method returns an array of GIF frames, each frame a unique object.
    ///
    /// - Parameter data: The image data.
    /// - Returns: An array of UIImage objects. If ImageIO fails to parse the image, returns `nil`.
    private class func frames(from data:Data) -> [UIImage]?
    {
        var frames: [UIImage] = []
        
        let imageData = data as CFData
        let imageSourceOption: NSDictionary =  [kCGImageSourceCreateThumbnailFromImageIfAbsent: true]
        
        guard let source = CGImageSourceCreateWithData(imageData, (imageSourceOption as CFDictionary)) else
        {
            print("Failed to load frames from data. Could not create image source.")
            return nil
        }
        
        let frameCount = CGImageSourceGetCount(source)
        
        for frameIndex in 0..<frameCount
        {
            guard let coreGraphicsImage = CGImageSourceCreateImageAtIndex(source, frameIndex, nil) else
            {
                print("Failed to load frame at index \(frameIndex)")
                continue
            }
            
            let frame = UIImage(cgImage: coreGraphicsImage)
            frames.append(frame)
        }
        
        return frames
    }
    
    /// Returns the animation durations from the GIF data.
    ///
    /// - Parameter data: The GIF, encoded as NSData.
    /// - Returns: An array of durations corresponding to each frame in the animation. `nil` if ImageIO can't process the data.
    private class func animationDurations(from data: Data) -> [Int]?
    {
        var intervals: [Int] = []
        
        let imageData = data as CFData
        let imageSourceOption: NSDictionary =  [kCGImageSourceCreateThumbnailFromImageIfAbsent: true]
        
        guard let source = CGImageSourceCreateWithData(imageData, (imageSourceOption as CFDictionary)) else
        {
            print("Failed to load frames from data. Could not create image source.")
            return nil
        }
        
        let frameCount = CGImageSourceGetCount(source)
        
        for frameIndex in 0..<frameCount
        {
            if let properties: NSDictionary = CGImageSourceCopyPropertiesAtIndex(source, frameIndex, nil)
            {
                let key = String(kCGImagePropertyGIFDictionary)
                if let GIFProperties: NSDictionary = (properties as? Dictionary<String, AnyObject>)?[key] as? NSDictionary
                {
                    var seconds: NSNumber? = nil
                    
                    if let duration = GIFProperties[kCGImagePropertyGIFUnclampedDelayTime] as? NSNumber
                    {
                        seconds = duration
                    }
                    else if let clampedDuration = GIFProperties[kCGImagePropertyGIFDelayTime] as? NSNumber
                    {
                        seconds = clampedDuration
                    }
                    
                    if let seconds = seconds, seconds.doubleValue > 0.0
                    {
                        let centiseconds = seconds.doubleValue * 100.0
                        intervals.append(Int(centiseconds))
                    }
                }
            }
        }
        
        return intervals
    }
    
    // MARK: - Computing the Animation Duration
    
    /// Calculates the number of centiseconds that cleanly divides all of the frame durations.
    ///
    /// - Parameter durations: An array of durations to divide.
    /// - Returns: The GCD of all of the durations.
    private class func vectorGCD(of durations: [Int]) -> Int
    {
        guard let first = durations.first else
        {
            return 0
        }
        
        var vector: Int = Int(first)
        
        for index in 0..<durations.count
        {
            let duration = durations[index]
            vector = gcd(a: Int(duration), b: Int(vector))
        }
        
        return vector
    }
    
    /// Calculates the per-frame animation duration of the gif.
    ///
    /// - Parameter data: The data to display.
    /// - Returns: the duration to animate each frame.
    private class func animationDuration(with durations: [Int]) -> TimeInterval
    {
        let totalSeconds = durations.reduce(0) { (partial: Int, input:Int) -> Int in
            return partial + input
        }
        
        return TimeInterval(totalSeconds) / 100.0
    }
    
    // MARK: - Repeating Frames to Simulate Per-Frame Duration With UIImage's Single Animation Duration
    
    /// Returns an array of images, repeating to account for per-frame duration.
    /// This method assumes that frames & durations are of equal length.
    ///
    /// - Parameters:
    ///   - frames: The original array of raw frames from the GIF data, extracted with ImageIO.
    ///   - durations: The array of durations.
    /// - Returns: An array of frames, repeating images so the final GIF animates correctly, even with variable frame rate.
    private class func framesAccountingForPerFrameDuration(with frames: [UIImage], and durations:[Int]) -> [UIImage]
    {
        var output: [UIImage] = []
        
        let gcd = self.vectorGCD(of: durations)
        
        for index in 0..<min(frames.count, durations.count)
        {
            let image = frames[index]
            let duration = durations[index]
            if gcd == 0
            {
                continue
            }
            
            let repeatCount = duration / gcd
            
            let images = Array<UIImage>(repeatElement(image, count: repeatCount))
            output.append(contentsOf: images)
        }
        
        return output
    }
}
