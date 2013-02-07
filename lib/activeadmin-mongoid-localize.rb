require "activeadmin-mongoid-localize/version"

module ActiveAdmin
  module Mongoid
    class Hashit
      def initialize(hash)
        ::I18n.available_locales.each do |k|
          ## create the getter that returns the instance variable
          self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})

          ## create the setter that sets the instance variable
          self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})

          ## create and initialize an instance variable for this key/value pair
          self.instance_variable_set("@#{k}", '')
        end

        hash.each do |k,v|
          ## create and initialize an instance variable for this key/value pair
          self.instance_variable_set("@#{k}", v)
        end
      end
    end


    module Localize
      # Your code goes here...
      class Engine < Rails::Engine
      end
    end
  end
end

module Formtastic
  class FormBuilder
    def localized_input(name, args = {})

      t = self.object.send("#{name}_translations")
      tv = ActiveAdmin::Mongoid::Hashit.new(t)

      self.semantic_fields_for "#{name}_translations", tv do |lf|
        ::I18n.available_locales.each do |locale|
          args[:value] =  (t.nil? || t[locale.to_s].nil?) ? '' : t[locale.to_s]
          # locale.to_s

          label = CGI.escapeHTML(self.object.class.human_attribute_name(name)) + " #{template.image_tag "aml/flags/#{locale.to_s}.png", alt: locale.to_s, title: locale.to_s}"
          if args[:as] == :ckeditor
            form_buffers.last << "<h3 style='margin: 10px 0px 0px 10px;'>#{label}</h3>".html_safe
            args[:label] = false
          else
            args[:label] = label.html_safe
          end

          form_buffers.last << lf.input(locale, args)
          form_buffers.last
        end
      end
    end
  end
end
