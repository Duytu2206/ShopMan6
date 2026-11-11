package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import model.CustomerStat6;

public class CustomerStatDAO6 extends DAO6 {

    public CustomerStatDAO6() {
        super();
    }

    /**
     * Thong ke khach hang theo doanh thu trong khoang thoi gian, sap xep doanh thu giam dan.
     * Doanh thu chi tinh tren cac hoa don da giao (DELIVERED) - khach da nhan hang.
     * @param startDate ngay bat dau (tinh ca ngay nay)
     * @param endDate ngay ket thuc (tinh ca ngay nay)
     * @return danh sach CustomerStat6; danh sach rong neu khoang thoi gian
     *         khong hop le hoac khong co du lieu
     */
    public ArrayList<CustomerStat6> getCustomerStatByRevenue(Date startDate, Date endDate) {
        ArrayList<CustomerStat6> kq = new ArrayList<CustomerStat6>();
        if (startDate == null || endDate == null || startDate.after(endDate)) return kq;
        String sql = "{call getCustomerStatByRevenue(?,?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setDate(1, new java.sql.Date(startDate.getTime()));
            cs.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = cs.executeQuery();

            while (rs.next()) {
                CustomerStat6 cst = new CustomerStat6();
                cst.setId(rs.getInt("idMember"));
                cst.setUsername(rs.getString("username"));
                cst.setFullName(rs.getString("fullName"));
                cst.setBirthDate(rs.getDate("birthDate"));
                cst.setAddress(rs.getString("address"));
                cst.setEmail(rs.getString("email"));
                cst.setPhoneNumber(rs.getString("phoneNumber"));
                cst.setRole(rs.getString("role"));
                cst.setCustomerCode(rs.getString("customerCode"));
                cst.setRegistrationDate(rs.getDate("registrationDate"));
                cst.setPurchaseCount(rs.getInt("purchaseCount"));
                cst.setTotalRevenue(rs.getDouble("totalRevenue"));
                kq.add(cst);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kq;
    }
}
