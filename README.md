# Dynamic polybar
A polybar able to spawn on a focused monitor

# Table of Content

- [Dynamic polybar](#dynamic-polybar)
  - [Once upon a time](#once-upon-a-time)
  - [What is](#what-is)
  - [Prerequisites](#prerequisites)
  - [Example](#example)
  - [Polybar configuration example](#polybar-configuration-example)
  - [Special thanks](#special-thanks)


# Once upon a time
Image you started to use Linux since a while and you decided to move to a tailing windows manager, let's say i3wm.

Now imagine you don't like at all dmenu because when you install it it's so dark and so empy so you look for an alternative and you discover polybar. You love it because it's colored, simple to use and you can make a lot of new module with so simple script.

You love to have everything visible on you bar like:
- all your i3 active workspaces (maybe 4, 5 or 10)
- all your disks
- the amount of RAM used on total
- the current cpu usage
- the current cpu temperature
- the current ip on all you connected NICs
- the remaining battery
- the clock
- the connected bluetooth devices
- the current playing song
- the calendar
- the speakers volume
- the backlight
- the tray
- the whatever you want

You will soon notice that a polybar has not enough space to hold all these information and some of them will go out of the screeen. It sucks!

That's me! I felt exactly in this situation so i was looking for a way to not have polybar modules out of the screen. The first thought was "let's remove some stuffs form the bar...no i like them all!".
So, the next thought was let's try to move the tray bar somewhere else. Afert some time spent on Google and Reddit i've found this [Tiny_polybar](https://github.com/phon31x/Tiny_polybar.git) (**THANK YOU [phon31x](https://github.com/phon31x)**).

I tried to use it and it was working pretty fine but then i decided to move some of my modules on the new bar. Not a big deal they were working fine too but, there was a but.

When clicking on the arrow module, the new tiny_polybar was appearing always on the same screen and to me it was awful because i always use two monitors.

Looking on the net, i didn't find a way to let the polybar spawn on the focused screen so...and i wrote a little script by mysef.

# What is

This repository contains a little script able to let spawn a polybar (or whatever else) on a focuse screen based on the mouse position.

# Prerequisites

To let it work you need to install:

- `polybar` (or whatever you want to let appear a screen)
- `xrandr`
- `xdotool`

The other commands used that should already be available on you system are: `grep`, `cut`, `sed`, `awk`, `echo`, `ps`, `tee`, `kill`


# Example

To let it work

```bash
# clone the repo
$ git clone https://github.com/davideLarosa/dynamic_polybar.git
# move into the folder just created
$ cd dynamic_polybar
# make it executable
$ chmod +x ./tinybar.sh
# run it
$ ./tinybar.sh
```

If everything goes smooth a new bar should appear on your screen.

# Polybar configuration example

1) Add the `arrow` module in your current bar definition at the end of `modules-right` key (usually it's under `$HOME/.config/polybar/config.ini`)
```
[bar/default]
    ...
    modules-right = <module-x> <module-y> <module-z> arrow
    ...
```

2) In you current active polybar add the `arrow` module (usually it's under `$HOME/.config/polybar/config.ini`)
```
[module/arrow]
    type = custom/script
    exec = echo ""
    click-left = bash $HOME/.config/polybar/tinybar.sh # put here the path of the tinybar.sh file from this repo
```
3) Add the new bar definition in your current bar definition file (usually it's under `$HOME/.config/polybar/config.ini`) for example
```
[bar/tray]
    modules-center = spotify-prev spotify-play-pause spotify-next
    modules-left =  <module-d> <module-e> <module-f>
    modules-right = <module-g> <module-h> <module-i>
    separator = " "
    include-file =  <path>/<to>/<the>/<file>/<in>/<this>/<repo>/tray-bar-definition.ini
# instead of include-file you can even add the content of that file here but like this it is more simple to read and maintain

[module/spotify-prev]
    type = custom/script
    exec = echo " "
    format = <label>
    click-left = playerctl previous -p spotify

[module/spotify-play-pause]
    type = custom/ipc
    hook-0 = echo " "
    hook-1 = echo " "
    initial = 1
    click-left = playerctl play-pause -p spotify

[module/spotify-next]
    type = custom/script
    exec = echo " "
    format = <label>
    click-left = playerctl next -p spotify
```

Now refresh your polybar (on i3wm mod+shift+R should work) and click on the arrow!

Hope it works!

Any suggestion, improvement or discussions is welcome!

Thank you all reading and using this.

# Special thanks

Special thanks to [phon31x](https://github.com/phon31x) for the idea.

The starting project is at [Tiny_polybar](https://github.com/phon31x/Tiny_polybar.git).

