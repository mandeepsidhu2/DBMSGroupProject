package controller;

import entity.User;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;
import model.HotelModel;
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
  private final String dbName = "final_project";
  private final View view;
  private final UserModel userModel;
  private final HotelModel hotelModel;
  Scanner reader = new Scanner(System.in);
  private User currentUserContext;
  private Connection connection = null;

  public HotelManagementSystem(String userName, String password) throws Exception {
    view = new View();
    currentUserContext = null;

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
      hotelModel = new HotelModel(procedureExecutor);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      throw new Exception("Invalid username or password was entered, try again\n");
    }
  }

  public void closeConnection() throws SQLException {
    this.connection.close();
  }

  public void manageUserBookings() {
    //todo
  }

  public void viewUserHotelOptions() {

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

  public void loggedInUserJourney() {
    List<Integer> options = this.view.printLoggedInUserJourneyOptions();
    Integer option = inputAnIntFromUser();
    if (!options.contains(option)) {
      this.view.printInvalidOptionSelected();
      loggedInUserJourney();
      return;
    }
    switch (option) {
      case 1:
        manageUserBookings();
        break;
      case 2:
        viewUserHotelOptions();
        break;
      case 3:
        this.currentUserContext = null;
        startUserLoginProcess();
        System.out.println("Logged out!");
        break;
    }
  }


  public User startUserSignupProcess(String ssn) {
    System.out.println("Enter name");
    String name = reader.nextLine();

    System.out.println("Enter phone");
    String phone = reader.nextLine();

    System.out.println("Enter email");
    String email = reader.nextLine();

    System.out.println("Enter age");
    Integer age = inputAnIntFromUser();

    User userToCreate = new User().toBuilder().age(age).email(email).phone(phone).name(name)
        .ssn(ssn).build();
    userModel.createUser(userToCreate);
    System.out.println("Signed up... ");
    return this.userModel.getUserBySSN(ssn);
  }

  public void startUserLoginProcess() {
    System.out.println("Enter ssn or press x to go back");
    String ssn = reader.nextLine();
    if (ssn.equals("x")) {
      run();
      return;
    }
    User user = userModel.getUserBySSN(ssn);
    if (user == null) {
      System.out.println("User doesn't exist please signup first");
      user = startUserSignupProcess(ssn);
    }
    System.out.println("Congratulations, you are now logged in as " + user.getName());
    this.currentUserContext = user;
    loggedInUserJourney();
  }

  /**
   * Connect to MySQL and do some stuff.
   */
  public void run() {
    List<Integer> ops = view.firstMessageToUser();
    Integer optionSelected = inputAnIntFromUser();
    if (!ops.contains(optionSelected)) {
      System.out.println("Invalid input");
      run();
      return;
    }
    switch (optionSelected) {
      case 1:
        startUserLoginProcess();
        break;
      case 2:
        // todo hotel view
        break;
      case 3:
        return;
    }


  }


}
