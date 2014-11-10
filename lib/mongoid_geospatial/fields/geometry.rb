require 'rgeo'
require 'mongoid_geospatial/extensions/rgeo_spherical_point_impl'



module RGeo
  module Feature
    module Geometry
      
      # Object -> Database
      def mongoize
        self.class.mongoize(self)
      end

      def to_hsh
        self.mongoize
      end
      alias :to_hash :to_hsh

      def to_geo
        self
      end

      class << self

        # Database -> Object
        def demongoize(object)
          o = case object
          when Array
            { 'type' => 'Point', 'coordinates' => object }
          when String
            JSON.parse(object)
          else
            object
          end
          return unless o
          RGeo::GeoJSON.decode(o, :geo_factory => Mongoid::Geospatial.factory)
        end

        # Object -> Database
        def mongoize(object)
          RGeo::GeoJSON.encode(object, :geo_factory => Mongoid::Geospatial.factory)
        end

        # Converts the object that was supplied to a criteria
        # into a database friendly form.
        def evolve(object)
          defined?(object.mongoize) ? object.mongoize : object
        end
      end
    end
    
    module Point
      def to_a
        [self.x, self.y]
      end
   
      def to_geo
        self
      end

      class << self
      
      class << self
        def demongoize(object)
          o = case object
          when Array
            { 'type' => 'Point', 'coordinates' => object }
          when String
            JSON.parse(object)
          else
            object
          end
          RGeo::GeoJSON.decode(o, :geo_factory => Mongoid::Geospatial.factory)
        end
        
        def mongoize(object)
          object.to_a
        end
        
        def evolve(object)
          defined?(object.mongoize) ? object.mongoize : object
        end
      end
    end
  end
end
