# frplux

this is an experiment in making a Flux architecture using FRP techniques.

the core idea is to replace a dispatcher with a single, Bacon bus.

this is a work in progress. issues and PRs are most welcome.

## overview

![frplux architecture diagram](http://i.imgur.com/Fx2Vszo.png)

ACTIONS (1) trigger AJAX events (2) push messages over the DISPATCHER stream.

the STORE reacts to messages in the DISPATCHER stream by (1) updating the application state and (2) pushing the *(entire)* application state over the STATE STREAM.

the COMPONENT re-draws the entire DOM every time a state comes through the STATE STREAM.

## this repository

this app demonstrates a simple messageboard. it fetches articles from the server, and lets you delete them. for the sake of example, deleting a message takes a second, and has a 50/50 chance of succeeding.

check out `app/messageboard/MessageboardEntry.coffee`. a single, application-wide dispatcher (a Bacon.Bus()) is passed into the module from `app/entry.coffee`, and the Messageboard entrypoint initializes an Actions object and a Store object.

each event in `Store.stateStream` (another Bacon.Bus()) is the application state at a given time. this is what the Messageboard view reacts to.

and, logically enough, the Messageboard triggers actions expoed in Actions.

NB, this isn't a library, there is no library offered here at all. it's just an example of a pattern, with Bacon.Bus() as the implementation.

## setup 

make sure you have `node`, `npm`, `gulp` and `coffee`. then just `npm install` and `gulp`. `coffee server.coffee` and go to http://localhost:3000

## developing

`gulp develop` to start the server + listen for changes. `gulp watch` will bundle the js on changes.
