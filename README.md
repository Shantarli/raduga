# RADUGA

## General overview

Raduga is a relatively simple application written using the Phoenix framework in the Elixir language. It was made primarily for training purposes, but I hope some of you will find it useful and entertaining.

![Raduga Screenshot](https://shantarli.me/pages/web/raduga/raduga.png?m=1674091616)

It's kind of like сhristmas garland or a strobe light for your event. It's something that can help you create an atmosphere, especially if you pick the right music. Just create a room, add colors to it with a given rate of change, and then everything will work automatically. All color changes are displayed synchronously to everyone in the room. Endlessly, in a loop.

Keyboard shortcuts also available.
| key | action |
|------------|-----------------|
| 1-7 | select |
| left/right | change speed |
| E | edit color |
| R | random color |
| A | add new |
| D | delete selected |
| S | save selected |
| Escape | deselect |
| Spacebar | toggle sidebar |
| Q | toggle QR Code |

---

## Installation

The process is no different from the installation of other Phoenix applications. First go to the Raduga folder and run:

    mix deps.get

to get the dependencies.  
Then run:

    mix phx.server

to start the server.

The application should start on 4000 port. There is also no need to configure the database, SQLite is used by default and the necessary file will be created automatically.
