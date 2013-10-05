SimpleAudioPlayer
=================

SimpleAudioPlayer is a simple wrapper for AVAudioPlayer

Usage
-----
To use it, make:

    [SimpleAudioPlayer playFile:@"filename.mp3"];

or
    
    [SimpleAudioPlayer playFile:@"filename.mp3" withCompletionBlock:^(BOOL finished) {
        NSLog(@"Finished playing");
    }];

Instalation
-----------

### Using [CocoaPods](http://cocoapods.org):

Add to your Podfile

    pod 'SimpleAudioPlayer' 

then run 

    pod update

### Not using CocoaPods:

Drag the .m and .h file to your project, make sure you have the
AVFoundation framework added to your project and off - you go!

