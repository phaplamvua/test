<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product List</title>
        <script>
            var contextPath = "${pageContext.request.contextPath}";
        </script>
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
                width: 800px;
                text-align: center;
            }
            .product-container h2 {
                margin-bottom: 20px;
                color: #333;
            }
            .search-bar {
                margin-bottom: 20px;
            }
            .search-bar input[type="text"] {
                width: 70%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .filters {
                display: flex;
                justify-content: space-between;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .filters select, .filters input[type="number"], .filters input[type="checkbox"] {
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                margin-right: 10px;
            }
            .filters button {
                padding: 10px 20px;
                background-color: #4CAF50;
                border: none;
                border-radius: 4px;
                color: white;
                cursor: pointer;
            }
            .filters button:hover {
                background-color: #45a049;
            }
            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 20px;
            }
            .product-item {
                border: 1px solid #ccc;
                border-radius: 4px;
                padding: 10px;
                text-align: left;
            }
            .product-item img {
                max-width: 100%;
                height: auto;
                border-radius: 4px;
            }
            .product-item h3 {
                font-size: 16px;
                margin: 10px 0;
                color: #333;
            }
            .product-item p {
                font-size: 14px;
                color: #666;
                margin: 5px 0;
            }
            .error {
                color: red;
                font-size: 14px;
                margin-bottom: 20px;
            }
            .loading {
                display: none;
                text-align: center;
                margin-top: 20px;
            }
            .loading img {
                width: 50px;
            }
        </style>
    </head>
    <body>
    <fmt:setLocale value="vi_VN"/>
    <c:set scope="session" var="products" target="products"/>

    <div class="product-container">
        <h2>Product List</h2>
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search by name">
        </div>
        <div class="filters">
            <select id="sortSelect">
                <option value="">Sort by</option>
                <option value="name_asc">Name A-Z</option>
                <option value="name_desc">Name Z-A</option>
                <option value="price_asc">Price Low to High</option>
                <option value="price_desc">Price High to Low</option>
            </select>
            <input type="number" id="minPrice" placeholder="Min Price" min="0">
            <input type="number" id="maxPrice" placeholder="Max Price" min="0">
            <label>
                <input type="checkbox" id="hasDiscount"> Has Discount
            </label>
            <select id="categorySelect">
                <option value="">All Categories</option>
                <c:forEach var="category" items="${categories}">
                    <option value="${category.typeId}">${category.categoryName}</option>
                </c:forEach>
            </select>
            <button id="applyFilters">Apply</button>
        </div>
        <div id="productGrid" class="product-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-item">
                    <c:if test="${not empty product.productImage}">
                        <img src="${pageContext.request.contextPath}/${product.productImage}" alt="${product.productName}">
                    </c:if>
                    <h3>${product.productName}</h3>
                    <p>Price: <fmt:formatNumber value="${product.price}" type="currency" /></p>
                </div>
            </c:forEach>
        </div>
        <div class="loading" id="loading">
            <img src="${pageContext.request.contextPath}/images/loading.gif" alt="Loading...">
        </div>
        <div class="error" id="error"></div>
    </div>

    <script>
        // Sử dụng 'var' thay cho 'let' và 'const'
        var debounceTimeout;
        var searchInput = document.getElementById('searchInput');
        var sortSelect = document.getElementById('sortSelect');
        var minPrice = document.getElementById('minPrice');
        var maxPrice = document.getElementById('maxPrice');
        var hasDiscount = document.getElementById('hasDiscount');
        var categorySelect = document.getElementById('categorySelect');
        var applyFilters = document.getElementById('applyFilters');
        var productGrid = document.getElementById('productGrid');
        var loading = document.getElementById('loading');
        var errorDiv = document.getElementById('error');

        function fetchProducts() {
            var search = searchInput.value;
            var sort = sortSelect.value;
            var min = minPrice.value;
            var max = maxPrice.value;
            var discount = hasDiscount.checked ? 'true' : '';
            var category = categorySelect.value;
            var url = contextPath + '/MainController?entity=product&action=search&search=' + encodeURIComponent(search) + '&sort=' + sort + '&minPrice=' + min + '&maxPrice=' + max + '&hasDiscount=' + discount + '&categoryId=' + category;

            loading.style.display = 'block';
            errorDiv.textContent = '';
            fetch(url)
                    .then(function (response) { // Sử dụng hàm function() thay cho hàm mũi tên
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(function (data) {
                        loading.style.display = 'none';
                        renderProducts(data);
                    })
                    .catch(function (error) {
                        loading.style.display = 'none';
                        errorDiv.textContent = 'An error occurred while fetching products: ' + error.message;
                        console.error('Fetch Error:', error);
                    });
        }

        function renderProducts(products) {
            productGrid.innerHTML = '';
            if (products.length === 0) {
                productGrid.innerHTML = '<p>No products found.</p>';
            } else {
                products.forEach(function (product) {
                    var div = document.createElement('div');
                    div.className = 'product-item';

                    var imageHtml = '';
                    if (product.productImage) {
                        imageHtml = '<img src="' + contextPath + '/' + product.productImage + '" alt="' + product.productName + '">';
                    }

                    div.innerHTML = imageHtml +
                            '<h3>' + product.productName + '</h3>' +
                            '<p>Price: <fmt:formatNumber value="' + formatter.format(product.price) + '" type="currency" /></p>';

                    productGrid.appendChild(div);
                });
            }
        }

        searchInput.addEventListener('input', function () { // Sử dụng hàm function()
            clearTimeout(debounceTimeout);
            debounceTimeout = setTimeout(fetchProducts, 300);
        });

        applyFilters.addEventListener('click', fetchProducts);
    </script>
</body>
</html>