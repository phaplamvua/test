/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Product;
import model.dao.ProductDAO;

/**
 *
 * @author phapl
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    private ProductDAO productDAO;
    private Gson gson;

    public ProductController() {
        productDAO = new ProductDAO();
        gson = new Gson();
    }

    public void handleRequest(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        try {
            switch (action.toLowerCase()) {
                case "list":
                    listProducts(request, response);
                    break;
                case "listtopage":
                    listProductsPage(request, response);
                    break;
                case "search":
                    searchProducts(request, response);
                    break;
                case "get":
                    getProduct(request, response);
                    break;
                case "add":
                    addProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException | ParseException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ArrayList<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        //request.getRequestDispatcher("/product.jsp").forward(request, response);
    }

    private void listProductsPage(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ArrayList<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/product.jsp").forward(request, response);
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String search = request.getParameter("search");
            String sort = request.getParameter("sort");
            String minPrice = request.getParameter("minPrice");
            String maxPrice = request.getParameter("maxPrice");
            String hasDiscount = request.getParameter("hasDiscount");
            String categoryId = request.getParameter("categoryId");

            // Xử lý các tham số
            Double min = minPrice != null && !minPrice.isEmpty() ? Double.valueOf(minPrice) : null;
            Double max = maxPrice != null && !maxPrice.isEmpty() ? Double.valueOf(maxPrice) : null;
            boolean discount = "true".equals(hasDiscount);
            Integer category = categoryId != null && !categoryId.isEmpty() ? Integer.valueOf(categoryId) : null;

            // Truy vấn cơ sở dữ liệu
            ArrayList<Product> products = productDAO.searchProductName(search, sort, min, max, discount, category);
            
            String json = gson.toJson(products);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(json);
        } catch (Exception e) {
            String errorJson = "{\"error\": \"An error occurred while searching products: " + e.getMessage() + "\"}";
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(errorJson);
        }
    }

    private void getProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String productId = request.getParameter("productId");
        Product product = productDAO.getProduct(productId);
        request.setAttribute("product", product);
        request.getRequestDispatcher("/productdetail.jsp").forward(request, response);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ParseException, IOException {
        Product product = extractProductFromRequest(request);
        productDAO.addProduct(product);
        response.sendRedirect("main?entity=product&action=list");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ParseException, IOException {
        Product product = extractProductFromRequest(request);
        productDAO.updateProduct(product);
        response.sendRedirect("main?entity=product&action=list");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String productId = request.getParameter("productId");
        productDAO.deleteProduct(productId);
        response.sendRedirect("main?entity=product&action=list");
    }

    private Product extractProductFromRequest(HttpServletRequest request) throws ParseException {
        Product product = new Product();
        product.setProductId(request.getParameter("productId"));
        product.setProductName(request.getParameter("productName"));
        product.setProductImage(request.getParameter("productImage"));
        product.setBrief(request.getParameter("brief"));
        String postedDateStr = request.getParameter("postedDate");
        if (postedDateStr != null && !postedDateStr.isEmpty()) {
            product.setPostedDate(new SimpleDateFormat("yyyy-MM-dd").parse(postedDateStr));
        }
        product.setTypeId(Integer.parseInt(request.getParameter("typeId")));
        product.setAccount(request.getParameter("account"));
        product.setUnit(request.getParameter("unit"));
        product.setPrice(Integer.parseInt(request.getParameter("price")));
        product.setDiscount(Integer.parseInt(request.getParameter("discount")));
        return product;
    }
}
