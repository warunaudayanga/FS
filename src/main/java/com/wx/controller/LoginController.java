package com.wx.controller;

import com.app.App;
import com.wx.jdbc.DataSource;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;

import javax.servlet.http.HttpServletRequest;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Controller
@SessionAttributes({"user"})
public class LoginController {

    private static int uid;

    @GetMapping("/")
    public String loginView(@NotNull SessionStatus status, Model model) {
        status.setComplete();
//        if (App.config.containsKey("username")) JDBC.setLoginData(App.config.getString("username"), App.config.getString("password"));
        if (App.config.containsKey("appName")) model.addAttribute("appName", App.config.getString("appName"));
        return "login";
    }

    @PostMapping("/tryConnection")
    public @ResponseBody String tryConnection(HttpServletRequest request) {
//        String status = JDBC.tryConnection();
//        if(status.equals("ok")) {
//            return status;
//        } else if (request.getRemoteAddr().equals(request.getLocalAddr())) {
//            return status;
//        } else {
//            return null;
//        }
        return null;
    }

    @PostMapping("/setLoginData")
    public @ResponseBody String setLoginData(String username, String password, HttpServletRequest request) {
//        if(request.getRemoteAddr().equals(request.getLocalAddr())) {
//            JDBC.setLoginData(username, password);
//            String status = JDBC.tryConnection();
//            if (status.equals("ok") || status.equals("1049")) {
//                App.setProperty("username", username);
//                App.setProperty("password", password);
//            }
//            return status;
//        }
        return null;
    }

    @PostMapping("/resetDatabase")
    public @ResponseBody boolean resetDatabase(HttpServletRequest request) throws FileNotFoundException {
//        if(request.getRemoteAddr().equals(request.getLocalAddr())) {
//            return JDBC.resetDatabase();
//        }
        return false;
    }

    @PostMapping("/verifyUser")
    public @ResponseBody String verifyUser(int uid, String password, ModelMap model){
        String sql = String.format("SELECT status FROM employee WHERE empID=%d AND password='%s'", uid, password);
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            if (rs != null && rs.next()){
                if(rs.getInt("status") == 1) {
                    model.addAttribute("user", uid);
                    setUid(uid);
                    return "{\"data\": true}";
                }
                return "{\"data\": \"disabled\"}";
            }
            return "{\"data\": \"invalid\"}";
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\": false}";
        }
    }


    public static int getUid() {
        return uid;
    }

    public static void setUid(int uid) {
        LoginController.uid = uid;
    }
}
