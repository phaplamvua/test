/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Category;
import model.dao.CategoryDAO;

/**
 *
 * @author phapl
 */
@WebServlet(name = "CategoryController", urlPatterns = {"/CategoryController"})
public class CategoryController extends HttpServlet {

    private CategoryDAO categoryDAO;

    public CategoryController() {
        categoryDAO = new CategoryDAO();
    }

    public void handleRequest(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        try {
            switch (action.toLowerCase()) {
                case "list":
                    listCategories(request, response);
                    break;
                case "get":
                    getCategory(request, response);
                    break;
                case "add":
                    addCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ArrayList<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        //request.getRequestDispatcher("/views/category/list.jsp").forward(request, response);
    }

    private void getCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int typeId = Integer.parseInt(request.getParameter("typeId"));
        Category category = categoryDAO.getCategory(typeId);
        request.setAttribute("category", category);
        request.getRequestDispatcher("/views/category/view.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        Category category = extractCategoryFromRequest(request);
        categoryDAO.addCategory(category);
        response.sendRedirect("main?entity=category&action=list");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        Category category = extractCategoryFromRequest(request);
        categoryDAO.updateCategory(category);
        response.sendRedirect("main?entity=category&action=list");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int typeId = Integer.parseInt(request.getParameter("typeId"));
        categoryDAO.deleteCategory(typeId);
        response.sendRedirect("main?entity=category&action=list");
    }

    private Category extractCategoryFromRequest(HttpServletRequest request) {
        Category category = new Category();
        String typeId = request.getParameter("typeId");
        if (typeId != null && !typeId.isEmpty()) {
            category.setTypeId(Integer.parseInt(typeId));
        }
        category.setCategoryName(request.getParameter("categoryName"));
        category.setMemo(request.getParameter("memo"));
        return category;
    }
}
