# 24x7-Weather App

# Description
24/7 Weather is an iOS application for iPhone platform that will provide the weather information of
current or desired location of end-user. This application will anticipate and respond to user
expectations, provide a smooth navigational experience, and appropriately reflect the end result.

# Application Specification
iOS version: 10.0 and above
Platform: iPhone only
Orientation: Portrait only
Compatible devices: iPhone 4S | iPhone 5/5C/5S | iPhone 6/6 Plus | iPhone 6S/6S Plus | iPhone 7/7 Plus | iPhone 7S/7S Plus

# Feature
_App will:_
  * Let user select from different cities (added by user)
  * Add new city for weather information using map
  * Search for city/place using search option in Add City screen
  * Show details of weather information of current date
  * Show forecast for next 5 days
  * Audio based weather report (in Main and Forecast screen)
  * User can mute/un-mute the audio based weather report

_iOS SDK used:_ UITableView and UITableViewCell | UserDefaults | UIPageViewController | CoreLocation framework | Social framework | MKMapView | AVFoundation | QuartzCore

_API consumed:_
  * Open Weather API - for weather information
  * Pixabay - for city image

# Application
1. Initially new user will be shown walk through to give a brief overview of the application.
2. In home screen, initially current location of user is used to fetch the weather via open weather api and populated
on screen.
3. From home scree, user can also share the weather information to different social media platform (which are
already installed in his/her iphone)
4. In city scree, user can view different cities added by him/her.
5. In detail screen, user can view other details of selected city.
6. In forecast screen, user can view next 5 days weather prediction.
7. In Add city screen, user can add city using map or by searching the place/city name on search controller (user
can add one city at a time). To add city, user needs to tap on pin to see pop-up with ‘+’ button. After tap, user
will be taken to cities list screen.
8. Weather siri would provide a audio based weather report for user and user can mute/un-mute the weather siri.

# Application Screenshot
![alt text](https://github.com/walle19/24x7-Weather/blob/master/Screenshot/IMG_1830.jpg)
![alt text](https://github.com/walle19/24x7-Weather/blob/master/Screenshot/IMG_1831.jpg)
![alt text](https://github.com/walle19/24x7-Weather/blob/master/Screenshot/IMG_1832.jpg)
![alt text](https://github.com/walle19/24x7-Weather/blob/master/Screenshot/IMG_1833.jpg)
![alt text](https://github.com/walle19/24x7-Weather/blob/master/Screenshot/IMG_1838.jpg)

