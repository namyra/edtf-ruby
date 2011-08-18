module EDTF
  
  PRECISIONS = [:year, :month, :day].freeze

  module ExtendedDate
    
    LONG_MONTHS = [1, 3, 5, 7, 8, 10, 12].freeze
    SHORT_MONTHS = [4, 6, 9, 11].freeze

    extend Forwardable
    
    include Seasons
    
    attr_accessor :calendar
    
    def precision
    	@precision ||= :day
    end
    
    def precision=(precision)
      raise ArgumentError, "invalid precision #{precision.inspect}" unless PRECISIONS.include?(precision.to_sym)
      @precision = precision.to_sym
      update_precision_filter[-1]
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def uncertain
      @uncertain ||= Uncertainty.new
    end

    def approximate
      @approximate ||= Uncertainty.new
    end

    def unspecified
      @unspecified ||= Unspecified.new
    end
    
    def_delegators :uncertain, :uncertain?, :certain?

    def certain!(*arguments)
      uncertain.certain!(*arguments)
      self
    end
    
    def uncertain!(*arguments)
      uncertain.uncertain!(*arguments)
      self
    end

    def approximate?(*arguments)
      approximate.uncertain?(*arguments)
    end
    
    alias approximately? approximate?
    
    def approximate!(*arguments)
      approximate.uncertain!(*arguments)
      self
    end
    
    alias approximately! approximate!
    
    def precise?(*arguments)
      !approximate?(*arguments)
    end
    
    alias precisely? precise?

    def precise!(*arguments)
      approximate.certain!(*arguments)
      self
    end

    alias precisely! precise!
    
    def_delegators :unspecified, :unspecified?, :specified?, :unsepcific?, :specific?
    
    def unspecified!(*arguments)
      unspecified.unspecified!(*arguments)
      self
    end

    alias unspecific! unspecified!

    def specified!(*arguments)
      unspecified.specified!(*arguments)
      self
    end

    alias specific! specified!
    
    def to_edtf
      "TODO"
    end

    def next
    	send("next_#{precision}")
    end
    
    def values
      precision_filter.map { |p| send(p) }
    end
    
    # Returns the same date with negated year        
    def negate
      v = values
      y = -1 * v.shift
      self.class.new(y, *v) # TODO copy extended attributes
    end
    
    alias -@ negate
    
    def last_day_of_month
    	case
    	when LONG_MONTHS.include?(month)
    		31
    	when SHORT_MONTHS.include?(month)
    		30
    	when leap?
    		29
    	else
    		28
    	end
    end
    
    def last_day_of_month?
    	day == last_day_of_month
    end
    
    def last_month_of_year
    	12
    end
    
    def last_month_of_year?
    	month == 12
    end
    
    private
    
    def precision_filter
      @precision_filter ||= update_precision_filter
    end
    
    def update_precision_filter
      case @precision
      when :year
        [:year]
      when :month
        [:year,:month]
      else
        [:year,:month,:day]
      end
    end

    
    module ClassMethods  
      def edtf(input, options = {})
        ::EDTF::Parser.new(options).parse(input)
      end
    end
    
  end
  
end