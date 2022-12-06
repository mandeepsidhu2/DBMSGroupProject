package entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder(toBuilder = true)
public class HotelAvailability {

  private Integer hotelId;
  private String roomCategory;
  private Integer availableRooms;
}
