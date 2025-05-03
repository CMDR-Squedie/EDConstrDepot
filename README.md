![2c](https://github.com/user-attachments/assets/b47877b9-eb5f-4e8f-af39-169bb7cdec51)

A simple transparent overlay tool to track construction depots in Elite Dangerous colonies.
This app only works in **Borderless/Windowed** mode in Elite.
You need to dock to construction depot to start tracking (sorry, this is how player journals work), so consider hauling Steel or other popular bulk quantity commodity already on your first visit.

The app uses local journal files only (ie. no cAPI/INARA/EDDB interface), so it is of limited use for team effort (ie. you get no updates from other commanders until you dock to FC/construction depot).

The most recent active construction depot is selected by default, regardless of the owner.
Use the popup menu (right mouse button) to select specific construction depot or change some options.
You can use Add Construction Info command to enter your own short text about each construction (eg. there is no construction type in journal, use this command if you need it).

To temporarily turn the transparency off, double-click the title bar or choose the Backdrop command.

The app can be customized in the **EDConstrDepot.ini** file - no user interface is planned for this as of now.
It scans ALL your available journal entries since Trailblazers update launch. 
To speed up application launch and/or skip long finished constructions, change the **IncludeFinished** and **JournalStart** options in the .ini file. 

Features:
- construction depot commodity/progress tracking
- indicators for availability at current/recent market (available commodities sort as first)
- indicators for availablity at selected visited markets (including Fleet Carriers)
- indicators for hauling under capacity or hauling more than required (for absent-minded people like myself :)
- simulate Fleet Carrier Buy requests as construction depot
- simulate Fleet Carrier Sell offers as available cargo
- group several active constructions as one (useful for multiple low quantity requests)
- show original request for finished constructions
- comments/custom text for construction depots and FCs

Indicators:
- □/■ - commodity available at current (or recent) market; partial/full supply*
- ∆/▲ - commodity available at secondary market (user selected); partial/full supply*
- ○/● - commodity available at best market (auto-selected, see below); partial/full supply*
- (no indicators) - commodity in cargo, exact match with construction request or ship capacity
- ≠! - commodity in cargo, hauling more than requested
- <! - commodity in cargo, hauling less then requested and under ship capacity

(*) If market supply is greater than ship capacity, it is considered "full supply".

The app scans all journals from all game accounts (alts) used on current Windows user account.

Commodity markets are only updated if you actually visit them (merely docking is not sufficient). The FC commodity market is a bit bugged in E:D as of now so you may have to visit it twice to update properly. 

Advanced Features (.ini file only):
 - automatically store all visited market data. Typically, you add your favorite markets manually with the Markets/Add Recent Market command (the app updates the market with each visit automatically) . **TrackMarkets** option can automatically add all new markets to the list.
 - the app can auto-suggest best market for your remaining construction request with its own indicator, base on your visited market data. Use **ShowBestMarket** to test it (very experimental, megaships are excluded)
 - display multiple overlays, each with its own construction depot. Either run multiple copies of the app, or use **AllowMoreWindows** option and New Window command (this option will not save your workspace though).
 - run the app on a PC tablet next to your main screen (old tablets with Win10 32-bit will do). You need to share your ED Saved Games folder for that and use **JournalDir** option to enter full UNC path.

o7, CMDRs!

