package entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;


@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class Hotel {

  private Integer id;
  private String name;
  private String street;
  private String town;
  private String state;
  private String zip;
  private Float avgRating;
  private String phone;
  private String email;


}
