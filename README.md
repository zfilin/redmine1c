# redmine1c
Плагин для интеграции с подсистемой "Redmine 1C"

install

bundle install --without development test --no-deployment
bundle exec rake redmine:plugins NAME=redmine1c RAILS_ENV=production
/etc/init.d/thin restart 

uninstall

rake redmine:plugins:migrate NAME=redmine1c VERSION=0 RAILS_ENV=production
