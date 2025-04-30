A simple overlay tool to track construction depots in Elite Dangerous colonies.
This app only works in Borderless/Windowed mode in Elite.
You need to dock to construction depot to start tracking (sorry, this is how player journals work).
The tool can be heavily customized in the EDConstrDepot.ini file - no user interface is planned for this as of now.


Features:
- construction depot requested commodity tracking
- indicators for recent market availability
- indicators for hauling under capacity or hauling more than required
- simulate Fleet Carrier Buy requests as construction depot
- simulate Fleet Carrier Sell offers as available cargo
- group several active construction for one request (useful for low quantity requests)
- show original request list for finished constructions

The tool scans ALL your journal entries since Trailblazers update launch. 
To speed up application launch, change the JournalStart option in the .ini file. 

Use the right mouse button to select construction depot or display in-app options.

The FC commodity market is bugged in E:D as of now so you may have to visit it twice to update properly. 

The app uses local journal files only, no cAPI/INARA/EDDB interface, so it is of limited use for team effort (ie. you get no updates from other commanders until you dock to FC/construction depot)
