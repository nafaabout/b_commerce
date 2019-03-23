$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

require 'excon'
require 'json'

require 'b_commerce/version'
require 'b_commerce/base'
require 'b_commerce/products'

module BCommerce
end
