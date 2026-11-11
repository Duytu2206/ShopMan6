package model;

import java.io.Serializable;

/**
 * Lop thuc the: danh muc hang hoa.
 */
public class ProductCategory6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String categoryName;
    private String description;

    public ProductCategory6() {
        super();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
