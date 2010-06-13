require 'onfire/event'
require 'onfire/event_table'

module Onfire
  def on(event_type, options={}, &block)
    table_options = {}
    table_options[:event_type]  = event_type
    table_options[:source_name] = options[:from] if options[:from]

    if block_given?
      return attach_event_handler(block, table_options)
    end

    attach_event_handler(options[:do], table_options)
  end

  def fire(event_type)
    bubble_event Event.new(event_type, self)
  end

  def bubble_event(event)
    process_event(event) # locally process event, then climb up.
    return if root?

    parent.bubble_event(event)
  end

  def process_event(event)
    handlers = local_event_handlers(event)
    handlers.any? ? handlers.each do |proc|
      return if event.stopped?
      proc.call(event)
    end : (@__default_event_handler__ && @__default_event_handler__.call(event))
  end

  def root?
    !parent
  end

  def event_table
    @event_table ||= Onfire::EventTable.new
  end

  def set_default_event_handler(method=nil, &block)
    block = lambda { |evt| self.send(method, evt) } unless block_given?
    @__default_event_handler__ = block
  end

  protected
    def attach_event_handler(proc, table_options)
      event_table.add_handler(proc, table_options)
    end

    # Get all handlers from self for the passed event.
    def local_event_handlers(event)
      event_table.all_handlers_for(event.type, event.source)
    end
end
