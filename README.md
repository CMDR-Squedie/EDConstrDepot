![2c](https://github.com/user-attachments/assets/b47877b9-eb5f-4e8f-af39-169bb7cdec51)

A simple overlay tool to track construction depots in Elite Dangerous colonies.
This app only works in Borderless/Windowed mode in Elite.
You need to dock to construction depot to start tracking (sorry, this is how player journals work).
The tool can be heavily customized in the EDConstrDepot.ini file - no user interface is planned for this as of now.

Use the popup menu (right mouse button) to select construction depot or display in-app options.

To temporarily turn the transparency off, double-click the title bar or choose the Backdrop popup menu command.

The tool scans ALL your journal entries since Trailblazers update launch. 

To speed up application launch and/or skip long finished constructions, change the IncludeFinished and JournalStart options in the .ini file. 

Features:
- construction depot requested commodity/progress tracking
- indicators for availability at recent market, sort available commodities as first
- indicators for hauling under capacity or hauling more than required (for absent-minded people like myself :)
- simulate Fleet Carrier Buy requests as construction depot
- simulate Fleet Carrier Sell offers as available cargo
- group several active constructions as one (useful for low quantity requests)
- show original request for finished constructions


The FC commodity market is bugged in E:D as of now so you may have to visit it twice to update properly. 

The app uses local journal files only, no cAPI/INARA/EDDB interface, so it is of limited use for team effort (ie. you get no updates from other commanders until you dock to FC/construction depot).

You can also run the app on a PC tablet next to your main screen (eg. Lenovo Miix with Win10 32-bit). You need to share your ED Saved Games folder for that and use JournalDir option in the .ini file to enter full UNC path.


