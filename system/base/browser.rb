
require 'firewatir'

  ENGINE = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
  if ENGINE == 'ruby'
    
    require 'firewatir'
    
    class Browser < FireWatir::Firefox
      
      def initialize(options={})
        sleep 3
        super(options)
        @username = nil
        @password = nil
      end
      
      def close(window_number)
        js_eval "getWindows()[#{window_number}].close()"
      end
      
      def credentials=(string)
        username, password = string.split(":")
        if username.nil? or password.nil?
          raise "Invalid credentials: #{string})"
        else
          @username = username
          @password = password
        end
      end
      
      def goto(url, dlFile, wait=3)
        if @username.nil? and @password.nil?
          return super(url)
        else
          t = Thread.new { logon(@username, @password, wait) }
          window_number = super(url)
          sleep 1
          t.join
          
          sleep 2
          
          complete = false
          part_file_was_created = File.exists?( "#{ dlFile }.part" )
          dlTime = 1
          until complete == true
            if File.exists?( dlFile ) and !File.exists?( "#{ dlFile }.part" )
              complete = true
              close(window_number)
              sleep 2
              dlTime = dlTime + 2
            elsif part_file_was_created && !File.exists?( dlFile ) and !File.exists?( "#{ dlFile }.part" )
              message = "DOWNLOAD FAILED: #{dlFile} URL: #{url} MESSAGE: Part file was created, but fail to complete download."
              $base.system_log(message)
              close(window_number)
              dlTime = false
              break
            else
              sleep 1
              dlTime = dlTime + 1
            end
          end
          
          return dlTime
        end
      end
      
      private
      
      def logon(username, password, wait)
        jssh_command = "
          var length = getWindows().length;
          var win;
          var found = false;
          for (var i = 0; i < length; i++) {
            win = getWindows()[i];
            if(win.document.title == \"Authentication Required\") {
              found = true;
              break;
            }
          }
          if (found) {
            var jsdocument = win.document;
            var dialog = jsdocument.getElementsByTagName(\"dialog\")[0];
            jsdocument.getElementsByTagName(\"textbox\")[0].value = \"#{username}\";
            jsdocument.getElementsByTagName(\"textbox\")[1].value = \"#{password}\";
            dialog.getButton(\"accept\").click();
          }
        \n"
        sleep(wait)
        $jssh_socket.send(jssh_command,0)
        read_socket()
      end
    end
  elsif ENGINE == 'jruby'
    require 'celerity'
    class Browser < Celerity::Browser; end
  else
    raise "Ruby ENGINE '#{ENGINE}' not supported."
  end
