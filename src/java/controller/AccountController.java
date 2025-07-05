/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Account;
import model.Category;
import model.Product;
import model.dao.AccountDAO;

/**
 *
 * @author phapl
 */
@WebServlet(name = "AccountController", urlPatterns = {"/AccountController"})
public class AccountController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private AccountDAO accountDAO;

    public AccountController() {
        accountDAO = new AccountDAO();
    }

    public void handleRequest(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        try {
            switch (action.toLowerCase()) {
                case "list":
                    listAccounts(request, response);
                    break;
                case "login":
                    getAccount(request, response);
                    break;
                case "logout":
                    logout(request, response);
                    break;
                case "add":
                    addAccount(request, response);
                    break;
                case "update":
                    updateAccount(request, response);
                    break;
                case "delete":
                    deleteAccount(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException | ParseException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        ArrayList<Account> accounts = accountDAO.getAllAccounts();
        request.setAttribute("accounts", accounts);
        //request.getRequestDispatcher("/views/account/list.jsp").forward(request, response);
    }

    private void getAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String url = "/login.jsp";
        String accountId = request.getParameter("account");
        String pass = request.getParameter("pass");
        String rememberMe = request.getParameter("rememberMe");

        Account account = accountDAO.getAccount(accountId, pass);
        switch (account.getRoleInSystem()) {
            case 1: //Admin
                request.setAttribute("account", account);
                sessionCategory(request, response);
                sessionProduct(request, response);
                sessionListAccount(request, response);
                rememberMe(response, rememberMe, accountId, pass);
                url = "/WEB-INF/jsp/dashboard.jsp";
                break;
            case 2: //Manager
                request.setAttribute("account", account);
                sessionCategory(request, response);
                sessionProduct(request, response);
                rememberMe(response, rememberMe, accountId, pass);
                url = "/product.jsp";
                break;
            default:
                request.setAttribute("error", "Invalid User Role");
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private void sessionProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.getRequestDispatcher("/MainController?entity=product&action=list").include(request, response);

        ArrayList<Product> products = (ArrayList<Product>) request.getAttribute("products");
        if (products != null) {
            request.getSession().setAttribute("products", products);
        }
    }

    private void sessionCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.getRequestDispatcher("/MainController?entity=category&action=list").include(request, response);

        ArrayList<Category> categories = (ArrayList<Category>) request.getAttribute("categories");
        if (categories != null) {
            request.getSession().setAttribute("categories", categories);
        }
    }

    private void sessionListAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.getRequestDispatcher("/MainController?entity=account&action=list").include(request, response);

        ArrayList<Account> acc = (ArrayList<Account>) request.getAttribute("accounts");
        if (acc != null) {
            request.getSession().setAttribute("accounts", acc);
        }
    }

    private void rememberMe(HttpServletResponse response, String rememberMe, String accountId, String pass) {
        if (rememberMe != null) {
            Cookie usernameCookie = new Cookie("account", accountId);
            usernameCookie.setMaxAge(30 * 24 * 60 * 60); // 30 ngày
            usernameCookie.setPath("/");
            response.addCookie(usernameCookie);

            Cookie passwordCookie = new Cookie("pass", pass);
            passwordCookie.setMaxAge(30 * 24 * 60 * 60); // 30 ngày
            passwordCookie.setPath("/");
            response.addCookie(passwordCookie);
        }
    }

    private void addAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ParseException, IOException {
        Account account = extractAccountFromRequest(request);
        accountDAO.addAccount(account);
        response.sendRedirect("login.jsp");
    }

    private void updateAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ParseException, IOException {
        Account account = extractAccountFromRequest(request);
        accountDAO.updateAccount(account);
        response.sendRedirect("main?entity=account&action=list");
    }

    private void deleteAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String accountId = request.getParameter("accountId");
        accountDAO.deleteAccount(accountId);
        response.sendRedirect("main?entity=account&action=list");
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        request.getSession(false).invalidate();
        request.removeAttribute("accounts");

        Cookie cookieA = new Cookie("account", "");
        cookieA.setMaxAge(0); // Xóa ngay lập tức
        cookieA.setPath("/"); // Đảm bảo path khớp với cookie ban đầu
        response.addCookie(cookieA);

        Cookie cookieP = new Cookie("pass", "");
        cookieP.setMaxAge(0); // Xóa ngay lập tức
        cookieP.setPath("/"); // Đảm bảo path khớp với cookie ban đầu
        response.addCookie(cookieP);

        response.sendRedirect("login.jsp");
    }

    private Account extractAccountFromRequest(HttpServletRequest request) throws ParseException {
        Account account = new Account();
        account.setAccount(request.getParameter("account"));
        account.setPass(request.getParameter("pass"));
        account.setLastName(request.getParameter("lastName"));
        account.setFirstName(request.getParameter("firstName"));
        String birthdayStr = request.getParameter("birthday");
        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            account.setBirthday(new SimpleDateFormat("yyyy-MM-dd").parse(birthdayStr));
        }
        account.setGender("1".equals(request.getParameter("gender")));
        account.setPhone(request.getParameter("phone"));
        account.setUse(true);
        account.setRoleInSystem(2);
        return account;
    }
}
