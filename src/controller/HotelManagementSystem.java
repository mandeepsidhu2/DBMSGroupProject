package controller;

import entity.Booking;
import entity.HotelAvailability;
import entity.HotelWithAmenities;
import entity.Occupant;
import entity.User;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;
import java.util.stream.Collectors;
import model.BookingModel;
import model.HotelModel;
import model.OccupantModel;
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

  private final BookingModel bookingModel;

  private final OccupantModel occupantModel;

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
      bookingModel = new BookingModel(procedureExecutor);
      occupantModel = new OccupantModel(procedureExecutor);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      throw new Exception("Invalid username or password was entered, try again\n");
    }
  }

  public void closeConnection() throws SQLException {
    this.connection.close();
  }

  private void printBookingDetails(Booking booking) {
    String startDate = new SimpleDateFormat("dd-MM-yyyy").format(booking.getStartDate());
    String endDate = new SimpleDateFormat("dd-MM-yyyy").format(booking.getEndDate());

    System.out.println(booking.getBookingId() + "             " + booking.getHotelId() + "      "
        + startDate + "    " + endDate + "      " + booking.getName() + ", " + booking.getTown()
        + ", " + booking.getState());
  }


  public void manageUserBookings() {
    List<Booking> bookingList = null;
    try {
      bookingList = this.bookingModel.getBookingsForARoom(this.currentUserContext.getCustomerId());
    } catch (Exception e) {
      System.out.println("Unable to fetch bookings");
      loggedInUserJourney();
      return;
    }
    if (bookingList.size() == 0) {
      System.out.println("No bookings to display");
      loggedInUserJourney();
      return;
    }
    List<Booking> futureBookings = bookingList.stream()
        .filter(b -> !b.getIsCheckedIn() && !b.getIsCheckedOut()).collect(
            Collectors.toList());
    Collections.sort(futureBookings, Comparator.comparingInt(Booking::getBookingId));

    List<Booking> checkedInBookings = bookingList.stream()
        .filter(b -> b.getIsCheckedIn() && !b.getIsCheckedOut()).collect(
            Collectors.toList());
    List<Booking> pastBookings = bookingList.stream()
        .filter(b -> b.getIsCheckedIn() && b.getIsCheckedOut()).collect(
            Collectors.toList());

    if (pastBookings.size() > 0) {
      System.out.println("Past bookings:");
      System.out.println("BookingId | HotelId | StartDate   | EndDate   | Hotel Details");
      for (Booking booking : pastBookings) {
        printBookingDetails(booking);
      }
    }

    if (checkedInBookings.size() > 0) {
      System.out.println("Checked in bookings:");
      System.out.println("BookingId | HotelId | StartDate   | EndDate   | Hotel Details");
      for (Booking booking : checkedInBookings) {
        printBookingDetails(booking);
      }
    }

    if (futureBookings.size() > 0) {
      System.out.println("Future bookings:");
      System.out.println("BookingId | HotelId | StartDate   | EndDate   | Hotel Details");
      for (Booking booking : futureBookings) {
        printBookingDetails(booking);
      }
    }

    if (futureBookings.size() > 0 || pastBookings.size() > 0) {
      System.out.println(
          "Enter a booking id you would like to modify, any other key to exit");
      Integer bookingId;
      try {
        bookingId = inputAnIntFromUser();
        if (futureBookings.stream().filter(booking -> booking.getBookingId()
            .equals(bookingId)).collect(Collectors.toList()).size() == 0 &&
            pastBookings.stream().filter(booking -> booking.getBookingId()
                .equals(bookingId)).collect(Collectors.toList()).size() == 0
        ) {
          throw new IllegalArgumentException("Invalid booking id entered");
        }
      } catch (Exception e) {
        System.out.println("Invalid input");
        loggedInUserJourney();
        return;
      }
      if (futureBookings.stream().filter(booking -> booking.getBookingId()
          .equals(bookingId)).collect(Collectors.toList()).size() != 0) {
        Booking bookingToModify = futureBookings.stream().filter(booking -> booking.getBookingId()
            .equals(bookingId)).collect(Collectors.toList()).get(0);
        modifyFutureBooking(bookingToModify);
      } else if (pastBookings.stream().filter(booking -> booking.getBookingId()
          .equals(bookingId)).collect(Collectors.toList()).size() != 0) {
        Booking bookingToModify = pastBookings.stream().filter(booking -> booking.getBookingId()
            .equals(bookingId)).collect(Collectors.toList()).get(0);
        modifyPastBooking(bookingToModify);
      }
      return;
    }
  }

  private void cancelBooking(Integer bookingId) {
    try {
      this.bookingModel.deleteBooking(bookingId);
    } catch (Exception e) {
      System.out.println("Unable to delete booking due to error " + e.getMessage());
      return;
    }
    System.out.println("The booking has been deleted successfully");
  }

  private void deleteOccupantFromBooking(Integer bookingId) {
    System.out.println("Enter the ssn of the occupant you want to delete");
    String ssn = reader.nextLine();
    try {
      this.occupantModel.deleteOccupantFromBooking(ssn, bookingId);
      System.out.println("Occupant deleted!!");
    } catch (Exception e) {
      System.out.println("Unable to delete occupant due to error -> " + e.getMessage());
      return;
    }
  }

  private void updateBookingDates(Integer bookingId) {
    System.out.println("Enter the new start date(yyyy-MM-dd)");
    String startDateString = reader.nextLine();
    Date startDate = null;
    try {
      startDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
    } catch (Exception e) {
      System.out.println("Invalid start date entered!");
      return;
    }

    System.out.println(
        "Enter the new end date(in yyyy-MM-dd format)...");
    String endDateString = reader.nextLine();
    Date endDate = null;
    try {
      endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endDateString);
    } catch (Exception e) {
      System.out.println("Invalid end date entered!");
      return;
    }
    try {
      this.bookingModel.updateBookingDates(startDate, endDate, bookingId);
    } catch (Exception e) {
      System.out.println("Unable to modify booking due to error-> " + e.getMessage());
      return;
    }
    System.out.println("The booking has been updated");
  }

  private void modifyPastBooking(Booking booking) {
    System.out.println("\n");
    System.out.println("Details for booking id -> " + booking.getBookingId());
    System.out.println(
        "Booking start date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getStartDate()));
    System.out.println(
        "Booking end date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getEndDate()));
    System.out.println("What rating would you like to give for your stay");
    Float rating = inputAnFloatFromUser();
    try {
      this.bookingModel.updateBookingRating(rating, booking.getBookingId());
      System.out.println("Rating added, thanks for the feedback");

    } catch (Exception e) {
      System.out.println("Unable to add rating due to error ->" + e.getMessage());
    }
    manageUserBookings();
  }

  private void modifyFutureBooking(Booking booking) {
    System.out.println("\n");
    System.out.println("Details for booking id -> " + booking.getBookingId());
    System.out.println(
        "Booking start date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getStartDate()));
    System.out.println(
        "Booking end date (dd-MM-yyyy)-> " + new SimpleDateFormat("dd-MM-yyyy").format(
            booking.getEndDate()));

    List<Occupant> occupantList;
    try {
      occupantList = this.occupantModel.getOccupantDetailsForBooking(booking.getBookingId());
      if (occupantList.size() > 0) {
        System.out.println("Details of occupants are: ");
        System.out.println("Occupant Name | Occupant SSN | Occupant Age");
        for (Occupant occupant : occupantList) {
          System.out.println(
              occupant.getName() + "               " + occupant.getSsn() + "               "
                  + occupant.getAge());
        }
      } else {
        System.out.println("Occupants have currently not been added");
      }

    } catch (Exception e) {
      System.out.println("Error in fetching occupant list" + e.getMessage());
    }

    System.out.println();
    System.out.println("What operation would you like to perform");
    System.out.println("(1)Cancel this this booking");
    System.out.println("(2)Add more occupants");
    System.out.println("(3)Delete occupants");
    System.out.println("(4)Update booking");
    System.out.println("(5)Go back");
    Integer option;
    try {
      option = inputAnIntFromUser();
    } catch (Exception e) {
      System.out.println("Invalid option entered");
      modifyFutureBooking(booking);
      return;
    }
    switch (option) {
      case 1:
        cancelBooking(booking.getBookingId());
        manageUserBookings();
        break;
      case 2:
        addOccupantsToBooking(booking.getBookingId());
        manageUserBookings();
        break;
      case 3:
        deleteOccupantFromBooking(booking.getBookingId());
        manageUserBookings();
        break;
      case 4:
        updateBookingDates(booking.getBookingId());
        manageUserBookings();
        break;
      case 5:
        manageUserBookings();
        break;
    }

  }

  private void getHotelAvailabilityForAHotelForInputDates(HotelWithAmenities hotel, Date startDate,
      Date endDate) {
    List<HotelAvailability> hotelAvailabilities;
    try {
      hotelAvailabilities = this.hotelModel.
          getCategoryWiseHotelAvailabilitiesMapForDate(hotel, startDate, endDate);
    } catch (Exception e) {
      displayHotelDetailPage(hotel);
      return;
    }

    if (hotelAvailabilities.size() == 0) {
      System.out.println("Sorry no availabilities for given dates! Try a different hotel");
      displayHotelDetailPage(hotel);
      return;
    }
    System.out.println("Room Option |  Room Type  |  Rooms available");
    Integer idx = 0;
    System.out.println();

    for (HotelAvailability hotelAvailability : hotelAvailabilities) {
      System.out.println(
          "(" + (idx + 1) + ") | " + hotelAvailability.getRoomCategory() + "     |     "
              + hotelAvailability.getAvailableRooms());
      idx++;
    }
    System.out.println("Select the room type you would like to book between 1 and " + idx + ""
        + "\nPress any other key to go back to hotel list");
    Integer optionSelected = -1;
    try {
      optionSelected = inputAnIntFromUser();
    } catch (Exception ex) {
      displayHotelDetailPage(hotel);
      return;
    }
    if (optionSelected < 0 || optionSelected > hotelAvailabilities.size()) {
      System.out.println("Invalid option selected, try again");
      displayHotelDetailPage(hotel);
      return;
    }

    Integer idxOfHotelAvailabilityInArray = optionSelected - 1;
    Integer bookingId = null;
    try {
      bookingId = this.bookingModel.bookARoom(this.currentUserContext.getCustomerId(), startDate,
          endDate,
          hotel.getId(),
          hotelAvailabilities.get(idxOfHotelAvailabilityInArray).getRoomCategory()
      );
    } catch (Exception e) {
      System.out.println("Unable to book a room due to error-> " + e.getMessage());
      System.out.println("Please try again");
      displayHotelDetailPage(hotel);
      return;
    }
    System.out.println("Congratulations booking created!!");
    System.out.println("To add occupants to the booking, press y, any other key to add later");
    System.out.println("[Occupants can be added in manage bookings section]");
    String userInput = reader.nextLine();
    if (userInput.equals("y")) {
      addOccupantsToBooking(bookingId);
    } else {
      manageUserBookings();
    }
  }

  void addOccupantsToBooking(Integer bookingId) {
    System.out.println("Enter occupant ssn");
    String ssn = reader.nextLine();

    System.out.println("Enter occupant name");
    String name = reader.nextLine();

    System.out.println("Enter occupant age");
    Integer age = inputAnIntFromUser();

    try {
      this.occupantModel.addOccupantToABooking(bookingId, ssn, name, age);
    } catch (Exception e) {
      System.out.println("Unable to create a booking due to error " + e.getMessage());
      manageUserBookings();
      return;
    }
    System.out.println("Occupant added");

    System.out.println("To continue occupants to the booking, press y, any other key to add later");
    System.out.println("[Occupants can be added in manage bookings section]");
    String userInput = reader.nextLine();
    if (userInput.equals("y")) {
      addOccupantsToBooking(bookingId);
      return;
    }
  }

  private void displayHotelDetailPage(HotelWithAmenities hotel) {
    System.out.println("Welcome to hotel " + hotel.getName());
    System.out.println(hotel.getStreet() + ", " + hotel.getTown() + ", " + hotel.getState());

    System.out.println(
        "Enter the start date for the booking you want to create(in YYYY-MM-DD format)...");
    String startDateString = reader.nextLine();
    Date startDate = null;
    try {
      startDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateString);
    } catch (Exception e) {
      System.out.println("Invalid start date entered!");
      displayHotelDetailPage(hotel);
      return;
    }

    System.out.println(
        "Enter the end date for the booking you want to create(in YYYY-MM-DD format)...");
    String endDateString = reader.nextLine();
    Date endDate = null;
    try {
      endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endDateString);
    } catch (Exception e) {
      System.out.println("Invalid end date entered!");
      displayHotelDetailPage(hotel);
      return;
    }
    getHotelAvailabilityForAHotelForInputDates(hotel, startDate, endDate);

  }

  public void viewUserHotelOptions(Boolean getAvailabilityToday) {
    Date dateToQuery = new Date();
    if (!getAvailabilityToday) {
      System.out.println("Please enter date in format YYYY-MM-DD");
      String dateInput = reader.nextLine();
      try {
        dateToQuery = new SimpleDateFormat("yyyy-MM-dd").parse(dateInput);
      } catch (Exception e) {
        System.out.println("Invalid date enetred!");
        viewUserHotelOptions(false);
        return;
      }
    }
    List<HotelWithAmenities> hotelWithAmenities = null;
    try {
      hotelWithAmenities = hotelModel.getAllAvailableHotelsWithAmenities(
          dateToQuery);
    } catch (Exception e) {
      viewUserHotelOptions(getAvailabilityToday);
      System.out.println("Unable to load hotel details");
      return;
    }
    String s = "Id |Name        | AvgRating  |  Email        |  Phone          | Available Rooms | State| Town  | Street         | Amenities                   | Amenities Description";
    s = String.join("\u0332", s.split("", -1));
    System.out.println(s);
    for (HotelWithAmenities hotel : hotelWithAmenities) {
      String rating = hotel.getAvgRating() == 0 ? "N.A." : hotel.getAvgRating().toString();
      System.out.println(
          hotel.getId() + " | " + hotel.getName() + " | " + rating + " | " + hotel.getEmail()
              + " | "
              + hotel.getPhone() + " |  " + hotel.getTotalAvailableRooms() + " | "
              + hotel.getState()
              + "  | "
              + hotel.getTown() + " | " + hotel.getStreet() + " | " + hotel.getAmenities() + " | "
              + hotel.getAmenitiesDescription());
    }
    System.out.println("Enter a hotel id to view further details or press any other key to exit");
    Integer optionSelected;
    try {
      optionSelected = inputAnIntFromUser();
      if (hotelWithAmenities.stream()
          .filter(hotelWithAmenities1 -> hotelWithAmenities1.getId().equals(optionSelected))
          .collect(
              Collectors.toList()).size() == 0) {
        throw new IllegalArgumentException("Invalid hotel id selected");
      }
    } catch (IllegalArgumentException e) {
      System.out.println(e.getMessage());
      viewUserHotelOptions(getAvailabilityToday);
      return;
    } catch (Exception e) {
      System.out.println("Going back to previous menu");
      loggedInUserJourney();
      return;
    }
    displayHotelDetailPage(hotelWithAmenities.stream()
        .filter(hotelWithAmenities1 -> hotelWithAmenities1.getId().equals(optionSelected)).collect(
            Collectors.toList()).get(0));
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

  private Float inputAnFloatFromUser() {
    float action;
    try {
      action = reader.nextFloat();
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
        viewUserHotelOptions(true);
        break;
      case 3:
        viewUserHotelOptions(false);
        break;
      case 4:
        this.currentUserContext = null;
        startUserLoginProcess();
        System.out.println("Logged out!");
        break;
    }
  }


  public User startUserSignupProcess(String ssn) throws SQLException {
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
    try {
      User user = userModel.getUserBySSN(ssn);
      if (user == null) {
        System.out.println("User doesn't exist please signup first");
        user = startUserSignupProcess(ssn);
      }
      System.out.println("Congratulations, you are now logged in as " + user.getName());
      this.currentUserContext = user;
      loggedInUserJourney();
    } catch (Exception e) {
      System.out.println("Unable to load the user, try again");
      startUserLoginProcess();
    }
  }

  /**
   * Connect to MySQL and do some stuff.
   */
  public void run() {
//    try {
//      this.occupantModel.getOccupantDetailsForBooking(1);
//
//    }catch (Exception e){
//      System.out.println(e.getMessage());
//    }
    List<Integer> ops = view.firstMessageToUser();
    Integer optionSelected = -1;
    try {
      optionSelected = inputAnIntFromUser();
    } catch (Exception ex) {
      System.out.println("Invalid input");
      run();
      return;
    }
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
