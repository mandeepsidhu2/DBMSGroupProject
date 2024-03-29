package model;

import entity.User;
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
      Integer customerId = Integer.valueOf(resultSetFromProcedure.getString("customer_id"));
      String ssn = resultSetFromProcedure.getString("ssn");
      Integer age = Integer.valueOf(resultSetFromProcedure.getString("age"));
      String phone = resultSetFromProcedure.getString("phone");
      String name = resultSetFromProcedure.getString("name");
      String email = resultSetFromProcedure.getString("email");

      User user = new User().toBuilder().age(age).email(email).name(name).customerId(customerId)
          .ssn(ssn)
          .phone(phone).build();
      list.add(user);
    }
    return list;
  }

  public void createUser(User user) throws SQLException {
    String query = "call createUser(?,?,?,?,?)";
    try {
      procedureExecutor.preparedStatement(query)
          .setStatementParam(1, user.getSsn())
          .setStatementParam(2, user.getName())
          .setStatementParam(3, user.getEmail())
          .setStatementParam(4, user.getPhone())
          .setStatementParam(5, user.getAge().toString())
          .execute();
      procedureExecutor.cleanup();
    } catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }

    System.out.println("User saved");
  }

  public User getUserBySSN(String ssn) throws SQLException {
    String query = "call getUserBySSN(?)";
    ResultSet resultSet;
    try {
      resultSet = procedureExecutor.preparedStatement(query).setStatementParam(1, ssn)
          .execute();
    } catch (Exception e) {
      procedureExecutor.cleanup();
      throw e;
    }

    List<User> users;
    try {
      users = getFromIterator(resultSet);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      return null;
    }
    procedureExecutor.cleanup();
    if (users.size() == 0) {
      return null;
    } else {
      return users.get(0);
    }

  }


}
