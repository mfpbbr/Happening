module GeoHelper
  RADIANS_PER_DEGREE = Math::PI / 180
  RADIUS_OF_EARTH_IN_KMS = 6371
  KMS_PER_MILE = 1.6

  def haversine_distance_internal(lat1, lon1, lat2, lon2, type = :mile)
    delta_lat = (lat2 - lat1) * RADIANS_PER_DEGREE
    delta_lon = (lon2 - lon1) * RADIANS_PER_DEGREE

    a = Math.sin(delta_lat / 2) ** 2 + 
        Math.cos(lat1 * RADIANS_PER_DEGREE) * 
        Math.cos(lat2 * RADIANS_PER_DEGREE) *
        Math.sin(delta_lon / 2) ** 2

    c  = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    distance_in_kms = RADIUS_OF_EARTH_IN_KMS * c

    if type == :mile
      return distance_in_kms / KMS_PER_MILE
    else
      return distance_in_kms
    end
  end

  def haversine_distance(source_coordinates, dest_coordinates, type = :mile)
    return haversine_distance_internal(source_coordinates[1], source_coordinates[0], dest_coordinates[1], dest_coordinates[0], type)
  end

end
