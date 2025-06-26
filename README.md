![00000aa](https://github.com/user-attachments/assets/774bc254-f7a0-4e59-8276-70ce2eed085a)

Lastest version to download: https://github.com/CMDR-Squedie/EDConstrDepot/releases/latest

A minimalistic transparent overlay tool to track construction depots in Elite Dangerous colonies.
The overlay feature only works in **Borderless/Windowed** mode in Elite.
You need to dock to construction depot to start tracking (sorry, this is how player journals work), so consider hauling Steel or other popular bulk quantity commodity already on your first visit.

To change font, transparency levels, click-through features, hide info you don't need or change other visuals, use the **Settings** command.

The most recent active construction depot is selected by default, regardless of the owner.
Use the popup menu (right mouse button) to select specific construction depot, switch markets or use Fleet Carrier options.
You can use **Construction Info** command to set construction type and enter your own short text about each construction.

You can manage all your colonies, visited markets and constructions using the **Manage All** command. This tool lets you filter data, search for commodities, quickly set active market or construction, ignore/forget selected markets, check market economies, compare markets or their historical snapshots, track your colonies, search for colony candidates (visited systems only), measure distances etc.

_(Markets are only updated if you actually visit them, merely docking is not sufficient)._

The app uses local journal files only (ie. no cAPI/INARA/EDDB interface), so it is of limited use for team effort (ie. you get no updates from other commanders until you dock to FC/construction depot). The app scans all journals since Trailblazers update 2 launch, from all game accounts (alts) used on current Windows user account. 

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
- track colony market history with snapshots (manual or automatic)
- compare markets or snapshots of same market (eg. after strong/weak links were added) [details](https://github.com/CMDR-Squedie/EDConstrDepot/releases/tag/release.v18)
- delivery time left, average dock-to-dock time and most recent time; delivery history with recent markets [details](https://github.com/CMDR-Squedie/EDConstrDepot/releases/tag/release.v21)
- manage your colonies, colony candidates and colonisation targets [details](https://github.com/CMDR-Squedie/EDConstrDepot/releases/tag/release.v22)
- task groups - group markets and depots by context (personal projects/location in galaxy etc.)

Indicators:
-  □/■ - commodity available at current (or recent) market; partial/full supply*
-  ○/● - commodity available at best market (auto-selected, see below); partial/full supply*
-  △/▲ - commodity available at secondary market (user or auto-selected); partial/full supply*
-  ✓ - commodity in cargo, exact match with construction request
-  (+) - commodity in cargo, hauling more than requested 

(*) Full supply is either full ship capacity supply or full request supply, see Settings.

Market score for market auto-selection is generally based on how many requested commodities are available. There are additional score modifiers:
- bonus for market in current system
- bonus for tiny quantity depot request (quickly clearing the request list is favoured)
- bonus for favorite market
- penalty for low stock (stock below request and capacity)
- penalty for under capacity flight (total quantity)
- bonus/penalty for distance from star
- penalty for extra jumps there or back


Advanced Features (.ini file only):
 - display multiple overlays, each with its own construction depot. Either run multiple copies of the app, or use **AllowMoreWindows** option and New Window command (this option is experimental and will not save your workspace though).
 - run the app on a PC tablet next to your main screen (old tablets with Win10 32-bit will do). You need to share your ED Saved Games folder for that and use **JournalDir** option to enter full UNC path.
 - if you are only interested in current constructions tracking, you can speed up application launch and/or skip long finished constructions, change the **IncludeFinished** and **JournalStart** options in the .ini file as shown in the template file.
 - if you copy system name in game's Galaxy Map, you can see your own comments about the system (if any); use **ScanClipboard** option to activate

o7, CMDRs!


