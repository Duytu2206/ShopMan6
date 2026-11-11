package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.CallableStatement;
import java.sql.ResultSet;

import model.Customer6;
import model.DeliveryStaff6;
import model.Manager6;
import model.Member6;
import model.SalesStaff6;
import model.Staff6;

public class MemberDAO6 extends DAO6 {

    public MemberDAO6() {
        super();
    }

    /**
     * Kiem tra dang nhap.
     * @param username ten dang nhap
     * @param password mat khau (chua ma hoa)
     * @return doi tuong thanh vien dung vai tro (Customer6, Manager6, ...) neu dung,
     *         null neu sai ten dang nhap/mat khau
     */
    public Member6 checkLogin(String username, String password) {
        if (username == null || password == null
                || username.trim().isEmpty() || password.isEmpty()) return null;
        Member6 kq = null;
        String sql = "{call checkLogin6(?,?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, username.trim());
            cs.setString(2, hashPassword(password));
            ResultSet rs = cs.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");
                if ("customer".equalsIgnoreCase(role)) {
                    Customer6 c = new Customer6();
                    c.setCustomerCode(rs.getString("customerCode"));
                    c.setRegistrationDate(rs.getDate("registrationDate"));
                    kq = c;
                } else {
                    Staff6 s;
                    if ("manager".equalsIgnoreCase(role)) s = new Manager6();
                    else if ("salesstaff".equalsIgnoreCase(role)) s = new SalesStaff6();
                    else s = new DeliveryStaff6();
                    s.setPosition(rs.getString("position"));
                    s.setActive(rs.getBoolean("isActive"));
                    kq = s;
                }
                kq.setId(rs.getInt("idMember"));
                kq.setUsername(rs.getString("username"));
                kq.setFullName(rs.getString("fullName"));
                kq.setBirthDate(rs.getDate("birthDate"));
                kq.setAddress(rs.getString("address"));
                kq.setEmail(rs.getString("email"));
                kq.setPhoneNumber(rs.getString("phoneNumber"));
                kq.setRole(role);
                kq.setNotes(rs.getString("notes"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Ma hoa mat khau bang SHA-256 (chuoi hex chu thuong, trung voi ham SHA2(...,256) cua MySQL).
     */
    public static String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest(password.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}
