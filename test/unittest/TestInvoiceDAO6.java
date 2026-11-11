package unittest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.junit.Test;

import dao.InvoiceDAO6;
import model.Invoice6;

/**
 * Kiem thu don vi lop InvoiceDAO6 (module thong ke khach hang theo doanh thu).
 */
public class TestInvoiceDAO6 {
    InvoiceDAO6 dao = new InvoiceDAO6();

    private Date d(String s) throws Exception {
        return new SimpleDateFormat("yyyy-MM-dd").parse(s);
    }

    @Test
    public void getInvoiceOfCustomer_testChuan() throws Exception {
        // KH002 (id 5) co 2 lan mua trong thang 8/2026
        ArrayList<Invoice6> list = dao.getInvoiceOfCustomer(5, d("2026-08-01"), d("2026-08-31"));
        assertNotNull(list);
        assertEquals(2, list.size());
        assertEquals("HD00231", list.get(0).getInvoiceCode());
        assertEquals(778000, list.get(0).getTotalAmount(), 0.001);
        assertEquals("HD00268", list.get(1).getInvoiceCode());
        assertEquals(370000, list.get(1).getTotalAmount(), 0.001);
        for (Invoice6 inv : list) assertEquals(5, inv.getCustomer().getId());
    }

    @Test
    public void getInvoiceOfCustomer_testNgoaile1() throws Exception {
        // khach hang chi co hoa don bi huy trong khoang -> rong
        ArrayList<Invoice6> list = dao.getInvoiceOfCustomer(7, d("2026-08-01"), d("2026-08-31"));
        assertNotNull(list);
        assertTrue(list.isEmpty());
    }

    @Test
    public void getInvoiceOfCustomer_testChuan2() throws Exception {
        // KH009 (id 6): chi lay HD00247 da giao, bo HD00300 dang giao
        ArrayList<Invoice6> list = dao.getInvoiceOfCustomer(6, d("2026-08-01"), d("2026-08-31"));
        assertEquals(1, list.size());
        assertEquals("HD00247", list.get(0).getInvoiceCode());
        assertEquals(Invoice6.DELIVERED, list.get(0).getStatus());
    }

    @Test
    public void getInvoiceOfCustomer_testNgoaile4() throws Exception {
        // KH001 (id 4) chi co hoa don cho duyet -> khong co lan mua nao duoc tinh
        assertTrue(dao.getInvoiceOfCustomer(4, d("2026-09-01"), d("2026-09-30")).isEmpty());
    }

    @Test
    public void getInvoiceOfCustomer_testNgoaile2() throws Exception {
        // khach hang khong ton tai
        assertTrue(dao.getInvoiceOfCustomer(1000, d("2026-08-01"), d("2026-08-31")).isEmpty());
    }

    @Test
    public void getInvoiceOfCustomer_testNgoaile3() throws Exception {
        // khach hang co mua nhung o khoang thoi gian khac
        assertTrue(dao.getInvoiceOfCustomer(5, d("2026-07-01"), d("2026-07-31")).isEmpty());
        // ngay bat dau > ngay ket thuc
        assertTrue(dao.getInvoiceOfCustomer(5, d("2026-08-31"), d("2026-08-01")).isEmpty());
    }

    @Test
    public void getInvoiceDetail_testChuan() {
        Invoice6 inv = dao.getInvoiceDetail(231);
        assertNotNull(inv);
        assertEquals("HD00231", inv.getInvoiceCode());
        assertEquals(Invoice6.DELIVERED, inv.getStatus());
        assertEquals("KH002", inv.getCustomer().getCustomerCode());
        assertEquals("Trần Thị B", inv.getCustomer().getFullName());
        assertEquals(2, inv.getOrderedProducts().size());
        assertEquals(12, inv.getOrderedProducts().get(0).getProduct().getId());
        assertEquals(12, inv.getOrderedProducts().get(0).getQuantity());
        assertEquals(408000, inv.getOrderedProducts().get(0).getAmount(), 0.001);
        assertEquals(778000, inv.getTotalAmount(), 0.001);
    }

    @Test
    public void getInvoiceDetail_testNgoaile() {
        // hoa don khong ton tai
        assertNull(dao.getInvoiceDetail(99999));
    }
}
