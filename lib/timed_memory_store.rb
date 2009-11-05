class TimedMemoryStore < ActiveSupport::Cache::Store
	def initialize
		@data = {}
		@expires = {}
	end

	def read(name, options = nil)
		super
		@data[name] if !expired?(name)
	end

	def write(name, value, options = nil)
		super
		@data[name] = value.freeze
		@expires[name] = Time.now + options.delete(:expires_in) if !options.nil? && options.include?(:expires_in)
	end

	def delete(name, options = nil)
		super
		@data.delete(name)
	end

	def delete_matched(matcher, options = nil)
		super
		@data.delete_if { |k,v| k =~ matcher }
	end

	def exist?(name,options = nil)
		super
		@data.has_key?(name)
	end

	def clear
		@data.clear
	end

	private
	def expired?(name)
		if @expires[name]
			Time.now > @expires[name]
		else
			false
		end
	end
end
