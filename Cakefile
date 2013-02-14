{exec, spawn} = require "child_process"

task "watch", "Generate the javascript output when changes are detected", ->
  watch = exec "coffee -j jquery.datenizer.js -cw lib/datenizer/* lib/datenizer.coffee"
  watch.stdout.on "data", (data) -> process.stdout.write data

task "build", "Generate the javascript output", ->
  exec "coffee -j jquery.datenizer.js -c lib/datenizer/* lib/datenizer.coffee"
