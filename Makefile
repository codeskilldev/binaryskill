urun:
	sudo /etc/init.d/postgresql start
	foreman start

uinstall:
	sudo apt-get install postgresql postgresql-contrib postgresql-doc
	sudo -u postgres createdb my_database_development
	sudo -u postgres createuser $$USER
	sudo apt-get libpq-dev

usearch:
	../elasticsearch/bin/elasticsearch

usearch-clean:
	rm -rf ../elasticsearch/data/elasticsearch/nodes/*
	rm -rf ../elasticsearch/logs/*

useed: usearch-clean
	rake db:schema:load
	rake db:seed
