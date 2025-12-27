package servlet;

import model.Product;
import model.ProductRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CatalogServlet extends HttpServlet {

    private double parseMoney(String s, double def) {
        try {
            if (s == null) return def;
            s = s.trim();
            if (s.isEmpty()) return def;
            s = s.replaceAll("[^0-9.]", "");
            if (s.isEmpty()) return def;
            return Double.parseDouble(s);
        } catch (Exception e) {
            return def;
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // --- SECURITY CHECK START ---
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            // Redirect to home with error if not logged in
            resp.sendRedirect("./?mode=login&msg=Please login to view catalog");
            return;
        }
        // --- SECURITY CHECK END ---

        String jsonPath = getServletContext().getRealPath("/products.json");
        List<Product> allProducts = ProductRepository.loadProducts(jsonPath);

        String occasion = req.getParameter("occasion");
        String moment   = req.getParameter("moment");
        String search   = req.getParameter("search");

        double min = parseMoney(req.getParameter("min"), 0.0);
        double max = parseMoney(req.getParameter("max"), Double.MAX_VALUE);

        if (min > max) { double t = min; min = max; max = t; }

        List<Product> filtered = new ArrayList<>();

        for (Product p : allProducts) {
            // Occasion
            if (!isBlank(occasion) && !p.getOccasion().equalsIgnoreCase(occasion)) continue;

            // Moment
            if (!isBlank(moment)) {
                List<String> pm = p.getMoments();
                boolean matched = false;
                if (pm != null) {
                    for (String x : pm) {
                        if (x != null && x.trim().equalsIgnoreCase(moment.trim())) {
                            matched = true; break;
                        }
                    }
                }
                if (!matched) continue;
            }

            // Budget
            if (p.getPrice() < min || p.getPrice() > max) continue;

            // Search
            if (!isBlank(search)) {
                String s = search.toLowerCase();
                if (!p.getName().toLowerCase().contains(s) && !p.getDescription().toLowerCase().contains(s)) {
                    continue;
                }
            }
            filtered.add(p);
        }

        req.setAttribute("products", filtered);
        req.setAttribute("occasion", occasion);
        req.setAttribute("moment", moment);
        req.setAttribute("search", search);
        req.setAttribute("min", req.getParameter("min"));
        req.setAttribute("max", req.getParameter("max"));

        req.getRequestDispatcher("/catalog.jsp").forward(req, resp);
    }
}