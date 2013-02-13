require "activeadmin-mongoid-localize/version"
require 'activeadmin-mongoid-localize/formtastic'
require 'activeadmin-mongoid-localize/attributes_table'

module ActiveAdmin
  module Mongoid
    module Localize
      autoload :Field, 'activeadmin-mongoid-localize/field'

      class Engine < Rails::Engine
      end
    end
  end
end
