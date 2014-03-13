# Tern

Smart javascript code intelligence for Atom.io

##Installation
`apm install tern` or search for `tern` in the package manager

##Usage
* `Cmd+shift+p`, search for `Tern: start server`
* Start writing awesome JS!
* Default keybinding: `Cmd+space`
* the suggestion popup is open automatically when a `.` is typed (to be improved)

##Issues
This plugin is experimental and is likely to be buggy. Please, help me improve it by reporting any bug, suggesting improvements and, if you feel like it, by sending PR

##TO-DO
* Support other `tern` feature
    * Refactoring
    * Go-to definition
    * etc..
* Improve automatic completion pop-up
    * Insert text when no match is found
    * Heuristic to decide when to open suggestion list
* Performance
    * Send diff instead of whole file (supported by `tern`)
* Tests

##Authors
Tern plugin for atom is written by [Alessandro Artoni](https://artoale.com) and it's made possible thanks to the awesome [tern project](http://ternjs.net/) by [Marijn Haverbeke](https://github.com/marijnh).
