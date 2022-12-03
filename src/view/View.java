package view;

import java.util.Arrays;
import java.util.List;

public class View {

  public List<Integer> firstMessageToUser() {
    System.out.println("Welcome to the portal!");
    System.out.println("What would you like to do?\n(1) Login as a user");
    System.out.println("(2) Login as hotel staff");
    System.out.println("(3) Press 3 to exit");
    System.out.println("Press 1, 2 or 3");
    return Arrays.asList(1, 2, 3);
  }

  public void printExpectedIntegerMessage() {
    System.out.println("Invalid integer entered!");
  }

  public void printInvalidOptionSelected() {
    System.out.println("Invalid option selected!");
  }

  public List<Integer> printLoggedInUserJourneyOptions() {
    System.out.println("\nWhat would you like to do?");
    System.out.println("(1) View your bookings");
    System.out.println("(2) View currently available hotels");
    System.out.println("(3) Get availability by date");
    System.out.println("(4) Logout");
    System.out.println("Press 1, 2 , 3 or 4");
    return Arrays.asList(1, 2, 3, 4);
  }

}
