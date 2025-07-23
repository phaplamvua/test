/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


$(document).ready(function () {

    // ===== CHỨC NĂNG SỬA =====

    // 1. Khi nhấn nút "Sửa"
    $('#category-table-body').on('click', '.edit-btn', function () {
        const row = $(this).closest('tr');
        row.find('span').hide(); // Ẩn tên danh mục (dạng text)
        row.find('input[type="text"]').show().focus(); // Hiện ô input và focus vào đó
    });

    // 2. Hàm để thực hiện cập nhật
    function updateCategory(row) {
        const categoryId = row.data('id');
        const inputField = row.find('input[type="text"]');
        const newName = inputField.val().trim();
        const oldName = row.find('span').text();

        // Nếu tên không thay đổi hoặc rỗng thì không làm gì
        if (newName === "" || newName === oldName) {
            inputField.hide();
            row.find('span').show();
            return;
        }

        // Gửi yêu cầu AJAX lên server
        $.ajax({
            url: 'updateCategory', // URL của Servlet xử lý update
            type: 'POST',
            data: {
                id: categoryId,
                name: newName
            },
            success: function (response) {
                // Cập nhật thành công
                console.log('Cập nhật thành công!');
                // Cập nhật lại tên trên giao diện
                row.find('span').text(newName);
            },
            error: function () {
                // Xử lý lỗi
                console.error('Có lỗi xảy ra khi cập nhật!');
                alert('Cập nhật thất bại. Vui lòng thử lại.');
            },
            complete: function () {
                // Dù thành công hay thất bại, cũng ẩn input và hiện lại span
                inputField.hide();
                row.find('span').show();
            }
        });
    }

    // 3. Khi người dùng nhấn Enter trong ô input
    $('#category-table-body').on('keypress', 'input[type="text"]', function (e) {
        if (e.which === 13) { // 13 là mã của phím Enter
            const row = $(this).closest('tr');
            updateCategory(row);
        }
    });

    // 4. (Tùy chọn) Khi người dùng click ra ngoài ô input (blur)
    $('#category-table-body').on('blur', 'input[type="text"]', function () {
        const row = $(this).closest('tr');
        updateCategory(row);
    });


    // ===== CHỨC NĂNG XÓA =====

    $('#category-table-body').on('click', '.delete-btn', function () {
        const row = $(this).closest('tr');
        const categoryId = row.data('id');
        const categoryName = row.find('span').text();

        // Hiện cảnh báo xác nhận
        if (confirm(`Bạn có chắc chắn muốn xóa danh mục "${categoryName}" không?`)) {
            // Nếu người dùng đồng ý, gửi yêu cầu AJAX
            $.ajax({
                url: 'deleteCategory', // URL của Servlet xử lý delete
                type: 'POST',
                data: {
                    id: categoryId
                },
                success: function (response) {
                    // Xóa thành công, xóa hàng đó khỏi bảng trên giao diện
                    console.log('Xóa thành công!');
                    row.remove();
                },
                error: function () {
                    // Xử lý lỗi
                    console.error('Có lỗi xảy ra khi xóa!');
                    alert('Xóa thất bại. Vui lòng thử lại.');
                }
            });
        }
    });

});