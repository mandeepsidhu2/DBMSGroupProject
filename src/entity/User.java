package entity;

public class User {

  private final String ssn;
  private final String name;
  private final String phone;
  private final String email;
  private final Integer age;

  private final Integer customerId;


  public User(String ssn, String name, String phone, String email, Integer age,
      Integer customerId) {
    this.ssn = ssn;
    this.name = name;
    this.phone = phone;
    this.email = email;
    this.age = age;
    this.customerId = customerId;
  }

  public String getSsn() {
    return ssn;
  }

  public String getName() {
    return name;
  }

  public String getPhone() {
    return phone;
  }

  public String getEmail() {
    return email;
  }

  public Integer getAge() {
    return age;
  }

  public Integer getCustomerId() {
    return customerId;
  }

  public static class UserBuilder {

    private String ssn;

    private Integer customerId;

    private String name;
    private String phone;
    private String email;
    private Integer age;

    public User build() {
      return new User(ssn, name, phone, email, age, customerId);
    }

    public UserBuilder ssn(String ssn) {
      this.ssn = ssn;
      return this;
    }

    public UserBuilder name(String name) {
      this.name = name;
      return this;
    }

    public UserBuilder phone(String phone) {
      this.phone = phone;
      return this;
    }

    public UserBuilder email(String email) {
      this.email = email;
      return this;
    }

    public UserBuilder age(Integer age) {
      this.age = age;
      return this;
    }

    public UserBuilder customerId(Integer customerId) {
      this.customerId = customerId;
      return this;
    }
  }

}
