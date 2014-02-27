//
//  ViewController.m
//  ReadyPlayerDemoOne
//
//  Created by Janie Clayton-Hasz on 2/27/14.
//  Copyright (c) 2014 Third Impact Software. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UISlider *panSlider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set the player properties
    _player = [[AVAudioPlayer alloc] init];
    _player = [self playerForFile:@"Rasputin" fileExtention:@"m4a"];
    
    // Set up buttons
    _playButton.enabled = YES;
    _pauseButton.enabled = NO;
    _stopButton.enabled = NO;
    
    // Set values for volume slider
    
    // Set values for the rate slider
    _rateSlider.minimumValue = 0.5;
    _rateSlider.maximumValue = 2.0;
    _rateSlider.value = 1.0;
    
    // Set values for pan slider
    
    // Connect to the notification center
    NSNotificationCenter *nsnc = [NSNotificationCenter defaultCenter];
    [nsnc addObserver:self
             selector:@selector(handleRouteChange:)
                 name:AVAudioSessionRouteChangeNotification
               object:[AVAudioSession sharedInstance]];
    
}

- (AVAudioPlayer*)playerForFile:(NSString*)name
                  fileExtention:(NSString*)extention
{
    // Create path to the audio file
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name
                                             withExtension:extention];
    
    // Set up audio player
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                                   error:&error];
    if (player) {
        player.enableRate = YES;
        [player prepareToPlay];
    } else {
        NSLog(@"Error creating player: %@", [error localizedDescription]);
    }
    
    return player;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pauseButtonTapped:(id)sender {
    [_player pause];
    _playButton.enabled = YES;
    _stopButton.enabled = NO;
    _pauseButton.enabled = NO;
}

- (IBAction)playButtonTapped:(id)sender {
    [_player play];
    _playButton.enabled = NO;
    _pauseButton.enabled = YES;
    _stopButton.enabled = YES;
}

- (IBAction)stopButtonTapped:(id)sender {
    [_player stop];
    _playButton.enabled = YES;
    _stopButton.enabled = NO;
    _pauseButton.enabled = NO;
}

- (IBAction)volumeSliderMoved:(id)sender {
}

- (IBAction)rateSliderMoved:(id)sender {
}

- (IBAction)panSliderMoved:(id)sender {
}

#pragma mark - ROUTE CHANGE HANDLER

- (void)handleRouteChange:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    
    AVAudioSessionRouteChangeReason reason =
    [info[AVAudioSessionRouteChangeReasonKey] unsignedIntValue];
    
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        AVAudioSessionRouteDescription *previousRoute =
        info[AVAudioSessionRouteChangePreviousRouteKey];
        
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self.player stop];
            // [self.delegate playbackStopped];
        }
    }
}

@end
