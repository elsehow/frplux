# frplux

this is an experiment in making a Flux architecture using FRP techniques.

the core idea is to replace a dispatcher with a single, Bacon bus.

this is a work in progress. issues and PRs are most welcome.

## setup 

make sure you have `node` and `npm` 

if you don't have gulp, `npm install --global gulp`

then just `npm install`. `gulp watch` will restart server on changes, bundle js on changes, etc - see gulpfile for details.