$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'excon'
require 'json'

require 'b_commerce/version'
require 'b_commerce/base'
require 'b_commerce/products_list'

module BCommerce

  def self.[](resource_type)
    class_name = resource_type.to_s.split('_').map(&:capitalize).join + 'List'
    const_get(class_name)
  end
end
