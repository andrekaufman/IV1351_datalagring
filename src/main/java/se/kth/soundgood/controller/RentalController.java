package se.kth.soundgood.controller;

import se.kth.soundgood.integration.InstrumentDAO;
import se.kth.soundgood.integration.RentalDAO;
import se.kth.soundgood.model.Instrument;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RentalController {
    private final Connection connection;
    private final InstrumentDAO instrumentDAO;
    private final RentalDAO rentalDAO;

    public RentalController() throws SQLException {
        connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgooddb", "postgres", "postgres");
        connection.setAutoCommit(false); 
        instrumentDAO = new InstrumentDAO(connection);
        rentalDAO = new RentalDAO(connection);
    }

    private void beginTransaction() throws SQLException {
        connection.setAutoCommit(false);
    }

    private void commitTransaction() throws SQLException {
        connection.commit();
    }

    private void rollbackTransaction() throws SQLException {
        connection.rollback();
    }

public List<Instrument> listAvailableInstruments(String type) throws SQLException {
    try { 
        beginTransaction();
        List<Instrument> instruments = instrumentDAO.readInstrumentsByType(type);
        List<Instrument> availableInstruments = new ArrayList<>();

        for (Instrument instrument : instruments) {
            try (ResultSet rs = instrumentDAO.readInstrumentAvailability(instrument.getId())) {
                if (rs.next() && rs.getBoolean("is_available")) {
                    availableInstruments.add(instrument);
                }
            } catch (SQLException e) {
                throw new RuntimeException(e.getMessage());
            }
        }

        commitTransaction();
        return availableInstruments;
    } catch (SQLException e) {
        rollbackTransaction();
        throw e;
    }
}

    public void rentInstrument(int studentId, int instrumentId) throws SQLException {
        try { 
            beginTransaction();
    
            //business logic such as rental quota limit and 12 month check are enforced by db triggers
            
            
            try (ResultSet rs = instrumentDAO.readInstrumentAvailability(instrumentId)) { //(redundant, also a trigger)
                if (!rs.next() || !rs.getBoolean("is_available")) {
                    throw new SQLException("Instrument already rented.");
                }
            }
    
            rentalDAO.createRental(studentId, instrumentId);
            instrumentDAO.updateInstrumentAvailability(instrumentId, false);
    
            commitTransaction();
        } catch (SQLException e) { 
            rollbackTransaction();
            throw e;
        }
    }

    public void terminateRental(int studentId, int instrumentId) throws SQLException {
        try {
            beginTransaction();
    
            int rowsUpdated = rentalDAO.updateRentalEnd(studentId, instrumentId);
            if (rowsUpdated == 0) {
                throw new SQLException("No active rental found for the given student and instrument.");
            }
    
            instrumentDAO.updateInstrumentAvailability(instrumentId, true);
    
            commitTransaction();
        } catch (SQLException e) {
            rollbackTransaction();
            throw e;
        }
    }
}