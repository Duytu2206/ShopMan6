package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import model.Customer6;
import model.Invoice6;
import model.OrderedProduct6;
import model.Product6;

public class InvoiceDAO6 extends DAO6 {

    public InvoiceDAO6() {
        super();
    }

    /**
     * Lay cac lan mua (hoa don da giao) cua mot khach hang trong khoang thoi gian.
     * @param idCustomer id khach hang
     * @param startDate ngay bat dau
     * @param endDate ngay ket thuc
     * @return danh sach Invoice6 (co tong tien), sap xep theo ngay dat; danh sach rong neu khong co
     */
    public ArrayList<Invoice6> getInvoiceOfCustomer(int idCustomer, Date startDate, Date endDate) {
        ArrayList<Invoice6> kq = new ArrayList<Invoice6>();
        if (startDate == null || endDate == null || startDate.after(endDate)) return kq;
        String sql = "{call getInvoiceOfCustomer6(?,?,?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, idCustomer);
            cs.setDate(2, new java.sql.Date(startDate.getTime()));
            cs.setDate(3, new java.sql.Date(endDate.getTime()));
            ResultSet rs = cs.executeQuery();

            while (rs.next()) {
                Invoice6 inv = new Invoice6();
                inv.setId(rs.getInt("idInvoice"));
                inv.setOrderDate(rs.getTimestamp("orderDate"));
                inv.setShippingAddress(rs.getString("shippingAddress"));
                inv.setStatus(rs.getString("status"));
                inv.setNotes(rs.getString("notes"));
                inv.setTotalAmount(rs.getDouble("totalAmount"));
                // khach hang
                Customer6 c = new Customer6();
                c.setId(rs.getInt("idCustomer"));
                inv.setCustomer(c);
                kq.add(inv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kq;
    }

    /**
     * Lay hoa don chi tiet: thong tin hoa don, khach hang va danh sach mat hang.
     * @param idInvoice id hoa don
     * @return Invoice6 kem danh sach OrderedProduct6; null neu hoa don khong ton tai
     */
    public Invoice6 getInvoiceDetail(int idInvoice) {
        Invoice6 kq = null;
        String sql = "{call getInvoiceDetail6(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, idInvoice);
            ResultSet rs = cs.executeQuery();

            while (rs.next()) {
                if (kq == null) {
                    kq = new Invoice6();
                    kq.setId(rs.getInt("idInvoice"));
                    kq.setOrderDate(rs.getTimestamp("orderDate"));
                    kq.setShippingAddress(rs.getString("shippingAddress"));
                    kq.setStatus(rs.getString("status"));
                    kq.setNotes(rs.getString("notes"));
                    // khach hang
                    Customer6 c = new Customer6();
                    c.setId(rs.getInt("idCustomer"));
                    c.setFullName(rs.getString("fullName"));
                    c.setCustomerCode(rs.getString("customerCode"));
                    kq.setCustomer(c);
                }
                int idOrderedProduct = rs.getInt("idOrderedProduct");
                if (rs.wasNull()) continue; // hoa don khong co dong mat hang nao
                // mat hang
                Product6 p = new Product6();
                p.setId(rs.getInt("idProduct"));
                p.setName(rs.getString("productName"));
                p.setUnit(rs.getString("unit"));
                // dong mat hang trong hoa don
                OrderedProduct6 op = new OrderedProduct6();
                op.setId(idOrderedProduct);
                op.setProduct(p);
                op.setQuantity(rs.getInt("quantity"));
                op.setUnitPrice(rs.getDouble("unitPrice"));
                kq.getOrderedProducts().add(op);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }
}
