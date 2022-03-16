require 'net/http'
require 'uri'

module Redmine1C
	module Hooks
	
		def self.SendNotification(context)
			enabled = Setting['plugin_redmine1c']['enabled'].to_s
			return if enabled!="1"
		
			address = Setting['plugin_redmine1c']['notification_address'].to_s
			address += '/' if address[-1, 1]!='/'
			address += context[:issue].id.to_s
		
			uri = URI.parse(address)
			
			if uri.scheme == "http" then
				Thread.new do
					begin
						response = Net::HTTP.get_response(uri)
					rescue Exception => e
						Rails.logger.warn("REDMINE1C UNABLE TO CONNECT #{uri}, ERROR #{e}")
					end
				end
			else
				Thread.new do
					begin
						http = Net::HTTP.new(uri.host, uri.port)
						http.use_ssl = true
						http.verify_mode = OpenSSL::SSL::VERIFY_NONE
						request = Net::HTTP::Get.new(uri.request_uri)
						response = http.request(request)
					rescue Exception => e
						Rails.logger.warn("REDMINE1C UNABLE TO CONNECT #{uri}, ERROR #{e}")
					end
				end
			end
		end
	
		class ControllerIssuesNewAfterSaveHook < Redmine::Hook::ViewListener
			def controller_issues_new_after_save(context={})
				Hooks.SendNotification(context)
			end
		end

		class ControllerIssuesEditAfterSaveHook < Redmine::Hook::ViewListener
			def controller_issues_edit_after_save(context={})
				Hooks.SendNotification(context)
			end
		end
		
	end
end
