<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.CartItem, model.Product" %>

<%
  List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
  if (cart == null) cart = new ArrayList<>();

  Object totalObj = request.getAttribute("total");
  double total = (totalObj == null) ? 0.0 : (double) totalObj;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gift Genie – Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    
    <style>
        .cart-img { width: 80px; height: 80px; object-fit: cover; border-radius: 15px; }
        .btn-circle {
            width: 30px; height: 30px; padding: 0; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            font-weight: bold; line-height: 1;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-soft mb-0">
  <div class="container">
    <a class="navbar-brand text-primary fw-bold" href="./">🎁 Gift Genie</a>
    <div class="navbar-nav ms-auto">
        <a class="nav-link" href="./">Home</a>
        <a class="nav-link" href="catalog">Catalog</a>
        <a class="nav-link active" href="cart">Cart</a>
        <a class="nav-link" href="checkout">Checkout</a>
    </div>
  </div>
</nav>

<div class="container-fluid p-0 mb-5">
    <img src="images/banner1.jpg" alt="Gift Genie Banner" class="w-100" style="height: 300px; object-fit: cover;">
</div>

<div class="container mb-5">
    <h2 class="fw-bold mb-4">Your Shopping Cart</h2>

    <% if (cart.isEmpty()) { %>
        <div class="text-center py-5 soft-card">
            <h3 class="text-muted mb-3">Your cart is empty... 🍃</h3>
            <p class="mb-4">Explore our catalog to find the perfect gift!</p>
            <a href="catalog" class="btn btn-soft-primary px-4">Start Shopping</a>
        </div>
    <% } else { %>

        <div class="row">
            <div class="col-lg-8">
                <% for (CartItem it : cart) {
                        Product p = it.getProduct();
                        int id = p.getId();
                        String name = p.getName();
                        String img = p.getImage();
                        double price = p.getPrice();
                        int qty = it.getQty();
                        double line = price * qty;
                %>
                <div class="soft-card mb-3 p-3 d-flex align-items-center">
                    <img src="images/<%= img %>" alt="<%= name %>" class="cart-img border shadow-sm">
                    <div class="ms-3 flex-grow-1">
                        <h5 class="fw-bold mb-1"><%= name %></h5>
                        <p class="text-muted small mb-0">Unit Price: $<%= String.format("%.2f", price) %></p>
                    </div>

                    <div class="d-flex align-items-center gap-2 mx-3">
                        <form method="post" action="cart" class="m-0">
                            <input type="hidden" name="action" value="removeOne">
                            <input type="hidden" name="id" value="<%= id %>">
                            <button type="submit" class="btn btn-outline-soft btn-circle shadow-sm">-</button>
                        </form>

                        <span class="fw-bold px-2"><%= qty %></span>

                        <form method="post" action="cart" class="m-0">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="id" value="<%= id %>">
                            <button type="submit" class="btn btn-soft-primary btn-circle shadow-sm">+</button>
                        </form>
                    </div>

                    <div class="text-end ms-3" style="min-width: 80px;">
                        <div class="fw-bold text-primary mb-1">$<%= String.format("%.2f", line) %></div>
                        <form method="post" action="cart" class="m-0">
                            <input type="hidden" name="action" value="removeAll">
                            <input type="hidden" name="id" value="<%= id %>">
                            <button type="submit" class="btn btn-link text-danger p-0 small text-decoration-none" style="font-size: 0.8rem;">Remove</button>
                        </form>
                    </div>
                </div>
                <% } %>
                <div class="mt-3">
                    <a href="catalog" class="text-decoration-none text-muted">← Continue Shopping</a>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="soft-card">
                    <h4 class="fw-bold mb-4">Order Summary</h4>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Subtotal</span>
                        <span class="fw-bold">$<%= String.format("%.2f", total) %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="text-muted">Shipping</span>
                        <span class="text-success fw-bold">Free</span>
                    </div>
                    <hr class="text-muted opacity-25">
                    <div class="d-flex justify-content-between mb-4 align-items-center">
                        <span class="fw-bold h5 mb-0">Total</span>
                        <span class="fw-bold h4 text-primary mb-0">$<%= String.format("%.2f", total) %></span>
                    </div>
                    <a href="checkout" class="btn btn-soft-primary w-100 py-2 shadow-sm">Proceed to Checkout</a>
                </div>
            </div>
        </div> 
    <% } %>
</div>
</body>
</html>