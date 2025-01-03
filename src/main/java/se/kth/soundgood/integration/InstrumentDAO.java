package se.kth.soundgood.integration;

import se.kth.soundgood.model.Instrument;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InstrumentDAO {
    private final Connection connection;

    public InstrumentDAO(Connection connection) {
        this.connection = connection;
    }

    public List<Instrument> readInstrumentsByType(String type) throws SQLException {
        String query = "SELECT instrument_id, instrument_brand, rental_price, is_available " +
                       "FROM instrument WHERE instrument_type ILIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();

            List<Instrument> instruments = new ArrayList<>();
            while (rs.next()) {
                Instrument instrument = new Instrument(
                    rs.getInt("instrument_id"),
                    rs.getString("instrument_brand"),
                    rs.getDouble("rental_price")
                );
                instruments.add(instrument);
            }
            return instruments;
        }
    }

    public ResultSet readInstrumentAvailability(int instrumentId) throws SQLException {
        String query = "SELECT is_available FROM instrument WHERE instrument_id = ? FOR UPDATE";
        PreparedStatement stmt = connection.prepareStatement(query);
        stmt.setInt(1, instrumentId);
        return stmt.executeQuery();
    }

    public void updateInstrumentAvailability(int instrumentId, boolean isAvailable) throws SQLException {
        String query = "UPDATE instrument SET is_available = ? WHERE instrument_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setBoolean(1, isAvailable);
            stmt.setInt(2, instrumentId);
            stmt.executeUpdate();
        }
    }
}