class Notifier

  def initialize(config)
    @smtp       = config['mail']['smtp']
    @from_email = config['mail']['from']
    @to_email   = config['mail']['recipients']
    @sms        = config['sms']
  end

  # Connect to SMTP server and send message
  def send_mail(streams)
    smtp = Net::SMTP.new @smtp[:address], @smtp[:port]    
    smtp.enable_ssl if @smtp[:ssl]
    smtp.start(@smtp[:domain], @smtp[:user], @smtp[:pass], :login) do
      smtp.send_message get_message(streams), @from_email, @to_email
    end
  end

  def send_sms(streams)    
    Net::HTTP.get(URI.parse(URI.escape("#{@sms[:address]}?api_id=#{@sms[:api_id]}&to=#{@sms[:to].join(',')}&login=#{@sms[:login]}&password=#{@sms[:password]}&text=#{get_sms(streams)}")))
  end

  # Generate html message
  def get_message(streams)
    "From: Stream checker <#{@from_email}>\r\n"+
    "Content-Type:text/html;charset=utf-8\r\n"+
    "Subject: Warning! Missing streams\r\n\n"+
    "<h1>Warning! Radio down</h1>"+
    "<p>Streams are down: #{streams.join(', ')}</p>"
  end

  # Gen sms message
  def get_sms(streams)
    "OMG! Streams are down: #{streams.join(', ')}"
  end

end