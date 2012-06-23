
# the usual boilerplate

require 'model'

require 'java'

import "eu.webtoolkit.jwt.WText"
import "eu.webtoolkit.jwt.WButtonGroup"
import "eu.webtoolkit.jwt.WRadioButton"
import "eu.webtoolkit.jwt.WInPlaceEdit"
import "eu.webtoolkit.jwt.WContainerWidget"
import "eu.webtoolkit.jwt.WTable"

class TenantApplication < WApplication
  def initialize(env)
    super(env)
    
    # set the current shop to nil at first
    @shop = nil
    
    # the app has a dead simple two-pane layout
    topleveltable = WTable.new getRoot
    @leftside = WContainerWidget.new(topleveltable.getElementAt(0, 0))
    @rightside = WContainerWidget.new(topleveltable.getElementAt(0, 1))

    # the content is just two line inputs, one for creating a new shop
    # the other for adding a coffee type to the shop
    WText.new '<br/>', getRoot
    addshop = WInPlaceEdit.new '', getRoot
    addshop.setEmptyText 'Click to add a shop'

    WText.new '<br/>', getRoot
    addcoffee = WInPlaceEdit.new '', getRoot
    addcoffee.setEmptyText 'Click to add a coffee'
    
    # set up the callbacks to create a shop
    # and coffee types
    addshop.valueChanged.add_listener(self) do
      Shop.create :name => addshop.getText.getValue
      addshop.setText ''
      showshops
    end

    addcoffee.valueChanged.add_listener(self) do
    
      # note here it's not needed to set the :shop attribute by hand
      # it will get set automatically
      # @shop should not be nil at this point however
      Coffee.create :name => addcoffee.getText.getValue
      addcoffee.setText ''
      showshops
    end

    # populate the left and right pane with the data from the DB
    showshops
  end

  def showshops
    
    # clear the left side, and set up a radio button group for shop selection
    @leftside.clear
    buttongroup = WButtonGroup.new @leftside
    index = 0
    shoparray = []
    
    # now, Shop.all seems to get cached, so I use this empty where
    Shop.where('').each{ |s|
      shoparray << s
      rb = WRadioButton.new s.name, @leftside
      buttongroup.addButton rb, index
      WText.new '<br/>', @leftside
      index += 1
    }
    
    # add a callback to the button group...
    buttongroup.checkedChanged.add_listener(self) do
    
      # ... to set @shop
      @shop=shoparray[buttongroup.getSelectedButtonIndex]
      
      # and fill the right side with the coffee types
      # again, no need to set the shop information in the where clause
      @rightside.clear
      Coffee.where('').each{ |c|
        WText.new c.name + '<br/>', @rightside
      }
    end
    
    # select the current shop in the button group
    # so the selection will not get lost if a new shop or coffee is added
    if ! @shop.nil?
      btnindex = shoparray.map {|x| x.id}.index(@shop.id)
      buttongroup.setSelectedButtonIndex btnindex
      buttongroup.checkedChanged.trigger(buttongroup.getButton(btnindex))
    end

  end

  # this is the function get called from the before_validation hook
  # and the default_scope function
  def getShop
    @shop
  end

end
