{exec, spawn} = require "child_process"
fs = require "fs"
UglifyJS = require "uglify-js"

fileName = "jquery.datenizer"

task "watch", "Generate the javascript output when changes are detected", ->
  watch = exec "coffee -j #{fileName}.js -cw lib/datenizer/* lib/datenizer.coffee"
  watch.stdout.on "data", (data) -> process.stdout.write data
  exec "cake minify"

task "build", "Generate the javascript output", ->
  exec "coffee -j jquery.datenizer.js -c lib/datenizer/* lib/datenizer.coffee"

task "minify", "Generate the minified javascript output", ->
  output = UglifyJS.minify("#{fileName}.js")
  fs.writeFile "#{fileName}.min.js", output.code
