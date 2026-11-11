package unittest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import org.junit.Test;

import dao.ProductDAO6;
import model.Product6;

/**
 * Kiem thu don vi lop ProductDAO6 (module tim kiem mat hang).
 * Ket qua mong doi lay theo du lieu mau trong database/shopman6_db.sql.
 */
public class TestProductDAO6 {
    ProductDAO6 dao = new ProductDAO6();

    @Test
    public void getProductByName_testChuan1() {
        // tu khoa khop dung 1 mat hang
        ArrayList<Product6> list = dao.getProductByName("Gạo");
        assertNotNull(list);
        assertEquals(1, list.size());
        assertEquals(35, list.get(0).getId());
        assertEquals("SP035", list.get(0).getProductCode());
    }

    @Test
    public void getProductByName_testChuan2() {
        // tu khoa khop nhieu mat hang, khong phan biet hoa thuong
        ArrayList<Product6> list = dao.getProductByName("sữa");
        assertNotNull(list);
        assertEquals(4, list.size());
        for (Product6 p : list) {
            assertTrue(p.getName().toLowerCase().contains("sữa"));
            assertEquals("Sữa", p.getCategory().getCategoryName());
        }
    }

    @Test
    public void getProductByName_testChuan3() {
        // tim kiem phan biet dau: "mì" chi ra Mì Hảo Hảo, khong ra "Vinamilk", "TH true MILK"
        ArrayList<Product6> list = dao.getProductByName("mì");
        assertEquals(1, list.size());
        assertEquals(21, list.get(0).getId());
        // khong phan biet hoa thuong
        assertEquals(1, dao.getProductByName("MÌ HẢO").size());
    }

    @Test
    public void getProductByName_testNgoaile1() {
        // khong co mat hang nao chua tu khoa -> danh sach rong
        ArrayList<Product6> list = dao.getProductByName("xyz khong ton tai");
        assertNotNull(list);
        assertTrue(list.isEmpty());
    }

    @Test
    public void getProductByName_testNgoaile2() {
        // tu khoa rong / null -> danh sach rong, khong truy van
        assertTrue(dao.getProductByName("").isEmpty());
        assertTrue(dao.getProductByName("   ").isEmpty());
        assertTrue(dao.getProductByName(null).isEmpty());
    }

    @Test
    public void getProductDetail_testChuan() {
        Product6 p = dao.getProductDetail(12);
        assertNotNull(p);
        assertEquals("SP012", p.getProductCode());
        assertEquals("Sữa tươi Vinamilk 1L", p.getName());
        assertEquals("Vinamilk", p.getBrand());
        assertEquals("Hộp", p.getUnit());
        assertEquals(34000, p.getSalePrice(), 0.001);
        assertEquals(480, p.getStockQuantity());
        assertEquals("Sữa", p.getCategory().getCategoryName());
    }

    @Test
    public void getProductDetail_testNgoaile() {
        // mat hang khong ton tai
        assertNull(dao.getProductDetail(99999));
    }
}
