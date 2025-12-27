package model;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class ProductRepository {

    private static String readFile(String path) throws IOException {
        try (InputStream in = new FileInputStream(path)) {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            return out.toString(StandardCharsets.UTF_8);
        }
    }

    public static List<Product> loadProducts(String jsonPath) {
        List<Product> list = new ArrayList<>();

        try {
            String jsonText = readFile(jsonPath);
            JSONArray arr = new JSONArray(jsonText);

            for (int i = 0; i < arr.length(); i++) {
                JSONObject obj = arr.getJSONObject(i);

                int id = obj.getInt("id");
                String name = obj.getString("name");
                double price = obj.getDouble("price");
                String description = obj.getString("description");
                String image = obj.optString("image", "");
                String occasion = obj.optString("occasion", "");

                List<String> moments = new ArrayList<>();

                if (obj.has("moment")) {
                    Object m = obj.get("moment");
                    if (m instanceof JSONArray) {
                        JSONArray mArr = (JSONArray) m;
                        for (int j = 0; j < mArr.length(); j++) {
                            moments.add(mArr.getString(j));
                        }
                    } else {
                        moments.add(String.valueOf(m));
                    }
                }

                if (obj.has("moments")) {
                    Object m = obj.get("moments");
                    if (m instanceof JSONArray) {
                        JSONArray mArr = (JSONArray) m;
                        for (int j = 0; j < mArr.length(); j++) {
                            moments.add(mArr.getString(j));
                        }
                    } else {
                        moments.add(String.valueOf(m));
                    }
                }

                Product p = new Product(id, name, price, description, image, occasion, moments);
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static Product findById(String jsonPath, int id) {
        for (Product p : loadProducts(jsonPath)) {
            if (p.getId() == id) return p;
        }
        return null;
    }
}