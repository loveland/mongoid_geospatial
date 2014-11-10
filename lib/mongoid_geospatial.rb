require 'mongoid'
require 'active_support/core_ext/string/inflections'
require 'active_support/concern'
require 'mongoid_geospatial/geospatial'
require 'mongoid_geospatial/extensions/core_ext'
require 'mongoid_geospatial/extensions/rgeo_spherical_point_impl'
require 'mongoid_geospatial/helpers/spatial'
require 'mongoid_geospatial/helpers/delegate'

%w{geometry point}.each do |type|
  require "mongoid_geospatial/fields/#{type}"
end
