class Logger

	def initialize(config={})
		dir = config['dir'] || 'logs'
		Dir.mkdir dir unless Dir.exist? dir
		@logfile = File.new File.join(dir, Time.now.strftime("%Y-%m-%d.log")), "a+"
	end

	def log(str)
		@logfile.write "#{Time.now.strftime("%Y-%m-%d %H-%M-%S")} - #{str}\n"
	end

	def error(str)
		log "ERROR: #{str}"
	end

end