TernView = require './tern-view'
ternServerFactory = require './server'
_ = require 'underscore-plus'
clientFactory = (require './client')
client = null;
tern = module.exports =
    autocompleteViews: []
    update: editor ->
        client.update editor.getUri(), editor.getText()

    checkCompletion: (editor, force = false) ->
        cursor = editor.getCursor()
        row = cursor.getBufferRow()
        buffer = editor.getBuffer()
        col = cursor.getBufferColumn()
        lastChar = buffer.getTextInRange [[row, col - 1], [row, col]]
        if lastChar is '.' or force is yes
            buffer.off 'contents-modified'
            client.completions(editor.getUri(),
                line: row
                ch: col
            editor.getText()).then (data) =>
                {@start, @end} = data
                @ternView.startCompletion(data.completions)
            , (err) ->
                console.error 'error', err


    registerEvents: ->
        atom.workspace.eachEditor (editor) =>
            if editor.getGrammar().name isnt 'JavaScript'
                return
            buffer = editor.getBuffer()
            buffer.on 'contents-modified', _.throttle @update.bind(this, editor), 2000
            buffer.on 'contents-modified', @checkCompletion.bind(this, editor, false)



    activate: (state) ->
        @ternView = new TernView()
        @ternView.on 'completed', (evt, data) =>
            if (data?.name)
                start = [@start.line, @start.ch]
                end = [@end.line, @end.ch]
                atom.workspace.getActiveEditor().getBuffer().setTextInRange [start, end], (data.name || 'asd')
            @registerEvents()

        atom.workspaceView.command "tern:start-server", =>
            @server = ternServerFactory()
            @server.start (port) =>
                @ternPort = port
                client = clientFactory(port)
                atom.workspaceView.command "tern:completion", => @checkCompletion(atom.workspace.getActiveEditor(), yes)
        @registerEvents()

    deactivate: ->
        @ternView.destroy()
        @server.stop()
        @ternview = null;

    serialize: ->
        ternViewState: @ternView.serialize()
