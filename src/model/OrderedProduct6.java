package model;

import java.io.Serializable;

/**
 * Lop thuc the: mot dong mat hang trong hoa don (lop trung gian Invoice6 - Product6).
 */
public class OrderedProduct6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Product6 product;
    private int quantity;
    private double unitPrice;

    public OrderedProduct6() {
        super();
    }

    /** Thanh tien = so luong x don gia (thuoc tinh dan xuat). */
    public double getAmount() {
        return quantity * unitPrice;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Product6 getProduct() { return product; }
    public void setProduct(Product6 product) { this.product = product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
}
