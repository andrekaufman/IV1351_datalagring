package se.kth.soundgood.view;

import se.kth.soundgood.controller.RentalController;

import java.util.Scanner;

public class CommandInterpreter {
    private RentalController controller;

    public CommandInterpreter(RentalController controller) {
        this.controller = controller;
    }

    public void handleCommands() {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.print("> ");
            String input = scanner.nextLine();
            String[] parts = input.split(" ");
            String command = parts[0].toLowerCase();

            try {
                switch (command) {
                    case "help":
                        System.out.println("Commands:");
                        System.out.println("  list [type]: List all available instruments of a type.");
                        System.out.println("  rent [student-id] [instrument-id]: Rent an instrument.");
                        System.out.println("  terminate [student-id] [instrument-id]: Terminate a rental.");
                        System.out.println("  quit: Exit the application.");
                        break;
                    case "list":
                        controller.listAvailableInstruments(parts[1]).forEach(System.out::println);
                        break;
                        case "rent":
                        controller.rentInstrument(
                            Integer.parseInt(parts[1]), // student_id
                            Integer.parseInt(parts[2])  // instrument_id
                        );
                        System.out.println("Instrument rented successfully.");
                        break;
                    
                        case "terminate":
                        controller.terminateRental(
                            Integer.parseInt(parts[1]), // student_id
                            Integer.parseInt(parts[2])  // instrument_id
                        );
                        System.out.println("Rental terminated successfully.");
                        break;
                    case "quit":
                        return;
                    default:
                        System.out.println("Unknown command.");
                }
            } catch (Exception e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
    }
}
