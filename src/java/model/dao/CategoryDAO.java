package model.dao;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utilities.DBConnection;

public class CategoryDAO {
    public void addCategory(Category category) throws SQLException {
        String sql = "INSERT INTO categories (categoryName, memo) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setNString(1, category.getCategoryName());
            stmt.setNString(2, category.getMemo());
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                category.setTypeId(rs.getInt(1));
            }
        }
    }

    public Category getCategory(int typeId) throws SQLException {
        String sql = "SELECT * FROM categories WHERE typeId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, typeId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Category category = new Category();
                category.setTypeId(rs.getInt("typeId"));
                category.setCategoryName(rs.getNString("categoryName"));
                category.setMemo(rs.getNString("memo"));
                return category;
            }
            return null;
        }
    }

    public ArrayList<Category> getAllCategories() throws SQLException {
        ArrayList<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); 
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Category category = new Category();
                category.setTypeId(rs.getInt("typeId"));
                category.setCategoryName(rs.getNString("categoryName"));
                category.setMemo(rs.getNString("memo"));
                categories.add(category);
            }
        }
        return categories;
    }

    public void updateCategory(Category category) throws SQLException {
        String sql = "UPDATE categories SET categoryName = ?, memo = ? WHERE typeId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setNString(1, category.getCategoryName());
            stmt.setNString(2, category.getMemo());
            stmt.setInt(3, category.getTypeId());
            stmt.executeUpdate();
        }
    }

    public void deleteCategory(int typeId) throws SQLException {
        String sql = "DELETE FROM categories WHERE typeId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, typeId);
            stmt.executeUpdate();
        }
    }
}