$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'excon'
require 'json' unless self.class.const_defined?('JSON')
require 'date'
require 'byebug'

require 'b_commerce/version'
require 'b_commerce/utils/object'
require 'b_commerce/query_methods'
require 'b_commerce/base'
require 'b_commerce/errors'

require 'b_commerce/resource'
require 'b_commerce/catalog/resource_list'

Dir[File.join(__dir__, 'b_commerce/catalog/*.rb')].each{ |f| require f }
Dir[File.join(__dir__, 'b_commerce/server_to_server/*.rb')].each{ |f| require f }

module BCommerce

  def self.[](resource_type)
    class_name = resource_type.to_s.split('_').map(&:capitalize).join + 'List'
    if Catalog.const_defined?(class_name)
      Catalog.const_get(class_name)
    else
      const_get(class_name)
    end
  end
end
