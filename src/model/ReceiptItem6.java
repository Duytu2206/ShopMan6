package model;

import java.io.Serializable;

/**
 * Lop thuc the: mot dong mat hang trong phieu nhap.
 */
public class ReceiptItem6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Product6 product;
    private int quantity;
    private double unitCost;

    public ReceiptItem6() {
        super();
    }

    /** Thanh tien nhap = so luong x don gia nhap. */
    public double getAmount() {
        return quantity * unitCost;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Product6 getProduct() { return product; }
    public void setProduct(Product6 product) { this.product = product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitCost() { return unitCost; }
    public void setUnitCost(double unitCost) { this.unitCost = unitCost; }
}
