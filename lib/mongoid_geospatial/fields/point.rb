module Mongoid
  module Geospatial
    class Point
      include Enumerable
      attr_accessor :x, :y

      def initialize(x=nil, y=nil)
       #ap "regular point init"

        @x, @y = x, y
      end

      # Object -> Database
      def mongoize
        [x, y]
      end
      alias :to_a  :mongoize
      alias :to_xy :mongoize

      def [](args)
        mongoize[args]
      end

      def each
        yield x
        yield y
      end

      def to_hsh xl = :x, yl = :y
        {xl => x, yl => y}
      end
      alias :to_hash :to_hsh

      def radius r = 1
        [mongoize, r]
      end

      def radius_sphere r = 1, unit = :km
        radius r.to_f/Mongoid::Geospatial.earth_radius[unit]
      end

      #
      # Distance calculation methods. Thinking about not using it
      # One needs to choose and external lib. GeoRuby or RGeo
      #
      # #Return the distance between the 2D points (ie taking care only of the x and y coordinates), assuming
      # #the points are in projected coordinates. Euclidian distance in whatever unit the x and y ordinates are.
      # def euclidian_distance(point)
      #   Math.sqrt((point.x - x)**2 + (point.y - y)**2)
      # end

      # # Spherical distance in meters, using 'Haversine' formula.
      # # with a radius of 6471000m
      # # Assumes x is the lon and y the lat, in degrees (Changed in version 1.1).
      # # The user has to make sure using this distance makes sense (ie she should be in latlon coordinates)
      # def spherical_distance(point,r=6370997.0)
      #   dlat = (point.lat - lat) * DEG2RAD / 2
      #   dlon = (point.lon - lon) * DEG2RAD / 2

      #   a = Math.sin(dlat)**2 + Math.cos(lat * DEG2RAD) * Math.cos(point.lat * DEG2RAD) * Math.sin(dlon)**2
      #   c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      #   r * c
      # end

      class << self

        # Database -> Object
        def demongoize(object)
          #ap "point class demongo: #{object}"
          #ap caller
          return unless object
          Point.new(*object)
        end

        def mongoize(object)
          #ap "point class mongoize: #{object}"
          case object
          when Point then object.mongoize
          when Array then object.to_xy
          when Hash then object.to_xy
          else object
          end
        end

        # Converts the object that was supplied to a criteria
        # into a database friendly form.
        def evolve(object)
          object.respond_to?(:x) ? object.mongoize : object
        end
      end

    end
  end
end
