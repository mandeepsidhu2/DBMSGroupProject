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

  private String ssn;
  private String name;
  private String phone;
  private String email;
  private Integer age;
  private Integer customerId;

}
