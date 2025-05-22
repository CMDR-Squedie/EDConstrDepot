![00000aa](https://github.com/user-attachments/assets/774bc254-f7a0-4e59-8276-70ce2eed085a)

Lastest version to download: https://github.com/CMDR-Squedie/EDConstrDepot/releases/latest

A minimalistic transparent overlay tool to track construction depots in Elite Dangerous colonies.
The overlay feature only works in **Borderless/Windowed** mode in Elite.
You need to dock to construction depot to start tracking (sorry, this is how player journals work), so consider hauling Steel or other popular bulk quantity commodity already on your first visit.

The most recent active construction depot is selected by default, regardless of the owner.
Use the popup menu (right mouse button) to select specific construction depot, switch markets or use Fleet Carrier options.
You can use **Add Construction Info** command to enter your own short text about each construction (eg. there is no construction type in journal, use this command if you need it).

Markets are only updated if you actually visit them (merely docking is not sufficient). 

You can manage all your visited markets and constructions in one place using the **Manage All** command. This tool lets you filter data, search for commodities, quickly set active market or construction, ignore/forget selected markets, check market economies etc.

To temporarily turn the transparency off, double-click the title bar or choose the **Backdrop** command.

The app uses local journal files only (ie. no cAPI/INARA/EDDB interface), so it is of limited use for team effort (ie. you get no updates from other commanders until you dock to FC/construction depot). The app scans all journals since Trailblazers update 2 launch, from all game accounts (alts) used on current Windows user account. To speed up application launch and/or skip long finished constructions, change the **IncludeFinished** and **JournalStart** options in the .ini file. 

Some advanced options can be customized in the **EDConstrDepot.ini** file.

Features:
- construction depot commodity/progress tracking
- indicators for availability at current/recent market (available commodities sort as first)
- indicators for availablity at selected visited markets (including Fleet Carriers)
- indicators for hauling under capacity or hauling more than required (for absent-minded people like myself :)
- simulate Fleet Carrier Purchase orders as construction depot; compare orders with construction needs
- simulate Fleet Carrier Sell offers as available cargo
- group several active constructions as one (useful for multiple low quantity requests)
- show original request for finished constructions
- comments/custom text for construction depots and FCs
- suggest best markets for current request; add markets to Ignored/Favorite list
- select market to see commodity availability (double-click market name in market list)
- select commodity to see which markets supply it (double click on commodity name)
- list of visited markets, with their economies
- list of commodities sold in market
- task groups - group markets and depots by context (personal projects/location in galaxy etc.)

Indicators:
-  □/■ - commodity available at current (or recent) market; partial/full supply*
-  ○/● - commodity available at best market (auto-selected, see below); partial/full supply*
-  ∆/▲ - commodity available at secondary market (user or auto-selected); partial/full supply*
-  ✓ - commodity in cargo, exact match with construction request
-  (+) - commodity in cargo, hauling more than requested 

(*) If market supply is not less than ship capacity, it is considered "full supply".

Market score for market auto-selection is generally based on how many requested commodities are available. There are additional score modifiers:
- bonus for market in current system
- bonus for tiny quantity depot request (quickly clearing the request list is favoured)
- bonus for favorite market
- penalty for low stock (stock below request and capacity)
- penalty for under capacity flight (total quantity)


Advanced Features (.ini file only):
 - display multiple overlays, each with its own construction depot. Either run multiple copies of the app, or use **AllowMoreWindows** option and New Window command (this option is experimental and will not save your workspace though).
 - run the app on a PC tablet next to your main screen (old tablets with Win10 32-bit will do). You need to share your ED Saved Games folder for that and use **JournalDir** option to enter full UNC path. - 

o7, CMDRs!


