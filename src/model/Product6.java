package model;

import java.io.Serializable;

/**
 * Lop thuc the: mat hang.
 */
public class Product6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String brand;
    private String unit;
    private double salePrice;
    private int stockQuantity;
    private String description;
    private String imageUrl;
    private ProductCategory6 category;

    public Product6() {
        super();
    }

    /** Ma mat hang hien thi tren giao dien, vi du id 12 -> SP012. */
    public String getProductCode() {
        return String.format("SP%03d", id);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public double getSalePrice() { return salePrice; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public ProductCategory6 getCategory() { return category; }
    public void setCategory(ProductCategory6 category) { this.category = category; }
}
