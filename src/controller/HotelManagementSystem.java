package controller;

import entity.User;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;
import model.Hotel;
import model.ProcedureExecutor;
import model.UserModel;
import view.View;

public class HotelManagementSystem {

  /**
   * The name of the MySQL account to use (or empty for anonymous)
   */
  private final String userName;
  /**
   * The password for the MySQL account (or empty for anonymous)
   */
  private final String password;
  /**
   * The name of the computer running MySQL
   */
  private final String serverName = "localhost";
  /**
   * The port of the MySQL server (default is 3306)
   */
  private final int portNumber = 3306;
  /**
   * The name of the database of sharks
   */
  private final String dbName = "sharkdbsidhum";
  private final View view;
  private final UserModel userModel;
  private final Hotel hotelModel;
  Scanner reader = new Scanner(System.in);
  private Connection connection = null;

  public HotelManagementSystem(String userName, String password) throws Exception {
    view = new View();

    this.userName = userName;
    this.password = password;
    try {
      Properties connectionProps = new Properties();
      connectionProps.put("user", this.userName);
      connectionProps.put("password", this.password);

      this.connection = DriverManager.getConnection("jdbc:mysql://"
              + this.serverName + ":" + this.portNumber + "/" + this.dbName
              + "?characterEncoding=UTF-8&useSSL=false",
          connectionProps);
      System.out.println("Congratulations, you are now connected to database");
      ProcedureExecutor procedureExecutor = new ProcedureExecutor(connection);
      userModel = new UserModel(procedureExecutor);
      hotelModel = new Hotel(procedureExecutor);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      throw new Exception("Invalid username or password was entered, try again\n");
    }
  }

  public void closeConnection() throws SQLException {
    this.connection.close();
  }

  private Integer inputAnIntFromUser() {
    int action;
    try {
      action = reader.nextInt();
      // consume the \n after the int
      reader.nextLine();
      return action;
    } catch (Exception e) {
      this.view.printExpectedIntegerMessage();
      reader.nextLine();
      throw e;
    }
  }

  public void startUserSignupProcess() {
    System.out.println("Enter ssn");
    String ssn = reader.nextLine();

    System.out.println("Enter ssn");
    String name = reader.nextLine();

    System.out.println("Enter phone");
    String phone = reader.nextLine();

    System.out.println("Enter email");
    String email = reader.nextLine();

    System.out.println("Enter age");
    Integer age = inputAnIntFromUser();


  }

  public void startUserLoginProcess() {
    System.out.println("Enter ssn");
    String ssn = reader.nextLine();
    User user = userModel.getUserBySSN(ssn);
    if (user == null) {
      System.out.println("User doesn't exist please signup");
    }
  }

  /**
   * Connect to MySQL and do some stuff.
   */
  public void run() throws Exception {
    view.firstMessageToUser();
    Integer optionSelected = inputAnIntFromUser();
    if (optionSelected != 1 && optionSelected != 2) {
      System.out.println("Invalid input");
      run();
      return;
    }
    if (optionSelected == 1) {
      startUserLoginProcess();
    }

  }

}
