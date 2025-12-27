package model;

import org.json.JSONArray;
import org.json.JSONObject;
import java.io.*;
import java.nio.charset.StandardCharsets;

public class UserRepository {

    private static String readFile(String path) throws IOException {
        File f = new File(path);
        if (!f.exists()) return "[]"; 
        
        try (InputStream in = new FileInputStream(f)) {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int n;
            while ((n = in.read(buf)) != -1) out.write(buf, 0, n);
            return out.toString(StandardCharsets.UTF_8);
        }
    }

    private static void writeFile(String path, String content) throws IOException {
        try (OutputStream out = new FileOutputStream(path)) {
            out.write(content.getBytes(StandardCharsets.UTF_8));
        }
    }

    public static boolean isValid(String jsonPath, String email, String password) {
        try {
            String jsonText = readFile(jsonPath);
            JSONArray arr = new JSONArray(jsonText);

            for (int i = 0; i < arr.length(); i++) {
                JSONObject obj = arr.getJSONObject(i);
                
                // Check if JSON has "email" and if it matches
                if (obj.has("email") && 
                    obj.getString("email").equalsIgnoreCase(email) && 
                    obj.getString("password").equals(password)) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static String findNameByEmail(String jsonPath, String email) {
        try {
            String jsonText = readFile(jsonPath);
            JSONArray arr = new JSONArray(jsonText);
            for (int i = 0; i < arr.length(); i++) {
                JSONObject obj = arr.getJSONObject(i);
                if (obj.has("email") && obj.getString("email").equalsIgnoreCase(email)) {
                    // Return "name" if it exists, otherwise return the email prefix
                    return obj.optString("name", email.split("@")[0]);
                }
            }
        } catch (Exception e) { }
        return "User";
    }

    public static void addUser(String jsonPath, String name, String email, String password) {
        try {
            String jsonText = readFile(jsonPath);
            JSONArray arr;
            try {
                arr = new JSONArray(jsonText);
            } catch (Exception e) {
                arr = new JSONArray(); 
            }

            JSONObject newUser = new JSONObject();
            newUser.put("name", name);  
            newUser.put("email", email); 
            newUser.put("password", password);

            arr.put(newUser);
            writeFile(jsonPath, arr.toString(2)); 

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}