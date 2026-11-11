package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Product6;
import model.ProductCategory6;

public class ProductDAO6 extends DAO6 {

    public ProductDAO6() {
        super();
    }

    /**
     * Tim cac mat hang co ten chua tu khoa.
     * @param name tu khoa (ten mat hang)
     * @return danh sach mat hang tim duoc; danh sach rong neu khong co mat hang nao
     *         hoac tu khoa rong
     */
    public ArrayList<Product6> getProductByName(String name) {
        ArrayList<Product6> kq = new ArrayList<Product6>();
        if (name == null || name.trim().isEmpty()) return kq;
        String sql = "{call searchProductByName6(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, name.trim());
            ResultSet rs = cs.executeQuery();

            while (rs.next()) {
                kq.add(readProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kq;
    }

    /**
     * Lay day du thong tin chi tiet cua mot mat hang.
     * @param idProduct id cua mat hang duoc chon
     * @return doi tuong Product6; null neu khong ton tai
     */
    public Product6 getProductDetail(int idProduct) {
        Product6 kq = null;
        String sql = "{call getProductDetail6(?)}"; // su dung stored procedure
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, idProduct);
            ResultSet rs = cs.executeQuery();

            if (rs.next()) {
                kq = readProduct(rs);
                kq.getCategory().setDescription(rs.getString("categoryDescription"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /** Dong goi mot dong ResultSet thanh doi tuong Product6. */
    private Product6 readProduct(ResultSet rs) throws Exception {
        Product6 p = new Product6();
        p.setId(rs.getInt("idProduct"));
        p.setName(rs.getString("name"));
        p.setBrand(rs.getString("brand"));
        p.setUnit(rs.getString("unit"));
        p.setSalePrice(rs.getDouble("salePrice"));
        p.setStockQuantity(rs.getInt("stockQuantity"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl(rs.getString("imageUrl"));
        // danh muc
        ProductCategory6 c = new ProductCategory6();
        c.setId(rs.getInt("idCategory"));
        c.setCategoryName(rs.getString("categoryName"));
        p.setCategory(c);
        return p;
    }
}
