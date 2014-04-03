require 'rgeo'
require 'mongoid_geospatial/extensions/rgeo_spherical_point_impl'

module Mongoid
  module Geospatial

    class Point

      def to_geo
        (Mongoid::Geospatial.factory || RGeo::Geographic.spherical_factory).point x, y
      end

      def distance other
        to_geo.distance other.to_geo
      end

      def self.mongoize(obj)
        #ap "rgeo point mongoize"
        #ap caller
        case obj
        when RGeo::Geographic::SphericalPointImpl then [obj.x, obj.y]
        when RGeo::Geographic::ProjectedPointImpl then [obj.x, obj.y]
        when Point then obj.mongoize
        when Array then obj.to_xy
        when Hash  then obj.to_xy
        else obj
        end
      end
    end


    class Line < GeometryField
      def to_geo
        (Mongoid::Geospatial.factory || RGeo::Geographic.spherical_factory).line_string self
      end

    end

    class Polygon

      def to_geo
        #ap "rgeo overriden polygon to_geo"
        f = (Mongoid::Geospatial.factory || RGeo::Geographic.spherical_factory)
        return RGeo::GeoJSON.decode(@geojson, :geo_factory => f)
      end
      
      # Database -> Object
      # This should be in the rgeo module but it wasn't seeing it there
      def demongoize(object)
        #ap "rgeo poly class demongo"
        return unless object
        f = (Mongoid::Geospatial.factory || RGeo::Geographic.spherical_factory)
        RGeo::GeoJSON.decode(object, :geo_factory => f)
      end

      def self.mongoize(obj)
        #ap "rgeo overriden polygon mongoize"
        if RGeo::Feature::Polygon.check_type(obj)
          #ap "gonna geojson encode the obj"
          RGeo::GeoJSON.encode(obj)
        elsif obj.is_a? Polygon
          #ap "just obj.mongoize cause its already a Polygon"
          obj.mongoize
        else
          #ap "duno what to do with it"
          obj
        end
      end
      
    end
    
  end
end
