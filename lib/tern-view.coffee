{$, $$, SelectListView} = require 'atom'

module.exports =
class TernView extends SelectListView

    initialize: (serializeState) ->
        super
        @addClass 'tern popover-list'
        @filterEditorView.on 'textInput', (event) =>
          {originalEvent} = event
          text = originalEvent.data

    cancelled: ->
        super
        @trigger 'completed'

    viewForItem: ({name, type}) ->
        $$ ->
            @li =>
                @span "#{name} : #{type}"

    confirmed: (item) ->
        @trigger 'completed', item
        @cancel()
        # @detach()

    handleEvents: ->
        @editorView.off 'tern:next'
        @editorView.off 'tern:previous'
        @editorView.on 'tern:next', => @selectNextItemView()
        @editorView.on 'tern:previous', => @selectPreviousItemView()

    selectNextItemView: ->
      super
      false

    selectPreviousItemView: ->
      super
      false

    getFilterKey: -> 'name'

    # Returns an object that can be retrieved when package is activated
    setPosition: ->
        { left, top } = @editorView.pixelPositionForScreenPosition(@editor.getCursorScreenPosition())
        height = @outerHeight()
        potentialTop = top + @editorView.lineHeight
        potentialBottom = potentialTop - @editorView.scrollTop() + height
        if @aboveCursor or potentialBottom > @editorView.outerHeight()
            @aboveCursor = true
            @css(left: left, top: top - height, bottom: 'inherit')
        else
            @css(left: left, top: potentialTop, bottom: 'inherit')

    afterAttach: (onDom) ->
        if onDom
            widestCompletion = parseInt(@css('min-width')) or 0
            @list.find('span').each ->
                widestCompletion = Math.max(widestCompletion, $(this).outerWidth())
            @list.width(widestCompletion)
            @width(@list.outerWidth())

    startCompletion: (completions)  ->
        @setItems completions
        if !@hasParent()
            # atom.workspaceView.append(this)
            @editorView = atom.workspaceView.getActivePaneView().activeView
            @editorView?.appendToLinesView(this)
            @editor = @editorView?.getEditor()
            @setPosition()
            @handleEvents()
            @focusFilterEditor()
