package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/**
 * Lop thuc the: hoa don truc tuyen.
 * Quan he hop thanh voi OrderedProduct6 (1 hoa don gom 1..n dong mat hang).
 */
public class Invoice6 implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String NEW = "NEW";
    public static final String APPROVED = "APPROVED";
    public static final String PACKED = "PACKED";
    public static final String SHIPPING = "SHIPPING";
    public static final String DELIVERED = "DELIVERED";
    public static final String CANCELLED = "CANCELLED";

    private int id;
    private Date orderDate;
    private String shippingAddress;
    private String status;
    private String notes;
    private Customer6 customer;
    private SalesStaff6 approvedBy;
    private DeliveryStaff6 deliveryStaff;
    private ArrayList<OrderedProduct6> orderedProducts;
    private double totalAmount;

    public Invoice6() {
        super();
        orderedProducts = new ArrayList<OrderedProduct6>();
    }

    /** Ma hoa don hien thi, vi du id 231 -> HD00231. */
    public String getInvoiceCode() {
        return String.format("HD%05d", id);
    }

    /** Trang thai hoa don bang tieng Viet de hien thi. */
    public String getStatusText() {
        if (status == null) return "";
        switch (status) {
            case NEW: return "Chờ duyệt";
            case APPROVED: return "Đã duyệt";
            case PACKED: return "Đã đóng gói";
            case SHIPPING: return "Đang giao";
            case DELIVERED: return "Đã giao";
            case CANCELLED: return "Đã hủy";
            default: return status;
        }
    }

    /**
     * Tong tien hoa don. Neu da co danh sach mat hang thi tinh tu danh sach,
     * nguoc lai dung gia tri tong tien do CSDL tinh san (SUM trong stored procedure).
     */
    public double getTotalAmount() {
        if (orderedProducts != null && !orderedProducts.isEmpty()) {
            double sum = 0;
            for (OrderedProduct6 op : orderedProducts) sum += op.getAmount();
            return sum;
        }
        return totalAmount;
    }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Customer6 getCustomer() { return customer; }
    public void setCustomer(Customer6 customer) { this.customer = customer; }

    public SalesStaff6 getApprovedBy() { return approvedBy; }
    public void setApprovedBy(SalesStaff6 approvedBy) { this.approvedBy = approvedBy; }

    public DeliveryStaff6 getDeliveryStaff() { return deliveryStaff; }
    public void setDeliveryStaff(DeliveryStaff6 deliveryStaff) { this.deliveryStaff = deliveryStaff; }

    public ArrayList<OrderedProduct6> getOrderedProducts() { return orderedProducts; }
    public void setOrderedProducts(ArrayList<OrderedProduct6> orderedProducts) { this.orderedProducts = orderedProducts; }
}
