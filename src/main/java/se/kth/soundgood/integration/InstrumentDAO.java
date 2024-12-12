package se.kth.soundgood.integration;

import se.kth.soundgood.model.Instrument;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InstrumentDAO {
    private Connection connection;

    public InstrumentDAO() throws SQLException {
        connection = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/soundgooddb", "postgres", "postgres");
        connection.setAutoCommit(false);
    }

    /**
     * Retrieves a list of all available instruments of a specified type. 
     * @param type Type of instrument
     * @return A list of available instruments.
     * @throws SQLException If a database access error occurs.
     */
    public List<Instrument> ReadAvailableInstruments(String type) throws SQLException {
        String query = "SELECT instrument_id, instrument_brand, rental_price " +
                       "FROM instrument WHERE instrument_type ILIKE ? AND is_available = true";
        PreparedStatement stmt = connection.prepareStatement(query);
        stmt.setString(1, type);
        ResultSet rs = stmt.executeQuery();
    
        List<Instrument> instruments = new ArrayList<>();
        while (rs.next()) {
            instruments.add(new Instrument(
                rs.getInt("instrument_id"),
                rs.getString("instrument_brand"),
                rs.getDouble("rental_price")
            ));
        }
        return instruments;
    }
    


    /**
     * Updates the availability of an instrument.
     * @param instrumentId The ID of the instrument to update.
     * @param isAvailable True if the instrument should be marked as available, false otherwise.
     * @throws SQLException If there's a database access error
     */
    public void updateInstrumentAvailability(int instrumentId, boolean isAvailable) throws SQLException {
        String query = "UPDATE instrument SET is_available = ? WHERE instrument_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setBoolean(1, isAvailable);
            stmt.setInt(2, instrumentId);
            stmt.executeUpdate();
            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        }
    }
}
    
