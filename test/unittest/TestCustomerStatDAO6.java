package unittest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.junit.Test;

import dao.CustomerStatDAO6;
import model.CustomerStat6;

/**
 * Kiem thu don vi lop CustomerStatDAO6 (module thong ke khach hang theo doanh thu).
 */
public class TestCustomerStatDAO6 {
    CustomerStatDAO6 dao = new CustomerStatDAO6();

    private Date d(String s) throws Exception {
        return new SimpleDateFormat("yyyy-MM-dd").parse(s);
    }

    @Test
    public void getCustomerStatByRevenue_testChuan1() throws Exception {
        // thang 8/2026: 2 khach hang, sap xep doanh thu giam dan, chi tinh hoa don da giao
        ArrayList<CustomerStat6> list = dao.getCustomerStatByRevenue(d("2026-08-01"), d("2026-08-31"));
        assertNotNull(list);
        assertEquals(2, list.size());

        assertEquals(5, list.get(0).getId());
        assertEquals("KH002", list.get(0).getCustomerCode());
        assertEquals(2, list.get(0).getPurchaseCount());
        assertEquals(1148000, list.get(0).getTotalRevenue(), 0.001);

        // KH009: HD00247 da giao duoc tinh, HD00300 dang giao chua tinh
        assertEquals(6, list.get(1).getId());
        assertEquals("KH009", list.get(1).getCustomerCode());
        assertEquals(1, list.get(1).getPurchaseCount());
        assertEquals(555000, list.get(1).getTotalRevenue(), 0.001);

        assertTrue(list.get(0).getTotalRevenue() >= list.get(1).getTotalRevenue());
    }

    @Test
    public void getCustomerStatByRevenue_testChuan2() throws Exception {
        // ngay ket thuc duoc tinh tron ngay (HD00268 da giao, dat luc 19:45 ngay 15/08)
        ArrayList<CustomerStat6> list = dao.getCustomerStatByRevenue(d("2026-08-15"), d("2026-08-15"));
        assertEquals(1, list.size());
        assertEquals("KH002", list.get(0).getCustomerCode());
        assertEquals(1, list.get(0).getPurchaseCount());
        assertEquals(370000, list.get(0).getTotalRevenue(), 0.001);
    }

    @Test
    public void getCustomerStatByRevenue_testNgoaile5() throws Exception {
        // hoa don dang giao (HD00300, 31/08) va cho duyet (HD00310, 02/09) khong duoc tinh doanh thu
        assertTrue(dao.getCustomerStatByRevenue(d("2026-08-31"), d("2026-08-31")).isEmpty());
        assertTrue(dao.getCustomerStatByRevenue(d("2026-09-01"), d("2026-09-30")).isEmpty());
    }

    @Test
    public void getCustomerStatByRevenue_testChuan3() throws Exception {
        // thang 7/2026: chi co 1 khach hang
        ArrayList<CustomerStat6> list = dao.getCustomerStatByRevenue(d("2026-07-01"), d("2026-07-31"));
        assertEquals(1, list.size());
        assertEquals("KH004", list.get(0).getCustomerCode());
        assertEquals(124000, list.get(0).getTotalRevenue(), 0.001);
    }

    @Test
    public void getCustomerStatByRevenue_testNgoaile1() throws Exception {
        // trong khoang chi co hoa don bi huy -> khong co du lieu
        ArrayList<CustomerStat6> list = dao.getCustomerStatByRevenue(d("2026-08-20"), d("2026-08-20"));
        assertNotNull(list);
        assertTrue(list.isEmpty());
    }

    @Test
    public void getCustomerStatByRevenue_testNgoaile2() throws Exception {
        // ngay bat dau lon hon ngay ket thuc -> danh sach rong
        ArrayList<CustomerStat6> list = dao.getCustomerStatByRevenue(d("2026-08-31"), d("2026-08-01"));
        assertNotNull(list);
        assertTrue(list.isEmpty());
    }

    @Test
    public void getCustomerStatByRevenue_testNgoaile3() throws Exception {
        // khoang thoi gian khong co hoa don nao
        ArrayList<CustomerStat6> list = dao.getCustomerStatByRevenue(d("2025-01-01"), d("2025-12-31"));
        assertNotNull(list);
        assertTrue(list.isEmpty());
    }

    @Test
    public void getCustomerStatByRevenue_testNgoaile4() throws Exception {
        // tham so null -> danh sach rong
        assertTrue(dao.getCustomerStatByRevenue(null, d("2026-08-31")).isEmpty());
        assertTrue(dao.getCustomerStatByRevenue(d("2026-08-01"), null).isEmpty());
    }
}
