module Onfire
  # An Event is born in #fire and is passed up the ancestor chain of the triggering datastructure.
  # It carries a <tt>type</tt>, the fireing widget <tt>source</tt> and arbitrary payload <tt>data</tt>.
  class Event

    attr_accessor :type, :source, :data

    def initialize(type=nil, source=nil, data=nil)
      @type       = type
      @source     = source
      @data       = data
    end

    def stopped?
      @stopped ||= false
    end

    # Stop event bubbling.
    def stop!
      @stopped = true
    end

    ### FIXME: what about serialization? should we simply forget the source?
    def _dump(depth)
      ""
    end
    def self._load(str)
      ::Onfire::Event.new
    end

    def to_s
      "#<Onfire::Event:0x#{object_id.to_s(16)} type: #{type} source:#{source} data: #{data}>"
    end ; alias :to_s :inspect
  end
end
