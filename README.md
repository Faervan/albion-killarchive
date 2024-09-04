# What?
Trying to creae a murderledger clone with some additional features, as an educational project.

# Where?
https://albion.killarchive.fun/

# How?
Using Ruby on Rails for everything.
## Fetching events
- Fetching gets scheduled in `config/initializers/scheduler.rb`
- Events get analyzed and fed into the PostgreSQL database by the services in `app/services/event_handler_service/`
## Showing events
Just the Rails way.

# Contributing
This project needs a nice frontend design using HTML/CSS/Javascript and a lot of backend stuff for fetching and feeding from Albions API.
If you want to contribute to that, please feel free to open a PR for minor fixes or contact me via [Discord](https://discord.com/users/738658712620630076) to coordinate bigger changes/contributes.

# Installing it locally
You can clone this Repo and host the project locally:
## Dependencies
- `ruby` - currently 3.2.4 - consider installing via https://rvm.io/ or [via package manager if you're on Arch Linux](https://archlinux.org/packages/extra-staging/x86_64/ruby/)
- `git` - obviously
- `postgresql` - currently 16.3
- `rails` - `gem install rails`
- `gems` - `bundle install --gemfile Gemfile`
- `redis` - see [redis.io](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/)
- `ImageMagick` - see [imagemagick.org](https://imagemagick.org/script/download.php)
## PostgreSQL
PostgreSQL needs to be setup, that can be different depending on environment...
Look at
- [Arch Wiki](https://wiki.archlinux.org/title/PostgreSQL)
- [Debian Wiki](https://wiki.debian.org/PostgreSql)

When it comes to creating a user, do `createuser --interactive`, enter your username as role name and grant database creation perms, superuser not required.
## Running
In the `albion-killarchive` directory, do:
```
bin/rails db:create
bin/rails db:migrate
```
and then start the Server via
```
bin/rails server
```
and the job executing (to fetch events) with:
```
bundle exec sidekiq -q default,5 -q low_priority,2
```
You *should* be able to open http://localhost:3000/ in your browser and see stuff.

After waiting a few minutes, you should also run the following command to get the awakened weapon traits to display with readable names:
```
ruby db/set_awakened_weapon_trait_names_and_percentage.rb
```

# Credits
to [uxwing](https://uxwing.com/skull-red-icon/) for the favicon (`app/assets/images/favicon.svg`) as well as the pending-work icon (`app/assets/images/pending-work-icon.svg`)
