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
                width: 900px;
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
                transition: background-color 0.3s;
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
                border-radius: 8px;
                padding: 15px;
                text-align: left;
                background-color: #fff;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                overflow: hidden;
            }
            .product-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
                border-color: #4CAF50;
            }
            .product-item img {
                max-width: 100%;
                height: 150px;
                object-fit: cover;
                border-radius: 4px;
                margin-bottom: 10px;
            }
            .product-item h3 {
                font-size: 16px;
                margin: 10px 0;
                color: #333;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .product-item p {
                font-size: 14px;
                color: #666;
                margin: 5px 0;
            }
            .product-item .discount {
                color: #ff4444;
                font-weight: bold;
            }
            .product-item .discounted-price {
                color: #4CAF50;
                font-weight: bold;
            }
            .error {
                color: red;
                font-size: 14px;
                margin-bottom: 20px;
                padding: 10px;
                background-color: #ffebee;
                border-radius: 4px;
            }
            .loading {
                display: none;
                text-align: center;
                margin-top: 20px;
            }
            .loading-spinner {
                border: 4px solid #f3f3f3;
                border-top: 4px solid #4CAF50;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                animation: spin 1s linear infinite;
                margin: 0 auto;
            }
            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
            /* Navigation header */
            .nav-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
            }
            .nav-header a {
                color: #4CAF50;
                text-decoration: none;
                padding: 5px 10px;
                border-radius: 4px;
                transition: background-color 0.3s;
            }
            .nav-header a:hover {
                background-color: #f0f0f0;
            }
        </style>
    </head>
    <body>
    <fmt:setLocale value="vi_VN"/>
    <c:set scope="session" var="products" target="products"/>

    <div class="product-container">
        <h2>Product List</h2>

        <div class="nav-header">
            <h2>Product List</h2>
            <div>
                <a href="${pageContext.request.contextPath}/MainController?entity=account&action=logout">Logout</a>
            </div>
        </div>

        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search by name">
        </div>
        <div class="filters">
            <select id="sortSelect">
                <option value="">Sort by</option>
                <option value="productName_asc">Name A-Z</option>
                <option value="productName_desc">Name Z-A</option>
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
        var formatter = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'});

        function fetchProducts() {
            var search = searchInput.value;
            var sort = sortSelect.value;
            var min = minPrice.value;
            var max = maxPrice.value;
            var discount = hasDiscount.checked ? 'true' : '';
            var category = categorySelect.value;

            // Build URL with parameters
            var url = contextPath + '/MainController?entity=product&action=search';
            var params = [];
            if (search)
                params.push('search=' + encodeURIComponent(search));
            if (sort)
                params.push('sort=' + encodeURIComponent(sort));
            if (min)
                params.push('minPrice=' + encodeURIComponent(min));
            if (max)
                params.push('maxPrice=' + encodeURIComponent(max));
            if (discount)
                params.push('hasDiscount=' + encodeURIComponent(discount));
            if (category)
                params.push('categoryId=' + encodeURIComponent(category));
            if (params.length > 0) {
                url += '&' + params.join('&');
            }

            loading.style.display = 'block';
            errorDiv.textContent = '';

            fetch(url, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            })
                    .then(function (response) { // Sử dụng hàm function() thay cho hàm mũi tên
                        if (!response.ok) {
                            throw new Error('Server returned ' + response.status + ': ' + response.statusText);
                        }
                        // Get the content type
                        var contentType = response.headers.get("content-type");

                        // Check if response is JSON
                        if (contentType && contentType.indexOf("application/json") !== -1) {
                            return response.json();
                        } else {
                            // If not JSON, it's probably HTML (error page or login page)
                            return response.text().then(function (text) {
                                // Log the HTML response for debugging
                                console.error('Received HTML instead of JSON:', text.substring(0, 200) + '...');
                                throw new Error('Server returned HTML instead of JSON. You may need to login.');
                            });
                        }
                    })
                    .then(function (data) {
                        loading.style.display = 'none';
                        if (data.error) {
                            errorDiv.textContent = data.error;
                        } else {
                            renderProducts(data);
                        }
                    })
                    .catch(function (error) {
                        loading.style.display = 'none';
                        errorDiv.textContent = 'Error: ' + error.message;
                        console.error('Fetch Error:', error);

                        // If it's a login issue, you might want to redirect
                        if (error.message.includes('login')) {
                            // Optional: redirect to login page after a delay
                            setTimeout(function () {
                                window.location.href = contextPath + '/login.jsp';
                            }, 3000);
                        }
                    });
        }

        function renderProducts(products) {
            productGrid.innerHTML = '';

            if (!Array.isArray(products)) {
                console.error('Products is not an array:', products);
                productGrid.innerHTML = '<p>Error: Invalid data format received.</p>';
                return;
            }

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
                            '<p>Price: ' + formatter.format(product.price) + '</p>';

                    div.addEventListener('click', function () {
                        viewProductDetail(product.productId);
                    });

                    productGrid.appendChild(div);
                });
            }
        }

        function viewProductDetail(productId) {
            if (!productId) {
                console.error('Product ID is missing');
                return;
            }

            // Build the URL with parameters
            var detailUrl = contextPath + '/MainController?entity=product&action=get&productId=' + encodeURIComponent(productId);

            // Navigate to the product detail page
            window.location.href = detailUrl;
        }

        searchInput.addEventListener('input', function () { // Sử dụng hàm function()
            clearTimeout(debounceTimeout);
            debounceTimeout = setTimeout(fetchProducts, 300);
        });

        applyFilters.addEventListener('click', fetchProducts);

        fetchProducts();
    </script>
</body>
</html>