{exec, spawn} = require "child_process"
fs = require "fs"
UglifyJS = require "uglify-js"

fileName = "jquery.datenizer"

printOut = (error, output) ->
  throw error if error
  process.stdout.write output

task "test", ->
  exec "NODE_ENV=test
    ./node_modules/.bin/mocha
    --compilers coffee:coffee-script
    --require coffee-script
    --require should
    --colors
  ", (error, output) ->
    throw error if error
    console.log output

task "watch", "Generate the javascript output when changes are detected", ->
  watch = exec "coffee -j lib/#{fileName}.js -cw src/datenizer/* src/datenizer.coffee"
  watch.stdout.on "data", (data) -> process.stdout.write data
  exec "cake minify"

task "build", "Generate the javascript output", ->
  exec "coffee -j lib/jquery.datenizer.js -c src/datenizer/* src/datenizer.coffee"

task "minify", "Generate the minified javascript output", ->
  output = UglifyJS.minify("lib/#{fileName}.js")
  fs.writeFile "lib/#{fileName}.min.js", output.code
