import controller.HotelManagementSystem;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {

  public static void main(String[] args) throws SQLException {
    HotelManagementSystem hotelManagementSystem = createAppConnection();
    hotelManagementSystem.run();
    System.out.println("\nClosing the connection to database");
    hotelManagementSystem.closeConnection();
    System.out.println("CLOSED CONNECTION");

  }

  private static HotelManagementSystem createAppConnection(){
    Scanner reader = new Scanner(System.in);

    System.out.println("Please enter the username for the database");
    String username = reader.nextLine();

    String password="";
    System.out.println("Please enter the password for the database");
    password=reader.nextLine();


    HotelManagementSystem app;
    try {
      app = new HotelManagementSystem(username,password);
    }
    catch (Exception e){
      System.out.println(e.getMessage());
      app= createAppConnection();
    }
    return app;

  }
}
