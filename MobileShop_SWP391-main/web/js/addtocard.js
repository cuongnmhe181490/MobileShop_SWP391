/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

function addToCart(idProduct) {
    // Đặt giá trị idProduct vào input của form ẩn
    document.getElementById("idProductInput").value = idProduct;
// Gửi form
    document.getElementById("cartForm").submit();

// Tự động tải lại trang sau 1 giây
    setTimeout(function () {
        // Tải lại trang
        location.reload();
    }, 1000);

// Hiện thông báo thành công
    var message = document.getElementById("successMessage");
    message.style.display = "block";

// Ẩn thông báo sau 1 giây
    setTimeout(function () {
        message.style.display = "none";
    }, 3000);
}



