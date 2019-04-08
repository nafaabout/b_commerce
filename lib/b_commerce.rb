$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'excon'
require 'json' unless self.class.const_defined?('JSON')

require 'b_commerce/version'
require 'b_commerce/utils/object'
require 'b_commerce/query_methods'
require 'b_commerce/base'
require 'b_commerce/errors'

require 'b_commerce/resource_list'
require 'b_commerce/products_list'

module BCommerce

  def self.[](resource_type)
    class_name = resource_type.to_s.split('_').map(&:capitalize).join + 'List'
    const_get(class_name)
  end
end
