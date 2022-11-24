package entity;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class Booking extends Hotel {

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
