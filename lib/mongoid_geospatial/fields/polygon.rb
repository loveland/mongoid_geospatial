module Mongoid
  module Geospatial
    class Polygon

      def initialize(geojson)
        #ap "poly init: #{geojson}"
        @geojson = geojson
      end

      # Object -> Database
      def mongoize
        ap "poly mongoize"
        @geojson
      end

      def to_hsh
        @geojson
      end
      alias :to_hash :to_hsh


      class << self

        # Database -> Object
        def demongoize(object)
          #ap "rgeo poly class demongo"
          return unless object
          Polygon.new(object)
          #f = (Mongoid::Geospatial.factory || RGeo::Geographic.spherical_factory)
          #RGeo::GeoJSON.decode(object, :geo_factory => f)
        end

        def mongoize(object)
          #ap "straightup poly class mongoize: #{object.inspect}"
          object
        end

        # Converts the object that was supplied to a criteria
        # into a database friendly form.
        def evolve(object)
          defined?(object.mongoize) ? object.mongoize : object
        end
      end

    end
  end
end
