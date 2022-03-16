require 'redmine'

require_dependency 'redmine1c'
require_dependency 'redmine1c/hooks'

Redmine::Plugin.register :redmine1c do
  name 'Redmine 1C Plugin'
  url  'https://github.com/zfilin/redmine1c'

  description 'Automatic sending notifications in 1C through https when a task changes.'

  author     'Alexander Lapshyn'
  author_url 'https://zfilin.org.ua/'

  version '1.0.1'

  requires_redmine version_or_higher: '2.6.0'
  
  settings :default => {
    'enabled' => '0',
	'notification_address' => 'https://your-site.com/your-base/hs/redmine/token/'
  }, :partial => 'settings/redmine1c_settings'
end

Rails.configuration.to_prepare do
  Redmine1C.setup
end

