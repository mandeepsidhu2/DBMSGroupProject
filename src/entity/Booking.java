package entity;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder(toBuilder = true)
public class Booking {
  private Integer customerId;
  private Integer bookingId;
  private Integer hotelId;
  private Integer checkedInByStaffId;
  private Integer checkedOutByStaffId;
  private Boolean isCheckedIn;
  private Boolean isCheckedOut;
  private Date startDate;
  private Date endDate;
  private Integer rating;
  private String ratingDescription;
  private Integer roomNo;
}
