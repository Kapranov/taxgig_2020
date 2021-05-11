$ brew update && brew doctor          # Repeat, until you've done *all* the Dr. has ordered!
$ brew install postgresql             # You'll need postgres to do this... you may also need to 'initdb' as well. Google it.

$ brew install elixir
$ mix local.hex                       # Answer y to any Qs
$ createuser -d postgres              # create the default 'postgres' user that Chris McCord seems to like -- I don't create mine w/a pw...

# Use the latest Phoenix from here: http://www.phoenixframework.org/docs/installation -- currently this is 1.0.3
# ** Answer y to any Qs **
$ mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.0.3/phoenix_new-1.0.3.ez

# To make a Phoenix app, first CD to a location under which you'd like your app created, then enter:

$ mix phoenix.new <my_new_app_name>   # Answer y to any Qs

# Follow directions after that; generally, you'll additionally need to enter:

$ cd <my_new_app_name>
$ mix ecto.create                     # Answer y to any Qs
$ mix phoenix.server                  # then visit: http://localhost:4000  -- then ctrl-C here *twice* to exit server

# voila!