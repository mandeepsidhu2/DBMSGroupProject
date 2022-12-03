package entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder(toBuilder = true)
public class Staff {

  private Integer staffId;
  private String name;
  private String phone;
  private String email;
  private String ssn;
  private Integer isManager;
  private Integer isContractStaff;
  private String contractStartDate;
  private String contractEndDate;
  private Integer hotelId;

}
