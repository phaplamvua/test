<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard</title>
        <meta charset="UTF-8">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            .menu {
                margin-bottom: 20px;
            }
            .menu button {
                padding: 10px 20px;
                margin-right: 10px;
            }
            .section {
                display: none;
            }
            .section.active {
                display: block;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            .error {
                color: red;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: inline-block;
                width: 150px;
            }
            input, select {
                width: 200px;
                padding: 5px;
            }
        </style>
        <script>
            function showSection(sectionId) {
                document.querySelectorAll('.section').forEach(section => {
                    section.classList.remove('active');
                });
                document.getElementById(sectionId).classList.add('active');
            }
            window.onload = function () {
                showSection('category-section'); // Mặc định hiển thị CRUD Category
            };
        </script>
    </head>
    <body>
        <fmt:setLocale value="vi_VN"/>

        <h2>Admin Dashboard</h2>
        <div class="menu">
            <button onclick="showSection('category-section')">Quản lý danh mục</button>
            <button onclick="showSection('product-section')">Quản lý sản phẩm</button>
            <button onclick="showSection('account-section')">Quản lý tài khoản</button>
            <a href="${pageContext.request.contextPath}/MainController?entity=account&action=logout">Logout</a>
        </div>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <!-- CRUD Category -->
        <div id="category-section" class="section">
            <h3>Quản lý danh mục</h3>
            <form action="${pageContext.request.contextPath}/MainController?entity=category&action=add" method="post">
                <div class="form-group">
                    <label>Tên danh mục:</label>
                    <input type="text" name="categoryName" required>
                </div>
                <div class="form-group">
                    <label>Ghi chú:</label>
                    <input type="text" name="memo">
                </div>
                <input type="submit" value="Thêm danh mục">
            </form>
            <div>
                <c:if test="${not empty errorCate}">${errorCate}</c:if>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên Danh mục</th>
                            <th>Ghi chú</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="category-table-body">
                    <%-- Giả sử 'categoryList' là danh sách các danh mục bạn gửi từ Servlet --%>
                    <c:forEach items="${categories}" var="category">
                        <tr data-id="${category.typeId}">
                            <td>${category.typeId}</td>
                            <td class="category-name">
                                <span>${category.categoryName}</span>
                                <%-- Input này bị ẩn và chỉ hiện ra khi nhấn Sửa --%>
                                <input type="text" value="${category.categoryName}" style="display:none;"/>
                            </td>
                            <td>${category.memo}</td>
                            <td class="actions">
                                <button class="edit-btn">Sửa</button>
                                <button class="delete-btn">Xóa</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- CRUD Product -->
        <div id="product-section" class="section">
            <h3>Quản lý sản phẩm</h3>
            <form action="/MainController?entity=product&action=add" method="post">
                <div class="form-group">
                    <label>ID sản phẩm:</label>
                    <input type="text" name="productId" required>
                </div>
                <div class="form-group">
                    <label>Tên sản phẩm:</label>
                    <input type="text" name="productName" required>
                </div>
                <div class="form-group">
                    <label>Hình ảnh:</label>
                    <input type="text" name="productImage">
                </div>
                <div class="form-group">
                    <label>Mô tả ngắn:</label>
                    <input type="text" name="brief">
                </div>
                <div class="form-group">
                    <label>Ngày đăng (yyyy-MM-dd):</label>
                    <input type="date" name="postedDate">
                </div>
                <div class="form-group">
                    <label>Danh mục:</label>
                    <select name="typeId" required>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.typeId}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Tài khoản:</label>
                    <input type="text" name="account" required>
                </div>
                <div class="form-group">
                    <label>Đơn vị:</label>
                    <input type="text" name="unit">
                </div>
                <div class="form-group">
                    <label>Giá:</label>
                    <input type="number" name="price" required>
                </div>
                <div class="form-group">
                    <label>Giảm giá (%):</label>
                    <input type="number" name="discount" min="0" max="100">
                </div>
                <input type="submit" value="Thêm sản phẩm">
            </form>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Tên sản phẩm</th>
                    <th>Hình ảnh</th>
                    <th>Giá</th>
                    <th>Giảm giá</th>
                    <th>Hành động</th>
                </tr>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.productId}</td>
                        <td>${product.productName}</td>
                        <td><img src="${pageContext.request.contextPath}/${product.productImage}" alt="Product Image" width="50"></td>
                        <td><fmt:formatNumber value="${product.price}" type="currency" /></td>
                        <td>${product.discount}%</td>
                        <td>
                            <a href="/MainController?entity=product&action=get&productId=${product.productId}">Sửa</a>
                            <a href="/MainController?entity=product&action=delete&productId=${product.productId}" 
                               onclick="return confirm('Xóa sản phẩm này?')">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <!-- Quản lý tài khoản -->
        <div id="account-section" class="section">
            <h3>Quản lý tài khoản</h3>
            <table>
                <tr>
                    <th>Tài khoản</th>
                    <th>Họ và tên</th>
                    <th>Trạng thái</th>
                    <th>Vai trò</th>
                    <th>Hành động</th>
                    <th></th>
                </tr>
                <c:forEach var="account" items="${accounts}">
                    <tr>
                        <td>${account.account}</td>
                        <td>${account.lastName} ${account.firstName}</td>
                        <td>${account.use ? 'Đang sử dụng' : 'Bị khóa'}</td>
                        <td>
                            <form action="/MainController?entity=account&action=updateRole" method="post" style="display:inline;">
                                <input type="hidden" name="account" value="${account.account}">
                                <select name="roleInSystem">
                                    <option value="1" ${account.roleInSystem == 1 ? 'selected' : ''}>Admin</option>
                                    <option value="2" ${account.roleInSystem == 2 ? 'selected' : ''}>User</option>
                                </select>
                            </form>
                        </td>
                        <td>
                            <form action="/MainController?entity=account&action=toggleBan" method="post" style="display:inline;">
                                <input type="hidden" name="account" value="${account.account}">
                                <input type="hidden" name="isUse" value="${account.use ? '0' : '1'}">
                                <button type="submit">${account.use ? 'Khóa' : 'Mở khóa'}</button>
                            </form>
                        </td>
                        <td>
                            <button type="submit">Apply</button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <script src="js/dashboard.js"></script>
    </body>
</html>