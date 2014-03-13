{BufferedNodeProcess} = require 'atom'

module.exports = ->
    process = null
    start = (cb)->
        path = require 'path'
        command = path.resolve __dirname, "../node_modules/.bin/tern"
        args = ["--persistent", "--no-port-file"]
        stderr = (output) -> console.error output
        stdout = (output) ->
            output = output.split(" ")
            console.log 'output:', output
            port = output[output.length - 1]
            console.log "Running on port #{port}"
            cb port
        options =
            cwd: atom.project.getPath()
        exit = (code) -> console.log("tern exited with code: #{code}")
        process = new BufferedNodeProcess {command, args, stdout, stderr, exit}

    stop = ->
        process?.kill()
        process = null
    {start, stop}
