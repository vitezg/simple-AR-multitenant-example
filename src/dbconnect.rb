# load h2
require 'java'
import "org.h2.Driver"
import "org.h2.tools.Server"

Driver.load

# load activerecord
require 'rubygems'
require 'active_record'

# connect to / create a h2 database
ActiveRecord::Base.establish_connection(:adapter => 'jdbc', :driver => 'org.h2.Driver', :url => 'jdbc:h2:/tmp/DB1', :username => "sa", :password => "sa")

# personal preference
ActiveRecord::Base.pluralize_table_names = false
