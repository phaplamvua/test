<%-- 
    Document   : productdetail
    Created on : Jun 23, 2025, 6:17:01 PM
    Author     : phapl
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                background-color: #f0f0f0;
            }
            .product-container {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                width: 600px;
                text-align: center;
            }
            .product-container h2 {
                margin-bottom: 20px;
                color: #333;
            }
            .product-detail {
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: left;
            }
            .product-detail img {
                max-width: 100%;
                height: auto;
                border-radius: 4px;
                margin-bottom: 20px;
            }
            .product-detail h3 {
                font-size: 20px;
                margin: 10px 0;
                color: #333;
            }
            .product-detail p {
                font-size: 16px;
                color: #666;
                margin: 5px 0;
            }
            .error {
                color: red;
                font-size: 14px;
                margin-bottom: 20px;
            }
            .nav-links {
                margin-top: 20px;
                font-size: 14px;
            }
            .nav-links a {
                color: #4CAF50;
                text-decoration: none;
                margin: 0 10px;
            }
            .nav-links a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <fmt:setLocale value="vi_VN"/>
        
        <div class="product-container">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController?entity=product&action=listtopage">Back to Products</a>
                <a href="${pageContext.request.contextPath}/MainController?entity=account&action=logout">Logout</a>
            </div>
            <h2>Product Detail</h2>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:if test="${not empty product}">
                <div class="product-detail">
                    <c:if test="${not empty product.productImage}">
                        <img src="${pageContext.request.contextPath}/${product.productImage}" alt="${product.productName}">
                    </c:if>
                    <h3>${product.productName}</h3>
                    <p>Price: <fmt:formatNumber value="${product.price}" type="currency" /></p>
                    <p>Description: ${product.brief}</p>
                    <p>Category ID: ${product.typeId}</p>
                </div>
            </c:if>
        </div>
    </body>
</html>
