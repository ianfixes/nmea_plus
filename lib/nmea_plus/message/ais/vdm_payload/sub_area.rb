
module NMEAPlus
  module Message
    module AIS
      module VDMPayload
        # A sub-structure in a payload: 87 bits describing a shape
        class SubArea < Payload

          payload_reader :shape_id, 0, 3, :_e

          # @!parse attr_reader :shape_description
          # @return [String] Shape description
          def shape_description
            case shape_id
            when 0 then "Circle or point"
            when 1 then "Rectangle"
            when 2 then "Sector"
            when 3 then "Polyline"
            when 4 then "Polygon"
            when 5 then "Associated text"
            when 6, 7 then "Reserved"
            end
          end

        end

        # Catch-all for undefined shape IDs
        class SubAreaUndefined < SubArea; end

        # SubArea structure base type for a region with scale
        class SubAreaScaled < SubArea
          payload_reader :scale_factor, 3, 2, :_u

          # @!parse attr_reader :scale_meters
          # @return [Integer] Scale factor represented in meters to multiply by
          def scale_meters
            10**scale_factor
          end
        end

        # SubArea structure base type for a region anchored to a point
        class SubAreaAnchored < SubAreaScaled
          payload_reader :longitude, 5, 25, :_I, 60 * 10**3, 181
          payload_reader :latitude, 30, 24, :_I, 60 * 10**3, 91
          payload_reader :precision, 54, 3, :_u
        end

        # SubArea structure type 0: Circle or point
        class SubArea0 < SubAreaAnchored
          payload_reader :radius, 57, 12, :_u

          # @!parse attr_reader :radius_meters
          # @return [Integer] Radius in meters, according to scale factor
          def radius_meters
            radius * scale_meters
          end
        end

        # SubArea structure type 1: Rectangle
        class SubArea1 < SubAreaAnchored
          payload_reader :dimension_east, 57, 8, :_u
          payload_reader :dimension_north, 65, 8, :_u

          payload_reader :orientation, 73, 9, :_u

          # @!parse attr_reader :dimension_east_meters
          # @return [Integer] Box dimension in meters, according to scale factor
          def dimension_east_meters
            dimension_east * scale_meters
          end

          # @!parse attr_reader :dimension_east_meters
          # @return [Integer] Box dimension in meters, according to scale factor
          def dimension_north_meters
            dimension_north * scale_meters
          end
        end

        # SubArea structure type 2: Sector
        class SubArea2 < SubAreaAnchored
          payload_reader :radius, 57, 12, :_u
          payload_reader :boundary_left, 69, 9, :_u
          payload_reader :boundary_right, 78, 9, :_u

          # @!parse attr_reader :radius_meters
          # @return [Integer] Radius in meters, according to scale factor
          def radius_meters
            radius * scale_meters
          end

        end

        # SubArea structure type 3: Polyline
        class SubArea3 < SubAreaScaled

          payload_reader :bearing1, 5, 10, :_u, 720
          payload_reader :distance1, 15, 10, :_u
          payload_reader :bearing2, 25, 10, :_u, 720
          payload_reader :distance2, 35, 10, :_u
          payload_reader :bearing3, 45, 10, :_u, 720
          payload_reader :distance3, 55, 10, :_u
          payload_reader :bearing4, 65, 10, :_u, 720
          payload_reader :distance4, 75, 10, :_u

          # Container for bearing / distance
          class ShapePoint
            # @overload bearing
            #   @return [Integer]
            # @overload bearing=(Integer)
            #   Sets bearing
            #   @param [Integer] new value
            attr_accessor :bearing

            # @overload distance
            #   @return [Integer]
            # @overload distance=(Integer)
            #   Sets distance
            #   @param [Integer] new value
            attr_accessor :distance

            # @overload scale_factor
            #   @return [Integer]
            # @overload scale_factor=(Integer)
            #   Sets scale factor
            #   @param [Integer] new value
            attr_accessor :scale_factor

            # @!parse attr_reader :distance_meters
            # @return [Integer] The scaled distance in meters
            def distance_meters
              distance * (10**scale_factor)
            end
          end

          # @!parse attr_reader :points
          # @return [Array] Array of {ShapePoint} objects
          def points
            ret = []

            # load up from existing properties
            (1..4).each do |i|
              d = send("distance#{i}")
              sp = ShapePoint.new
              sp.bearing = send("bearing#{i}")
              sp.distance = d
              sp.scale_factor = scale_Factor
              ret << sp
            end
            ret
          end
        end

        # SubArea structure type 4: Polygon
        class SubArea4 < SubArea3; end

        # SubArea structure type 5: Associated text
        class SubArea5 < SubArea
          payload_reader :text, 3, 84, :_t
        end

      end
    end
  end
end
