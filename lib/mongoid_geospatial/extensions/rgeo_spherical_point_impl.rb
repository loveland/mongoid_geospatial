module RGeo
  module Geographic
    class SphericalPointImpl
      def to_a
        [x, y]
      end

      def to_xy
        [x, y]
      end

      def [] index
        to_a[index]
      end
    end

    class ProjectedPointImpl
      def to_a
        [x, y]
      end

      def to_xy
        [x, y]
      end

      def [] index
        to_a[index]
      end
    end

  end
end
