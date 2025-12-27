<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");

    String occasion = (String) request.getAttribute("occasion");
    String moment   = (String) request.getAttribute("moment");
    String search   = (String) request.getAttribute("search");
    String min      = (String) request.getAttribute("min");
    String max      = (String) request.getAttribute("max");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gift Genie – Catalog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    
    <style>
        /* 1. PURPLE BADGE (Occasion) */
        .badge-soft-purple {
            background-color: #f3f0ff;
            color: #7950f2;
            border: 1px solid #d0bfff;
            font-weight: 600;
            padding: 5px 10px;
        }

        /* 2. YELLOW BADGE (Moment) */
        .badge-soft-yellow {
            background-color: #fff9db;
            color: #e6b800;
            border: 1px solid #ffe066;
            font-weight: 600;
            padding: 5px 10px;
        }

        /* 3. CLICKABLE CARD LINK */
        .product-link {
            text-decoration: none;
            color: inherit; 
            display: block;
        }
        .product-link:hover .product-img {
            opacity: 0.9;   
        }
        .product-link:hover h5 {
            color: #7950f2; 
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-soft mb-0">
  <div class="container">
    <a class="navbar-brand text-primary fw-bold" href="./">🎁 Gift Genie</a>
    <div class="navbar-nav ms-auto">
        <a class="nav-link" href="./">Home</a>
        <a class="nav-link active" href="catalog">Catalog</a>
        <a class="nav-link" href="cart">Cart</a>
        <a class="nav-link" href="checkout">Checkout</a>
    </div>
  </div>
</nav>

<div class="container-fluid p-0 mb-5">
    <img src="images/banner1.jpg" alt="Gift Genie Banner" class="w-100" style="height: 300px; object-fit: cover;">
</div>

<div class="container mb-5">
    <div class="row">
        
        <div class="col-lg-3 mb-4">
            <div class="soft-card">
                <h4 class="fw-bold mb-3 text-primary">Filter Gifts</h4>
                
                <form method="get" action="catalog">
                    
                    <div class="mb-3">
                        <label class="form-label small text-muted text-uppercase fw-bold">Search</label>
                        <input type="text" name="search" class="form-control" placeholder="Teddy bear..." value="<%= search != null ? search : "" %>" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label small text-muted text-uppercase fw-bold">Occasion</label>
                        <select name="occasion" class="form-select">
                            <option value="" <%= (occasion == null || occasion.isEmpty()) ? "selected" : "" %>>All Occasions</option>
                            <option value="General" <%= "General".equalsIgnoreCase(occasion) ? "selected" : "" %>>General</option>
                            <option value="Birthday" <%= "Birthday".equalsIgnoreCase(occasion) ? "selected" : "" %>>Birthday</option>
                            <option value="Graduation" <%= "Graduation".equalsIgnoreCase(occasion) ? "selected" : "" %>>Graduation</option>
                            <option value="Mother's Day" <%= "Mother's Day".equalsIgnoreCase(occasion) ? "selected" : "" %>>Mother’s Day</option>
                            <option value="Anniversary" <%= "Anniversary".equalsIgnoreCase(occasion) ? "selected" : "" %>>Anniversary</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small text-muted text-uppercase fw-bold">Moment</label>
                        <select name="moment" class="form-select">
                            <option value="" <%= (moment == null || moment.isEmpty()) ? "selected" : "" %>>All Moments</option>
                            <option value="Catching Up" <%= "Catching Up".equalsIgnoreCase(moment) ? "selected" : "" %>>Catching Up</option>
                            <option value="Airport Pickup" <%= "Airport Pickup".equalsIgnoreCase(moment) ? "selected" : "" %>>Airport Pickup</option>
                            <option value="Housewarming" <%= "Housewarming".equalsIgnoreCase(moment) ? "selected" : "" %>>Housewarming</option>
                            <option value="Making Amends" <%= "Making Amends".equalsIgnoreCase(moment) ? "selected" : "" %>>Making Amends</option>
                            <option value="Get Well Soon" <%= "Get Well Soon".equalsIgnoreCase(moment) ? "selected" : "" %>>Get Well Soon</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small text-muted text-uppercase fw-bold">Budget ($)</label>
                        <div class="d-flex gap-2">
                            <input type="text" name="min" class="form-control" placeholder="Min" value="<%= min != null ? min : "" %>" />
                            <input type="text" name="max" class="form-control" placeholder="Max" value="<%= max != null ? max : "" %>" />
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-soft-primary">Apply Filters</button>
                        <a href="catalog" class="btn btn-outline-soft">Reset</a>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-lg-9">
            
            <h2 class="mb-4 fw-bold">Our Collection</h2>

            <div class="row">
            <%
                if (products == null || products.isEmpty()) {
            %>
                <div class="col-12 text-center py-5">
                    <h3 class="text-muted">No gifts found matching your search. 🧞‍♂️</h3>
                    <a href="catalog" class="btn btn-link">Clear filters</a>
                </div>
            <%
                } else {
                    for (Product p : products) {
            %>
                <div class="col-md-6 col-lg-4 mb-4" id="p<%= p.getId() %>">
                    <div class="soft-card h-100 p-0 d-flex flex-column overflow-hidden">
                        
                        <a href="product?id=<%= p.getId() %>" class="product-link">
                            <img src="images/<%= p.getImage() %>" alt="<%= p.getName() %>" class="product-img w-100"/>
                        </a>
                        
                        <div class="p-3 d-flex flex-column flex-grow-1">
                            <div class="mb-2 d-flex flex-wrap gap-1">
                                <span class="badge badge-soft-purple rounded-pill"><%= p.getOccasion() %></span>
                                <% 
                                    if (p.getMoments() != null) {
                                        for (String m : p.getMoments()) {
                                %>
                                    <span class="badge badge-soft-yellow rounded-pill"><%= m %></span>
                                <% 
                                        }
                                    }
                                %>
                            </div>
                            
                            <a href="product?id=<%= p.getId() %>" class="product-link">
                                <h5 class="fw-bold mb-1"><%= p.getName() %></h5>
                            </a>

                            <h4 class="text-primary fw-bold mb-3">$<%= String.format("%.2f", p.getPrice()) %></h4>
                            
                            <p class="text-muted small mb-3 flex-grow-1">
                                <%= p.getDescription() %>
                            </p>
                            
                            <form method="post" action="cart" class="mt-auto">
                                <input type="hidden" name="action" value="add" />
                                <input type="hidden" name="id" value="<%= p.getId() %>" />
                                
                                <%
                                    String qs = request.getQueryString();
                                    String back = "catalog" + (qs != null ? ("?" + qs) : "") + "#p" + p.getId();
                                %>
                                <input type="hidden" name="redirect" value="<%= back %>" />

                                <button type="submit" class="btn btn-soft-primary w-100">Add to Cart</button>
                            </form>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
            </div> 
        </div> 
    </div> 
</div>

</body>
</html>