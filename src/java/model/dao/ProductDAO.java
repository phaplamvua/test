package model.dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utilities.DBConnection;

public class ProductDAO {
    public void addProduct(Product product) throws SQLException {
        String sql = "INSERT INTO products (productId, productName, productImage, brief, postedDate, typeId, account, unit, price, discount) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getProductId());
            stmt.setString(2, product.getProductName());
            stmt.setString(3, product.getProductImage());
            stmt.setString(4, product.getBrief());
            stmt.setDate(5, product.getPostedDate() != null ? new java.sql.Date(product.getPostedDate().getTime()) : null);
            stmt.setInt(6, product.getTypeId());
            stmt.setString(7, product.getAccount());
            stmt.setString(8, product.getUnit());
            stmt.setInt(9, product.getPrice());
            stmt.setInt(10, product.getDiscount());
            stmt.executeUpdate();
        }
    }

    public Product getProduct(String productId) throws SQLException {
        String sql = "SELECT * FROM products WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getString("productId"));
                product.setProductName(rs.getString("productName"));
                product.setProductImage(rs.getString("productImage"));
                product.setBrief(rs.getString("brief"));
                product.setPostedDate(rs.getDate("postedDate"));
                product.setTypeId(rs.getInt("typeId"));
                product.setAccount(rs.getString("account"));
                product.setUnit(rs.getString("unit"));
                product.setPrice(rs.getInt("price"));
                product.setDiscount(rs.getInt("discount"));
                return product;
            }
            return null;
        }
    }
    
    public ArrayList<Product> searchProductName(String search, String sort, Double minPrice, Double maxPrice, boolean hasDiscount, Integer categoryId) throws SQLException {
        ArrayList<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        if (search != null && !search.isEmpty()) {
            sql.append(" AND productName LIKE ?");
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
        }
        if (hasDiscount) {
            sql.append(" AND discount > 0");
        }
        if (categoryId != null) {
            sql.append(" AND typeId = ?");
        }
        if (sort != null && !sort.isEmpty()) {
            sql.append(" ORDER BY ").append(sort);
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (search != null && !search.isEmpty()) {
                stmt.setString(index++, "%" + search + "%");
            }
            if (minPrice != null) {
                stmt.setDouble(index++, minPrice);
            }
            if (maxPrice != null) {
                stmt.setDouble(index++, maxPrice);
            }
            if (categoryId != null) {
                stmt.setInt(index++, categoryId);
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getString("productId"));
                product.setProductName(rs.getString("productName"));
                product.setProductImage(rs.getString("productImage"));
                product.setBrief(rs.getString("brief"));
                product.setPostedDate(rs.getDate("postedDate"));
                product.setTypeId(rs.getInt("typeId"));
                product.setAccount(rs.getString("account"));
                product.setUnit(rs.getString("unit"));
                product.setPrice(rs.getInt("price"));
                product.setDiscount(rs.getInt("discount"));
                products.add(product);
            }
        }
        return products;
    }

    public ArrayList<Product> getAllProducts() throws SQLException {
        ArrayList<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); 
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getString("productId"));
                product.setProductName(rs.getString("productName"));
                product.setProductImage(rs.getString("productImage"));
                product.setBrief(rs.getString("brief"));
                product.setPostedDate(rs.getDate("postedDate"));
                product.setTypeId(rs.getInt("typeId"));
                product.setAccount(rs.getString("account"));
                product.setUnit(rs.getString("unit"));
                product.setPrice(rs.getInt("price"));
                product.setDiscount(rs.getInt("discount"));
                products.add(product);
            }
        }
        return products;
    }

    public void updateProduct(Product product) throws SQLException {
        String sql = "UPDATE products SET productName = ?, productImage = ?, brief = ?, postedDate = ?, typeId = ?, " +
                     "account = ?, unit = ?, price = ?, discount = ? WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getProductImage());
            stmt.setString(3, product.getBrief());
            stmt.setDate(4, product.getPostedDate() != null ? new java.sql.Date(product.getPostedDate().getTime()) : null);
            stmt.setInt(5, product.getTypeId());
            stmt.setString(6, product.getAccount());
            stmt.setString(7, product.getUnit());
            stmt.setInt(8, product.getPrice());
            stmt.setInt(9, product.getDiscount());
            stmt.setString(10, product.getProductId());
            stmt.executeUpdate();
        }
    }

    public void deleteProduct(String productId) throws SQLException {
        String sql = "DELETE FROM products WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, productId);
            stmt.executeUpdate();
        }
    }
}