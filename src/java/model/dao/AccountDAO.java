package model.dao;

import model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utilities.DBConnection;

public class AccountDAO {
    public void addAccount(Account account) throws SQLException {
        String sql = "INSERT INTO accounts (account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, account.getAccount());
            stmt.setString(2, account.getPass());
            stmt.setString(3, account.getLastName());
            stmt.setString(4, account.getFirstName());
            stmt.setDate(5, account.getBirthday() != null ? new java.sql.Date(account.getBirthday().getTime()) : null);
            stmt.setBoolean(6, account.isGender());
            stmt.setString(7, account.getPhone());
            stmt.setBoolean(8, account.isUse());
            stmt.setInt(9, account.getRoleInSystem());
            stmt.executeUpdate();
        }
    }

    public Account getAccount(String accountId, String pass) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE account = ? AND pass = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, accountId);
            stmt.setString(2, pass);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setAccount(rs.getString("account"));
                account.setPass(rs.getString("pass"));
                account.setLastName(rs.getString("lastName"));
                account.setFirstName(rs.getString("firstName"));
                account.setBirthday(rs.getDate("birthday"));
                account.setGender(rs.getBoolean("gender"));
                account.setPhone(rs.getString("phone"));
                account.setUse(rs.getBoolean("isUse"));
                account.setRoleInSystem(rs.getInt("roleInSystem"));
                return account;
            }
            return null;
        }
    }

    public ArrayList<Account> getAllAccounts() throws SQLException {
        ArrayList<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM accounts";
        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); 
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Account account = new Account();
                account.setAccount(rs.getString("account"));
                account.setPass(rs.getString("pass"));
                account.setLastName(rs.getString("lastName"));
                account.setFirstName(rs.getString("firstName"));
                account.setBirthday(rs.getDate("birthday"));
                account.setGender(rs.getBoolean("gender"));
                account.setPhone(rs.getString("phone"));
                account.setUse(rs.getBoolean("isUse"));
                account.setRoleInSystem(rs.getInt("roleInSystem"));
                accounts.add(account);
            }
        }
        return accounts;
    }

    public void updateAccount(Account account) throws SQLException {
        String sql = "UPDATE accounts SET pass = ?, lastName = ?, firstName = ?, birthday = ?, gender = ?, " +
                     "phone = ?, isUse = ?, roleInSystem = ? WHERE account = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, account.getPass());
            stmt.setString(2, account.getLastName());
            stmt.setString(3, account.getFirstName());
            stmt.setDate(4, account.getBirthday() != null ? new java.sql.Date(account.getBirthday().getTime()) : null);
            stmt.setBoolean(5, account.isGender());
            stmt.setString(6, account.getPhone());
            stmt.setBoolean(7, account.isUse());
            stmt.setInt(8, account.getRoleInSystem());
            stmt.setString(9, account.getAccount());
            stmt.executeUpdate();
        }
    }

    public void deleteAccount(String accountId) throws SQLException {
        String sql = "DELETE FROM accounts WHERE account = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, accountId);
            stmt.executeUpdate();
        }
    }
}