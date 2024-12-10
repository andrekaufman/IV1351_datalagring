package se.kth.soundgood.model;

public class Student {
    private int id;
    private String name;
    private String email;
    private String phone;
    private String address;

    public Student(int id, String name, String email, String phone, String address) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getAddress() {
        return address;
    }

    @Override
    public String toString() {
        return "Student ID: " + id + ", Name: " + name + 
               ", Email: " + email + ", Phone: " + phone + 
               ", Address: " + address;
    }
}
