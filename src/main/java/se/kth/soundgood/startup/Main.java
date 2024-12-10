package se.kth.soundgood.startup;

import se.kth.soundgood.controller.RentalController;
import se.kth.soundgood.view.CommandInterpreter;

public class Main {
    public static void main(String[] args) {
        try {
            RentalController controller = new RentalController();
            new CommandInterpreter(controller).handleCommands();
        } catch (Exception e) {
            System.out.println("Error starting application: " + e.getMessage());
        }
    }
}
 