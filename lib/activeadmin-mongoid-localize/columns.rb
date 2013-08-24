module ActiveAdmin
  module Views
    class IndexAsTable < ActiveAdmin::Component
      class IndexTableFor < ::ActiveAdmin::Views::TableFor

        # Display a column for each locale
        def localize_column(attr)
          ActiveAdmin::Mongoid::Localize.locales.each do |locale|
            I18n.with_locale(locale) do
              column_name = resource_class.human_attribute_name(attr) + " (#{locale})"
              column(column_name, sortable: "#{attr}.#{locale}") do |resource|
                resource.send(attr)
              end
            end
          end
        end
      end
    end

  end
end