Instructions: To start, run the matlab script "init", to initialize the initial conditions. When running the simulink file, set the stop time to 209 seconds.  

This week the team took the demo simulink file and edited it to fit the 10 m/s target velocity. As you will see when running the simulation, the car completes one 
whole loop around the track without deviating from its course. We edited the kinematic vehicle model equations to ensure that the car was being simulated in a straight 
line and didn't run off course. We determined that with this code that the fastest the car could go was 10 m/s, as any fatser would cause the car to go off course. 
Throughout this week we went through all the function blocks to ensure that the correct euations were being used and that the model was being fed the correct variables.
With the driver model, specifically the "Simplest Driver" function, we found that we needed to set delta to a positive number so that the car would continue around the 
track and not go in the wrong direction. After correcting these errors we were able to get the car to complete a whole loop around the track without deviation at a speed 
of 10 m/s.

## Week 2 Feedback (5/5)
It looks like the vehicle is not able to drive along the track without going out. This is most likely due to the simple driver model so I would advise to include some sort of lateral control that calculates the steering angle rather than setting it at some value. For the final submission, continue to work through the Simulink model and tweaking it so that you are able to stay on track and go around the track as fast as possible. Now that you have the Simulink model, you can animate the rectangular patch from week 1 using the car simulation data and animate the vehicle going around the race track. The team will also need to utilize the raceStat function somewhere in the MATLAB script to see how many loops the vehicle is able to do and to see information regarding the vehicle leaving the track.
