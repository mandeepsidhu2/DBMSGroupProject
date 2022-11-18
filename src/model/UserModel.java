package model;

import entity.User;
import entity.User.UserBuilder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserModel {

  ProcedureExecutor procedureExecutor;

  public UserModel(ProcedureExecutor procedureExecutor) {
    this.procedureExecutor = procedureExecutor;
  }

  List<User> getFromIterator(ResultSet resultSetFromProcedure) throws SQLException {
    List<User> list = new ArrayList<>();
    while (resultSetFromProcedure.next()) {
      Integer customerId = Integer.valueOf(resultSetFromProcedure.getString("customerId"));
      String ssn = resultSetFromProcedure.getString("ssn");
      Integer age = Integer.valueOf(resultSetFromProcedure.getString("age"));
      String phone = resultSetFromProcedure.getString("phone");
      String name = resultSetFromProcedure.getString("name");
      String email = resultSetFromProcedure.getString("email");

      User user = new UserBuilder().age(age).email(email).name(name).customerId(customerId).ssn(ssn)
          .phone(phone).build();
      list.add(user);
    }
    return list;
  }

  public void createUser(User user) {
    String query = "call createUser(?,?,?,?,?)";
    procedureExecutor.preparedStatement(query)
        .setStatementParam(1, user.getSsn())
        .setStatementParam(2, user.getName())
        .setStatementParam(3, user.getEmail())
        .setStatementParam(4, user.getPhone())
        .setStatementParam(5, user.getAge().toString())
        .execute();
    System.out.println("User saved");
  }

  public User getUserBySSN(String ssn) {
    String query = "call getUserBySSN(?)";
    ResultSet resultSet = procedureExecutor.preparedStatement(query).setStatementParam(1, ssn)
        .execute();
    List<User> users;
    try {
      users = getFromIterator(resultSet);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      return null;
    }
    if (users.size() == 0) {
      return null;
    } else {
      return users.get(0);
    }

  }


}
