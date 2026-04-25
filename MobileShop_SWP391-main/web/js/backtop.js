/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Hiển thị nút khi người dùng cuộn trang xuống 100px
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
    if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
        document.getElementById("backToTop").style.display = "block";
    } else {
        document.getElementById("backToTop").style.display = "none";
    }
}

// Hàm quay trở về đầu trang
function topFunction() {
    document.body.scrollTop = 0; // Dành cho Safari
    document.documentElement.scrollTop = 0; // Dành cho Chrome, Firefox, IE và Opera
}

