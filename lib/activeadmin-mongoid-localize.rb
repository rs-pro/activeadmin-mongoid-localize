require "activeadmin-mongoid-localize/version"

module ActiveAdmin
  module Mongoid
    class LocaleField
      extend ActiveModel::Naming

      @@validators = {}
      @@model = nil

      def initialize(obj, name)
        @obj = obj
        @@model = obj.class
        @field = name
        @@validators[@field] = @obj.class.validators_on(name.to_sym)
        @required = @@validators[@field].map(&:class).map(&:name).include? 'Mongoid::Validations::PresenceValidator'
        @errors = ActiveModel::Errors.new(self)
        hash = @obj.send("#{name}_translations")

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

      def required?
        @required
      end

      # attr_reader :errors

      def errors
        # validate!
        @errors
      end

      def validate!
        ::I18n.available_locales.each do |k|
          if @required && send(k).blank?
            @errors.add(k, I18n.t('errors.messages.blank'))
          end
        end
      end

      def column_for_attribute(name)
        # we only have one column for all locales
        @obj.fields[@field]
      end

      def method_missing(*args)
        @obj.send(*args)
      end

      def respond_to?(method_name, include_private = false)
        @obj.respond_to?(method_name, include_private)
      end

      def self.validators_on(attributized_method_name)
        @@validators[attributized_method_name].nil? ? [] : @@validators[attributized_method_name]
      end

      def self.human_attribute_name(*args)
        @@model.send(:human_attribute_name, *args)
      end
    end


    module Localize
      class Engine < Rails::Engine
      end
    end
  end
end

module Formtastic
  class FormBuilder
    def localized_input(name, args = {})

      t = self.object.send("#{name}_translations")
      field = ActiveAdmin::Mongoid::LocaleField.new(self.object, name)

      self.semantic_fields_for "#{name}_translations", field do |lf|
        ::I18n.available_locales.each do |locale|
          args[:value] =  (t.nil? || t[locale.to_s].nil?) ? '' : t[locale.to_s]

          label = CGI.escapeHTML(self.object.class.human_attribute_name(name)) + " #{template.image_tag "aml/flags/#{locale.to_s}.png", alt: locale.to_s, title: locale.to_s}"
          if args[:as] == :ckeditor
            form_buffers.last << "<h3 style='margin: 10px 0px 0px 10px;'>#{label}</h3>#{'<abbr>*</abbr>' if field.required?}".html_safe
            args[:label] = false
          else
            args[:label] = label.html_safe
          end
          args[:required] = field.required?

          form_buffers.last << lf.input(locale, args)
          form_buffers.last
        end
      end
    end
  end
end
