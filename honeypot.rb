require 'socket'                 # Get sockets from stdlib
require 'mail'
require 'json'
require 'net/http'
require 'colorize'


#init program
puts """
  _   _                        ____       _   
 | | | | ___  _ __   ___ _   _|  _ \ ___ | |_ 
 | |_| |/ _ \| '_ \ / _ \ | | | |_) / _ \| __|
 |  _  | (_) | | | |  __/ |_| |  __/ (_) | |_ 
 |_| |_|\___/|_| |_|\___|\__, |_|   \___/ \__|
                         |___/                

                 Coded By ..:: ViRuS007 ::..
               Email : virus007@protonmail.com
                Github : github.com/shayanzare


""".yellow


#parsing config.json
file = open("config.json")
json = file.read

parsed = JSON.parse(json)

$port = parsed["port"]
$smtp = parsed["smtp"]
$username = parsed["username"]
$password = parsed["password"]
$domain = parsed["domain"]
$from = parsed["from"]
$to = parsed["to"]
$chat_id = parsed["chatId"]
$token_tel = parsed["TOKEN"]


server = TCPServer.open($port)    # Socket to listen on port
puts "[+] Server starting in port : #{$port}\n".blue

##### TODO ######
# def send_telegram(text)
# 	# puts "#{$token_tel}.#{$chat_id}"

# 	res = Net::HTTP.get_response(URI("https://api.telegram.org/bot" + $token_tel + "/sendmessage?chat_id="+ $chat_id +"&text=" + text))
# 	return res.body
# end

def send_email(text)

	# puts "#{$smtp}.#{$domain}.#{$username}.#{$password}.#{$to}.#{$from}.#{text}"

	options = { :address              => $smtp,
	            :port                 => 587,
	            :domain               => $domain,
	            :user_name            => $username,
	            :password             => $password,
	            :authentication       => 'plain',
	            :enable_starttls_auto => true  }



	Mail.defaults do
	  	delivery_method :smtp, options
	end
	Mail.deliver do
		to $to
		from $from
		subject 'HoneyPot'
		body text
	end
end


loop {                           # Servers run forever
   Thread.start(server.accept) do |client|
   	#get ip
   	addr_info = Socket.ip_address_list
	#send email
	send_email("IP : #{addr_info} \nTrying to connect your server!")
    #send to telegram

    client.puts "Closing the connection. Bye!"
    puts "IP : #{addr_info}".red
    
    # send_telegram("IP : #{addr_info} \nTrying to connect your server!")
	
	client.close                  # Disconnect from the client
   end
}
