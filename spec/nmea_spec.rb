require 'nmea_plus'

RSpec.describe NMEAPlus::Decoder, "#parse" do
  describe "testing the parser" do
    before do
      @parser = NMEAPlus::Decoder.new
    end

    context "when reading an NMEA message" do
      it "conforms to basic NMEA features" do
        input = "$GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47"
        parsed = @parser.parse(input)
        expect(parsed.talker).to eq("GP")
        expect(parsed.message_type).to eq("GGA")
      end
    end

    context "when reading an AAM message" do
      it "properly reports various fields" do
        input = "$GPAAM,A,A,0.10,N,WPTNME*43"
        parsed = @parser.parse(input)
        expect(parsed.arrival_circle_entered?).to eq(true)
        expect(parsed.waypoint_passed?).to eq(true)
        expect(parsed.arrival_circle_radius).to eq(0.10)
        expect(parsed.arrival_circle_radius_units).to eq('N')
        expect(parsed.waypoint_id).to eq('WPTNME')
      end
    end


    context "when reading an ALM message" do
      it "properly reports various fields" do
        input = "$GPALM,1,1,15,1159,00,441d,4e,16be,fd5e,a10c9f,4a2da4,686e81,58cbe1,0a4,001*5B"
        parsed = @parser.parse(input)
        expect(parsed.total_messages).to eq(1)
        expect(parsed.message_number).to eq(1)
        expect(parsed.satellite_prn).to eq(15)
        expect(parsed.gps_week).to eq(1159)
        expect(parsed.sv_health).to eq(0)
        expect(parsed.eccentricity).to eq(17437)
        expect(parsed.reference_time).to eq(78)
        expect(parsed.inclination_angle).to eq(5822)
        expect(parsed.ascension_rate).to eq(64862)
        expect(parsed.semimajor_axis_root).to eq(10554527)
        expect(parsed.perigee_argument).to eq(4861348)
        expect(parsed.ascension_node_longitude).to eq(6844033)
        expect(parsed.mean_anomaly).to eq(5819361)
        expect(parsed.f0_clock).to eq(164)
        expect(parsed.f1_clock).to eq(1)
      end
    end

    context "when reading an APA message" do
      it "properly reports various fields" do
        input = "$GPAPA,A,A,0.10,R,N,V,V,011,M,DEST,011,M*82"
        parsed = @parser.parse(input)
        expect(parsed.no_general_warning?).to eq(true)
        expect(parsed.no_cyclelock_warning?).to eq(true)
        expect(parsed.cross_track_error).to eq(0.10)
        expect(parsed.direction_to_steer).to eq("R")
        expect(parsed.cross_track_units).to eq("N")
        expect(parsed.arrival_circle_entered?).to eq(false)
        expect(parsed.perpendicular_passed?).to eq(false)
        expect(parsed.bearing_origin_to_destination).to eq(11)
        expect(parsed.compass_type).to eq("M")
        expect(parsed.destination_waypoint_id).to eq("DEST")
      end
    end

    context "when reading an APB message" do
      it "properly reports various fields" do
        input = "$GPAPB,A,A,0.10,R,N,V,V,011,M,DEST,011,M,011,M*82"
        parsed = @parser.parse(input)
        expect(parsed.no_general_warning?).to eq(true)
        expect(parsed.no_cyclelock_warning?).to eq(true)
        expect(parsed.cross_track_error).to eq(0.10)
        expect(parsed.direction_to_steer).to eq("R")
        expect(parsed.cross_track_units).to eq("N")
        expect(parsed.arrival_circle_entered?).to eq(false)
        expect(parsed.perpendicular_passed?).to eq(false)
        expect(parsed.bearing_origin_to_destination).to eq(11)
        expect(parsed.compass_type).to eq("M")
        expect(parsed.destination_waypoint_id).to eq("DEST")
        expect(parsed.bearing_position_to_destination).to eq(11)
        expect(parsed.bearing_position_to_destination_compass_type).to eq("M")
        expect(parsed.heading_to_waypoint).to eq(11)
        expect(parsed.heading_to_waypoint_compass_type).to eq("M")
      end
    end

    context "when reading a BOD message" do
      it "properly reports various fields" do
        input = "$GPBOD,099.3,T,105.6,M,POINTB,*01"
        parsed = @parser.parse(input)
        expect(parsed.bearing_true).to eq(99.3)
        expect(parsed.bearing_magnetic).to eq(105.6)
        expect(parsed.waypoint_to).to eq("POINTB")
        expect(parsed.waypoint_from).to eq(nil)
      end
    end

    context "when reading a BWC message" do
      it "properly reports various fields" do
        input = "$GPBWC,220516,5130.02,N,00046.34,W,213.8,T,218.0,M,0004.6,N,EGLM*11"
        parsed = @parser.parse(input)
        now = Time.now
        expect(parsed.utc_time).to eq(Time.new(now.year, now.month, now.day, 22, 5, 16))
        expect(parsed.waypoint_latitude).to eq(51.50033333333333)
        expect(parsed.waypoint_longitude).to eq(-0.7723333333333334)
        expect(parsed.bearing_true).to eq(213.8)
        expect(parsed.bearing_magnetic).to eq(218.0)
        expect(parsed.nautical_miles).to eq(4.6)
        expect(parsed.waypoint_id).to eq("EGLM")
        expect(parsed.faa_mode).to eq(nil)
      end
    end

    context "when reading a BWR message" do
      it "properly reports various fields" do
        input = "$GPBWR,220516,5130.02,N,00046.34,W,213.8,T,218.0,M,0004.6,N,EGLM*11"
        parsed = @parser.parse(input)
        now = Time.now
        expect(parsed.utc_time).to eq(Time.new(now.year, now.month, now.day, 22, 5, 16))
        expect(parsed.waypoint_latitude).to eq(51.50033333333333)
        expect(parsed.waypoint_longitude).to eq(-0.7723333333333334)
        expect(parsed.bearing_true).to eq(213.8)
        expect(parsed.bearing_magnetic).to eq(218.0)
        expect(parsed.nautical_miles).to eq(4.6)
        expect(parsed.waypoint_id).to eq("EGLM")
      end
    end

    context "when reading a BWW message" do
      it "properly reports various fields" do
        input = "$GPBWW,099.3,T,105.6,M,POINTB,*01"
        parsed = @parser.parse(input)
        expect(parsed.bearing_true).to eq(99.3)
        expect(parsed.bearing_magnetic).to eq(105.6)
        expect(parsed.waypoint_to).to eq("POINTB")
        expect(parsed.waypoint_from).to eq(nil)
      end
    end

    context "when reading a DBK message" do
      it "properly reports various fields" do
        input = "$GPDBK,1.2,f,3.4,M,5.6,F*00"
        parsed = @parser.parse(input)
        expect(parsed.depth_feet).to eq(1.2)
        expect(parsed.depth_meters).to eq(3.4)
        expect(parsed.depth_fathoms).to eq(5.6)
      end
    end

    context "when reading a DBS message" do
      it "properly reports various fields" do
        input = "$GPDBS,1.2,f,3.4,M,5.6,F*00"
        parsed = @parser.parse(input)
        expect(parsed.depth_feet).to eq(1.2)
        expect(parsed.depth_meters).to eq(3.4)
        expect(parsed.depth_fathoms).to eq(5.6)
      end
    end

    context "when reading a DBT message" do
      it "properly reports various fields" do
        input = "$GPDBT,1.2,f,3.4,M,5.6,F*00"
        parsed = @parser.parse(input)
        expect(parsed.depth_feet).to eq(1.2)
        expect(parsed.depth_meters).to eq(3.4)
        expect(parsed.depth_fathoms).to eq(5.6)
      end
    end

    context "when reading a DCN message" do
      it "properly reports various fields" do
        input = "$GPDCN,1,ab,2.3,A,cd,4.5,V,ef,6.7,A,A,A,A,8.9,N,3*00"
        parsed = @parser.parse(input)
        expect(parsed.decca_chain_id).to eq(1)
        expect(parsed.red_zone_id).to eq('ab')
        expect(parsed.red_position_line).to eq(2.3)
        expect(parsed.red_master_line_ok?).to eq(true)
        expect(parsed.green_zone_id).to eq('cd')
        expect(parsed.green_position_line).to eq(4.5)
        expect(parsed.green_master_line_ok?).to eq(false)
        expect(parsed.purple_zone_id).to eq('ef')
        expect(parsed.purple_position_line).to eq(6.7)
        expect(parsed.purple_master_line_ok?).to eq(true)
        expect(parsed.use_red_line_navigation?).to eq(true)
        expect(parsed.use_green_line_navigation?).to eq(true)
        expect(parsed.use_purple_line_navigation?).to eq(true)
        expect(parsed.position_uncertainty).to eq(8.9)
        expect(parsed.position_uncertainty_units).to eq('N')
        expect(parsed.fix_data_basis).to eq(3)
      end
    end

    context "when reading a DPT message" do
      it "properly reports various fields" do
        input = "$GPDPT,1.2,3.4*00"
        parsed = @parser.parse(input)
        expect(parsed.depth_meters).to eq(1.2)
        expect(parsed.offset_distance).to eq(3.4)
      end
    end

    context "when reading a DTM message" do
      it "properly reports various fields" do
        input = "$GPDTM,ab,1,1234,S,5678,W,2.3,dname*00"
        parsed = @parser.parse(input)
        expect(parsed.code).to eq('ab')
        expect(parsed.subcode).to eq('1')
        expect(parsed.latitude_offset).to eq(-1234)
        expect(parsed.longitude_offset).to eq(-5678)
        expect(parsed.altitude_meters).to eq(2.3)
        expect(parsed.datum_name).to eq('dname')
      end
    end

    context "when reading a FSI message" do
      it "properly reports various fields" do
        input = "$GPFSI,1234.1,5678.1,c,4.3*00"
        parsed = @parser.parse(input)
        expect(parsed.transmit_frequency).to eq(1234.1)
        expect(parsed.receive_frequency).to eq(5678.1)
        expect(parsed.communications_mode).to eq('c')
        expect(parsed.power_level).to eq(4.3)
      end
    end

    context "when reading a GBS message" do
      it "properly reports various fields" do
        input = "$GPGBS,112233.44,1.2,3.4,5.6,78,9.1,1.3,1.4*00"
        parsed = @parser.parse(input)
        now = Time.now
        expect(parsed.fix_time).to eq(Time.new(now.year, now.month, now.day, 11, 22, 33.44))
        expect(parsed.expected_error_latitude_meters).to eq(1.2)
        expect(parsed.expected_error_longitude_meters).to eq(3.4)
        expect(parsed.expected_error_altitude_meters).to eq(5.6)
        expect(parsed.failed_satelite_prn).to eq(78)
        expect(parsed.missed_detection_probability).to eq(9.1)
        expect(parsed.failed_satellite_bias_meters).to eq(1.3)
        expect(parsed.bias_standard_deviation).to eq(1.4)
      end
    end

    context "when reading a GGA message" do
      it "properly reports various fields" do
        input = "$GPGGA,123519,4807.038,N,01131.000,W,1,08,0.9,545.4,M,46.9,M,2.2,123*4b"
        parsed = @parser.parse(input)
        now = Time.now
        expect(parsed.fix_time).to eq(Time.new(now.year, now.month, now.day, 12, 35, 19))
        expect(parsed.latitude).to eq(48.1173)
        expect(parsed.longitude).to eq(-11.516666666666666666)
        expect(parsed.fix_quality).to eq(1)
        expect(parsed.satellites).to eq(8)
        expect(parsed.horizontal_dilution).to eq(0.9)
        expect(parsed.altitude).to eq(545.4)
        expect(parsed.altitude_units).to eq("M")
        expect(parsed.geoid_height).to eq(46.9)
        expect(parsed.geoid_height_units).to eq("M")
        expect(parsed.seconds_since_last_update).to eq(2.2)
        expect(parsed.dgps_station_id).to eq(123)
        expect(parsed.checksum_ok?).to eq(true)
      end
    end

    context "when reading a GLC message" do
      it "properly reports various fields" do
        input = "$GPGLC,123,1.2,A,3.4,V,5.6,A,7.8,V,9.1,A,2.3,V*00"
        parsed = @parser.parse(input)
        expect(parsed.gri_tenth_microseconds).to eq(123)
        expect(parsed.master_toa_microseconds).to eq(1.2)
        expect(parsed.master_toa_signal?).to eq(true)
        expect(parsed.time_difference_1_microseconds).to eq(3.4)
        expect(parsed.time_difference_1_signal?).to eq(false)
        expect(parsed.time_difference_2_microseconds).to eq(5.6)
        expect(parsed.time_difference_2_signal?).to eq(true)
        expect(parsed.time_difference_3_microseconds).to eq(7.8)
        expect(parsed.time_difference_3_signal?).to eq(false)
        expect(parsed.time_difference_4_microseconds).to eq(9.1)
        expect(parsed.time_difference_4_signal?).to eq(true)
        expect(parsed.time_difference_5_microseconds).to eq(2.3)
        expect(parsed.time_difference_5_signal?).to eq(false)
      end
    end

    context "when reading a GLL message" do
      it "properly reports various fields" do
        now = Time.now
        input = "$GPGLL,4916.45,N,12311.12,W,225444,A*00"
        parsed = @parser.parse(input)
        expect(parsed.latitude).to eq(49.27416666666666666666)
        expect(parsed.longitude).to eq(-123.18533333333333333)
        expect(parsed.fix_time).to eq(Time.new(now.year, now.month, now.day, 22, 54, 44))
        expect(parsed.valid?).to eq(true)
        expect(parsed.faa_mode).to eq(nil)
      end
    end

    context "when reading a GNS message" do
      it "properly reports various fields" do
        input = "$GPGNS,225444,4916.45,N,12311.12,W,m,33,hdrop,12.3,34.5,45.6,99*00"
        now = Time.now
        parsed = @parser.parse(input)
        expect(parsed.fix_time).to eq(Time.new(now.year, now.month, now.day, 22, 54, 44))
        expect(parsed.latitude).to eq(49.27416666666666666666)
        expect(parsed.longitude).to eq(-123.18533333333333333)
        expect(parsed.mode).to eq('m')
        expect(parsed.satellites).to eq(33)
        expect(parsed.hdrop).to eq('hdrop')
        expect(parsed.altitude).to eq(12.3)
        expect(parsed.geoidal_separation).to eq(34.5)
        expect(parsed.data_age).to eq(45.6)
        expect(parsed.differential_reference_station_id).to eq(99)
      end
    end

    context "when reading a GRS message" do
      it "properly reports various fields" do
        now = Time.now
        input = "$GPGRS,024603.00,1,1.2,2.3,3.4,4.5,5.6,6.7,7.8,8.9,9.1,0.2,1.3,2.4*00"
        parsed = @parser.parse(input)
        expect(parsed.gga_fix_time).to eq(Time.new(now.year, now.month, now.day, 2, 46, 03))
        expect(parsed.gga_includes_residuals?).to eq(true)
        expect(parsed.residual_satellite_1).to eq(1.2)
        expect(parsed.residual_satellite_2).to eq(2.3)
        expect(parsed.residual_satellite_3).to eq(3.4)
        expect(parsed.residual_satellite_4).to eq(4.5)
        expect(parsed.residual_satellite_5).to eq(5.6)
        expect(parsed.residual_satellite_6).to eq(6.7)
        expect(parsed.residual_satellite_7).to eq(7.8)
        expect(parsed.residual_satellite_8).to eq(8.9)
        expect(parsed.residual_satellite_9).to eq(9.1)
        expect(parsed.residual_satellite_10).to eq(0.2)
        expect(parsed.residual_satellite_11).to eq(1.3)
        expect(parsed.residual_satellite_12).to eq(2.4)
      end
    end

    context "when reading a GST message" do
      it "properly reports various fields" do
        now = Time.now
        input = "$GPGST,024603.00,1.2,2.3,3.4,4.5,5.6,6.7,7.8*00"
        parsed = @parser.parse(input)
        expect(parsed.gga_fix_time).to eq(Time.new(now.year, now.month, now.day, 2, 46, 03))
        expect(parsed.total_rms_standard_deviation).to eq(1.2)
        expect(parsed.standard_deviation_semimajor_meters).to eq(2.3)
        expect(parsed.standard_deviation_semiminor_meters).to eq(3.4)
        expect(parsed.semimajor_error_ellipse_orientation_degrees).to eq(4.5)
        expect(parsed.standard_deviation_latitude_meters).to eq(5.6)
        expect(parsed.standard_deviation_longitude_meters).to eq(6.7)
        expect(parsed.standard_deviation_altitude_meters).to eq(7.8)
      end
    end

    context "when reading a GSA message" do
      it "properly reports various fields" do
        input = "$GPGSA,M,2,11,22,33,44,55,66,77,88,99,100,110,120,pdop,hdop,vdop*00"
        parsed = @parser.parse(input)
        expect(parsed.selection_mode).to eq('M')
        expect(parsed.mode).to eq(2)
        expect(parsed.satellite1).to eq(11)
        expect(parsed.satellite2).to eq(22)
        expect(parsed.satellite3).to eq(33)
        expect(parsed.satellite4).to eq(44)
        expect(parsed.satellite5).to eq(55)
        expect(parsed.satellite6).to eq(66)
        expect(parsed.satellite7).to eq(77)
        expect(parsed.satellite8).to eq(88)
        expect(parsed.satellite9).to eq(99)
        expect(parsed.satellite10).to eq(100)
        expect(parsed.satellite11).to eq(110)
        expect(parsed.satellite12).to eq(120)
        expect(parsed.pdop).to eq('pdop')
        expect(parsed.hdop).to eq('hdop')
        expect(parsed.vdop).to eq('vdop')
      end
    end

    context "when reading an OSD message" do
      it "properly reports various fields" do
        input = "$GPOSD,1.2,A,2.3,cref,4.5,sref,5.6,6.7,unit*00"
        parsed = @parser.parse(input)
        expect(parsed.heading_degrees_true).to eq(1.2)
        expect(parsed.valid?).to eq(true)
        expect(parsed.course_degrees_true).to eq(2.3)
        expect(parsed.course_reference).to eq('cref')
        expect(parsed.vessel_speed).to eq(4.5)
        expect(parsed.speed_reference).to eq('sref')
        expect(parsed.vessel_set_degrees_true).to eq(5.6)
        expect(parsed.vessel_drift_speed).to eq(6.7)
        expect(parsed.vessel_drift_speed_units).to eq('unit')
      end
    end

    context "when reading a GSV message" do
      it "properly reports various fields" do
        input = "$GPGSV,3,1,11,03,03,111,00,04,15,270,00,06,01,010,00,13,06,292,00*74"
        parsed = @parser.parse(input)
        expect(parsed.total_messages).to eq(3)
        expect(parsed.message_number).to eq(1)
        expect(parsed.satellites).to eq(11)
        expect(parsed.satellite1_prn).to eq(3)
        expect(parsed.satellite1_elevation_degrees).to eq(3)
        expect(parsed.satellite1_azimuth_degrees).to eq(111)
        expect(parsed.satellite1_snr).to eq(0)
        expect(parsed.satellite2_prn).to eq(4)
        expect(parsed.satellite2_elevation_degrees).to eq(15)
        expect(parsed.satellite2_azimuth_degrees).to eq(270)
        expect(parsed.satellite2_snr).to eq(0)
        expect(parsed.satellite3_prn).to eq(6)
        expect(parsed.satellite3_elevation_degrees).to eq(1)
        expect(parsed.satellite3_azimuth_degrees).to eq(10)
        expect(parsed.satellite3_snr).to eq(0)
        expect(parsed.satellite4_prn).to eq(13)
        expect(parsed.satellite4_elevation_degrees).to eq(6)
        expect(parsed.satellite4_azimuth_degrees).to eq(292)
        expect(parsed.satellite4_snr).to eq(0)
      end
    end

    context "when reading a GTD message" do
      it "properly reports various fields" do
        input = "$GPGTD,1.1,2.2,3.3,4.4,5.5*00"
        parsed = @parser.parse(input)
        expect(parsed.difference1).to eq(1.1)
        expect(parsed.difference2).to eq(2.2)
        expect(parsed.difference3).to eq(3.3)
        expect(parsed.difference4).to eq(4.4)
        expect(parsed.difference5).to eq(5.5)
      end
    end

    # context "when reading a  message" do
    #   it "properly reports various fields" do
    #     input = ""
    #     parsed = @parser.parse(input)
    #     expect(parsed.).to eq()
    #   end
    # end

  end
end
