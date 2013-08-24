require "activeadmin-mongoid-localize/version"

require 'activeadmin-mongoid-localize/formtastic'

require 'activeadmin-mongoid-localize/active_admin'
require 'activeadmin-mongoid-localize/attributes_table'

module ActiveAdmin
  module Mongoid
    module Localize
      autoload :Field, 'activeadmin-mongoid-localize/field'

      class << self
        attr_writer :locales

        def locales
          @locales || I18n.available_locales
        end

        def configure
          yield self
        end
      end

      class Engine < Rails::Engine
      end
    end
  end
end
