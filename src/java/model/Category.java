package model;

import java.io.Serializable;

public class Category implements Serializable{
    private static final long serialVersionUID = 1L;
    
    private int typeId;
    private String categoryName;
    private String memo;

    // Constructor
    public Category() {
    }

    public Category(int typeId, String categoryName, String memo) {
        this.typeId = typeId;
        this.categoryName = categoryName;
        this.memo = memo;
    }

    // Getters and Setters
    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
