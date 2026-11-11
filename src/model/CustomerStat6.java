package model;

/**
 * Lop thuc the thong ke: khach hang kem so lan mua va tong doanh thu
 * trong mot khoang thoi gian (ke thua Customer6).
 * Hai thuoc tinh purchaseCount, totalRevenue la thuoc tinh dan xuat,
 * duoc tinh dong bang SUM/COUNT trong stored procedure, khong luu trong CSDL.
 */
public class CustomerStat6 extends Customer6 {
    private static final long serialVersionUID = 1L;

    private int purchaseCount;
    private double totalRevenue;

    public CustomerStat6() {
        super();
    }

    public int getPurchaseCount() { return purchaseCount; }
    public void setPurchaseCount(int purchaseCount) { this.purchaseCount = purchaseCount; }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
}
