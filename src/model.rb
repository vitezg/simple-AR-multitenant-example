require 'dbconnect'
require 'java'
import "eu.webtoolkit.jwt.WApplication"

# define a TenantKeeper class to keep track of the tenants
class TenantKeeper < ActiveRecord::Base

  # prevent AR from complaining
  self.abstract_class = true

  # before_validation hook to set the shop_id for new records
  before_validation(:on => :create) do
    
    # return if there is no session object
    if WApplication::getInstance.nil? || WApplication::getInstance.getShop.nil?
      return
    end
    
    # otherwise set the shop_id for every newly created object
    write_attribute(:shop_id, WApplication::getInstance.getShop.id)
  end

  # note the "self"
  # this will restrict the AR queries
  def self.default_scope
    
    # again, check if the session and shop information is available
    if WApplication::getInstance.nil? || WApplication::getInstance.getShop.nil?
      return
    end
    
    # now it's sure there is a shop id, so use it
    # this where clause restricts pretty much every query to the
    # current shop
    where(:shop_id => WApplication::getInstance.getShop.id)
  end
end

# simple from here on
class Shop < ActiveRecord::Base
  has_many :coffee
end

# everyone should subclass the TenantKeeper,
# except of course the Shop itself

class Coffee < TenantKeeper
  belongs_to :shop
end
