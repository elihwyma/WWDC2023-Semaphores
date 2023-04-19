I have produced an app to teach users how to communicate using Navy Flag 
Semaphores. The UI was built with UIKit.

For getting the camera input, I used AVFoundation. I used VisionKit to 
produce a list of arms points from the camera input. These points are then 
mathematically processed to calculate the represented flag (don't worry, 
you don't need to hold a flag).

The app has two modes, learn and game. Learn will show you the flag you 
must represent and its corresponding letter. This is ideal for users who 
have never seen this before and need to get to grips with it.

The game mode only gives the user the letter they should be showing. The 
aim is to get as many points as possible in 60 seconds. A point is scored 
by correctly representing a flag. 

On the right side of the screen is the camera display, with the points 
seen by VisionKit marked on. If no points are displayed, try adjusting 
your lighting. I found the best place to leave my iPad was on a chair and 
then took five steps back. Before starting each mode, a calibration phase 
will happen to ensure that the camera can see you at all times. I suggest 
not wearing any baggy clothes as this can obscure the readings.
