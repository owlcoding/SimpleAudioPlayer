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
Add to your Podfile

    pod 'MagicalRecord' 

then run 

    pod update


