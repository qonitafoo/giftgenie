package model;

import java.util.List;

public class Product {
    private int id;
    private String name;
    private double price;
    private String description;
    private String image;
    private String occasion;
    private List<String> moments; // NEW

    public Product(int id, String name, double price, String description, String image, String occasion, List<String> moments) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.image = image;
        this.occasion = occasion;
        this.moments = moments;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getDescription() { return description; }
    public String getImage() { return image; }
    public String getOccasion() { return occasion; }

    public List<String> getMoments() { return moments; } // NEW
}