module ActiveAdmin
  module Mongoid
    module Localize

      class Field
        extend ActiveModel::Naming

        @@validators = {}
        @@model = nil

        def clean_locale(locale)
          locale.to_s.gsub('-','_')
        end

        def initialize(obj, name)
          @obj = obj
          @@model = obj.class
          @field = name
          @@validators[@field] = @obj.class.validators_on(name.to_sym)
          @required = @@validators[@field].map(&:class).map(&:name).include? 'Mongoid::Validations::PresenceValidator'
          @errors = ActiveModel::Errors.new(self)
          hash = @obj.send("#{name}_translations")

          ::ActiveAdmin::Mongoid::Localize.locales.each do |k|
            inst_var_name = clean_locale(k) 
            ## create the getter that returns the instance variable
            self.class.send(:define_method, k, proc{self.instance_variable_get("@#{inst_var_name}")})

            ## create the setter that sets the instance variable
            self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{inst_var_name}", v)})

            ## create and initialize an instance variable for this key/value pair
            self.instance_variable_set("@#{inst_var_name}", '')
          end

          hash.each do |k,v|
            ## create and initialize an instance variable for this key/value pair
            inst_var_name = k.to_s.gsub('-','_')
            self.instance_variable_set("@#{inst_var_name}", v)
          end

          def @obj.before_validation
            validate!
          end
        end

        def required?
          @required
        end

        def errors
          validate! if @obj.errors.any?
          @errors
        end

        def validate!
          ::ActiveAdmin::Mongoid::Localize.locales.each do |k|
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


    end
  end
end
