![2c](https://github.com/user-attachments/assets/b47877b9-eb5f-4e8f-af39-169bb7cdec51)

A simple transparent overlay tool to track construction depots in Elite Dangerous colonies.
This app only works in **Borderless/Windowed** mode in Elite.
You need to dock to construction depot to start tracking (sorry, this is how player journals work), so consider hauling Steel or other popular bulk quantity commodity already on your first visit.

The app requires no configuration and shows the recent active construction depot by default, regardless of owner.
Use the popup menu (right mouse button) to select specific construction depot or change some options.

To temporarily turn the transparency off, double-click the title bar or choose the Backdrop popup menu command.

The app can be heavily customized in the **EDConstrDepot.ini** file - no user interface is planned for this as of now.
It scans ALL your available journal entries since Trailblazers update launch. 
To speed up application launch and/or skip long finished constructions, change the **IncludeFinished** and **JournalStart** options in the .ini file. 

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

You can also run the app on a PC tablet next to your main screen (old tablets with Win10 32-bit will do). You need to share your ED Saved Games folder for that and use JournalDir option in the .ini file to enter full UNC path.


