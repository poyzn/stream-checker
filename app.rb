require 'net/http'
require 'json'
require 'net/smtp'
require 'openssl'
require 'date'
require 'yaml'
require_relative 'lib/notifier.rb'
require_relative 'lib/logger.rb'

class App
  def self.run

  	config		= YAML.load_file('config.yml')
		logger 		= Logger.new(config['logs'])
		notifier	= Notifier.new(config['notifier'])		

		# Parse json with streams list
		begin
			res = Net::HTTP.get(URI.parse(url))
			res.gsub!(/\},[\r\n ]+\}/m, '}}')
			json = JSON res.scan(/\{.+\}/m).first
		rescue => e
			logger.error e
			exit
		end

		# Checking for missing streams
		missing_streams 	= []
		if json && json.keys.any?	
			#  No index
		  missing_streams << stream unless json.keys.include? stream_prefix
		  # With indexes
		  streams.each do |index|
		    stream = "#{stream_prefix}#{index}"
		    missing_streams << stream unless json.keys.include? stream
		  end
		end

		# If any missing streams send message
		if missing_streams.any?			
			logger.error "Missing streams!"
		  notifier.send_mail missing_streams
		  notifier.send_sms missing_streams		  
		else
		  logger.log "All streams are OK!"
		end
  end
end
