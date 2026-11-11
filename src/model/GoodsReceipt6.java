package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/**
 * Lop thuc the: phieu nhap hang tu nha cung cap.
 */
public class GoodsReceipt6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Date receiptDate;
    private String notes;
    private Supplier6 supplier;
    private Manager6 manager;
    private ArrayList<ReceiptItem6> receiptItems;

    public GoodsReceipt6() {
        super();
        receiptItems = new ArrayList<ReceiptItem6>();
    }

    /** Tong tien phieu nhap (thuoc tinh dan xuat). */
    public double getReceiptTotal() {
        double sum = 0;
        if (receiptItems != null)
            for (ReceiptItem6 item : receiptItems) sum += item.getAmount();
        return sum;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getReceiptDate() { return receiptDate; }
    public void setReceiptDate(Date receiptDate) { this.receiptDate = receiptDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Supplier6 getSupplier() { return supplier; }
    public void setSupplier(Supplier6 supplier) { this.supplier = supplier; }

    public Manager6 getManager() { return manager; }
    public void setManager(Manager6 manager) { this.manager = manager; }

    public ArrayList<ReceiptItem6> getReceiptItems() { return receiptItems; }
    public void setReceiptItems(ArrayList<ReceiptItem6> receiptItems) { this.receiptItems = receiptItems; }
}
