package se.kth.soundgood.controller;

import se.kth.soundgood.integration.InstrumentDAO;
import se.kth.soundgood.integration.RentalDAO;
import se.kth.soundgood.model.Instrument;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class RentalController {
    private final InstrumentDAO instrumentDAO;
    private final RentalDAO rentalDAO;

    public RentalController() throws SQLException {
        instrumentDAO = new InstrumentDAO();
        rentalDAO = new RentalDAO();
    }

    public List<Instrument> listAvailableInstruments(String type) throws SQLException {
        return instrumentDAO.ReadAvailableInstruments(type);
    }

    /**
     * Handles the rental process by performing all necessary validations
     * and inserting the rental record if valid.
     *
     * @param studentId    The ID of the student renting the instrument.
     * @param instrumentId The ID of the instrument being rented.
     * @throws SQLException If the rental quota is exceeded or the instrument is already rented.
     */
    public void rentInstrument(int studentId, int instrumentId) throws SQLException {
        // Validate rental quota
        ResultSet studentRentals = rentalDAO.ReadStudentRentals(studentId);
        int rentalCount = 0;
        while (studentRentals.next()) {
            rentalCount++;
        }
        if (rentalCount >= 2) {
            throw new SQLException("Rental limit exceeded. A student cannot rent more than 2 instruments.");
        }

        // Validate availability
        ResultSet instrumentRental = rentalDAO.ReadInstrumentRental(instrumentId);
        if (instrumentRental.next()) {
            throw new SQLException("Instrument is already rented to another student.");
        }

        // Insert the rental record and update instrument availability
        rentalDAO.CreateRental(studentId, instrumentId);
        instrumentDAO.updateInstrumentAvailability(instrumentId, false);
    }

    /**
     * Handles the termination of a rental and updates the instrument's availability.
     *
     * @param studentId    The ID of the student ending the rental.
     * @param instrumentId The ID of the instrument being returned.
     * @throws SQLException If no active rental is found or a database access error occurs.
     */
    public void terminateRental(int studentId, int instrumentId) throws SQLException {
        rentalDAO.UpdateRentalEnd(studentId, instrumentId);
        instrumentDAO.updateInstrumentAvailability(instrumentId, true);
    }
}
