require "activeadmin-mongoid-localize/version"

require 'activeadmin-mongoid-localize/formtastic'

module ActiveAdmin
  module Mongoid
    module Localize
      autoload :Field, 'activeadmin-mongoid-localize/field'

      class Engine < Rails::Engine
      end

      # return in case our input is last
      self.form_buffers.last
    end
  end
end
