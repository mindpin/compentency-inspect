- bundle exec mina deploy

- ssh 101.201.76.76

- 服务端 cd /web/compentency-inspect/current

- cd ..; git clone https://github.com/mindpin/compentency-inspect-data.git

- RAILS_ENV=production rake db:mongoid:drop

- RAILS_ENV=production rails r /web/compentency-inspect-data/import.rb

- rails c -e production
   User.create role: 'admin', name: 'admin', login: 'admin', password: 'px27365d'

- wget http://7xsns9.com1.z0.glb.clouddn.com/compentency_inspect/create_java_compentency_inspect_user.tar.gz

- cd /web/compentency-inspect/current/
  RAILS_ENV=production rails r /web/create_java_compentency_inspect_user/create_users.rb