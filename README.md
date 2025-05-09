![2c](https://github.com/user-attachments/assets/b47877b9-eb5f-4e8f-af39-169bb7cdec51)

A minimalistic transparent overlay tool to track construction depots in Elite Dangerous colonies.
The overlay feature only works in **Borderless/Windowed** mode in Elite.
You need to dock to construction depot to start tracking (sorry, this is how player journals work), so consider hauling Steel or other popular bulk quantity commodity already on your first visit.

The most recent active construction depot is selected by default, regardless of the owner.
Use the popup menu (right mouse button) to select specific construction depot or change some options.
You can use **Add Construction Info** command to enter your own short text about each construction (eg. there is no construction type in journal, use this command if you need it).

Markets are only updated if you actually visit them (merely docking is not sufficient). The FC market is a bit bugged in E:D as of now so you may have to visit it twice to update properly. 

You can manage all your visited markets and constructions in one place using the **Manage All** command. This tool lets you filter data, search for commodities, quickly set active market or construction, ignore/forget selected markets etc.

To temporarily turn the transparency off, double-click the title bar or choose the **Backdrop** command.

The app can be customized in the **EDConstrDepot.ini** file - no user interface is planned for this as of now.
It scans ALL your available journal entries since Trailblazers update 2 launch. 
To speed up application launch and/or skip long finished constructions, change the **IncludeFinished** and **JournalStart** options in the .ini file. 

The app uses local journal files only (ie. no cAPI/INARA/EDDB interface), so it is of limited use for team effort (ie. you get no updates from other commanders until you dock to FC/construction depot). The app scans all journals from all game accounts (alts) used on current Windows user account.

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
-  □/■ - commodity available at current (or recent) market; partial/full supply*
-  ○/● - commodity available at best market (auto-selected, see below); partial/full supply*
-  ∆/▲ - commodity available at secondary market (user or auto-selected); partial/full supply*
-  (no indicators) - commodity in cargo, exact match with construction request or ship capacity
-  ≠ - commodity in cargo, hauling more than requested<br>
-  < - commodity in cargo, hauling less then requested and under ship capacity

(*) If market supply is greater than ship capacity, it is considered "full supply".

Market score for market auto-selection is generally based on how many requested commodities are available. There are additional score modifiers:
- bonus for market in current system
- bonus for tiny quantity depot request (quickly clearing the request list is favoured)
- penalty for low stock (stock below request and capacity)
- penalty for under capacity flight (total quantity)


Advanced Features (.ini file only):
 - display multiple overlays, each with its own construction depot. Either run multiple copies of the app, or use **AllowMoreWindows** option and New Window command (this option is experimental and will not save your workspace though).
 - run the app on a PC tablet next to your main screen (old tablets with Win10 32-bit will do). You need to share your ED Saved Games folder for that and use **JournalDir** option to enter full UNC path. - 

o7, CMDRs!

