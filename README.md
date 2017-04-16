# [ITU Bridge](https://github.com/NEWLMS/itu-bridge-api) [![Build Status](https://magnum.travis-ci.com/NEWLMS/itu-bridge-api.svg?token=WfgnC5EzSzapVj4LAuAx)](https://magnum.travis-ci.com/NEWLMS/itu-bridge-api)

ITU Bridge is API/UI application on Rails 4.1, Angular 1.3.

## Quick start

Clone ITU Bridge and [ITU ID](https://github.com/NEWLMS/itu-id) on same level (e.g. itu-id, itu-bridge-api in ITU dir). 

>
	$ cd itu-id
	$ bin/dotenv
	$ rake db:migrate
	$ rake db:seed_fu
	$ cd itu-bridge-api
    $ bin/dotenv
    $ rake db:schema:load
    $ rake db:migrate
	$ rake db:seed_fu
	$ foreman start