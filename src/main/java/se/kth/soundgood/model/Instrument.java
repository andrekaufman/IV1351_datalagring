package se.kth.soundgood.model;

public class Instrument {
    private int id;
    private String brand;
    private double rentalPrice;

    public Instrument(int id, String brand, double rentalPrice) {
        this.id = id;
        this.brand = brand;
        this.rentalPrice = rentalPrice;
    }

    public int getId() {
        return id;
    }

    public String getBrand() {
        return brand;
    }

    public double getRentalPrice() {
        return rentalPrice;
    }

    @Override
    public String toString() {
        return "Instrument ID: " + id + ", Brand: " + brand + ", Price: " + rentalPrice;
    }
}
