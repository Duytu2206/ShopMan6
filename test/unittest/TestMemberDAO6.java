package unittest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import dao.MemberDAO6;
import model.Customer6;
import model.Manager6;
import model.Member6;

/**
 * Kiem thu don vi lop MemberDAO6 (dang nhap) voi tai khoan mau trong shopman6_db.sql.
 */
public class TestMemberDAO6 {
    MemberDAO6 dao = new MemberDAO6();
    static final String SEED_PASSWORD = "123456"; // mat khau mau trong shopman6_db.sql

    @Test
    public void checkLogin_testChuan1() {
        Member6 m = dao.checkLogin("customer6", SEED_PASSWORD);
        assertTrue(m instanceof Customer6);
        assertEquals(4, m.getId());
        assertEquals("KH001", ((Customer6) m).getCustomerCode());
    }

    @Test
    public void checkLogin_testChuan2() {
        Member6 m = dao.checkLogin("manager6", SEED_PASSWORD);
        assertTrue(m instanceof Manager6);
        assertEquals("manager", m.getRole());
    }

    @Test
    public void checkLogin_testNgoaile() {
        assertNull(dao.checkLogin("customer6", "sai_mat_khau"));
        assertNull(dao.checkLogin("khong_ton_tai", SEED_PASSWORD));
        assertNull(dao.checkLogin("customer6' OR '1'='1", "x"));
        assertNull(dao.checkLogin("", ""));
    }
}
