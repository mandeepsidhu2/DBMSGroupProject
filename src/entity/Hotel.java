package entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder(toBuilder = true)
public class Hotel {

  public Integer id;
  public String name;
  public String street;
  public String town;
  public String state;
  public String zip;
  public Float avgRating;
  public String phone;
  public String email;


}
