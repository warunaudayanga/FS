package com.wx.controller;

import com.wx.dto.Emp;
import com.wx.jdbc.DataSource;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Controller
@RequestMapping("/emp")
public class UserController {

    @PostMapping("/search")
    public @ResponseBody
    String search(String term, String sort, String order){
        String sql = String.format("" +
                "SELECT empID, CONCAT(fName, ' ', lName) AS name, dob, nic, gender, phone, regDate, status, name AS position FROM employee, positions " +
                "WHERE position=id AND CONCAT(fName, ' ', lName) like '%s' ORDER BY %s %s", "%" + term + "%", sort, order);
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            JSONArray jsArray = new JSONArray();
            if(rs == null){
                return "{\"data\":\"error\"}";
            } else if (!rs.next()) {
                return "false";
            } else {
                do {
                    JSONArray jsArr = new JSONArray();
                    jsArr.put(new JSONObject()
                            .put("value", rs.getInt("empID"))
                            .put("attr", "data-id"));
                    jsArr.put(rs.getString("name"));
                    jsArr.put(rs.getString("position"));
                    jsArr.put(rs.getString("nic"));
                    jsArr.put(rs.getString("gender").equals("m") ? "Male" : "Female");
                    jsArr.put(rs.getDate("dob"));
                    jsArr.put(rs.getString("phone"));
                    jsArr.put(rs.getDate("regDate"));
                    jsArr.put(new JSONObject()
                            .put("value", rs.getInt("status") == 1? "Enabled": "Disabled")
                            .put("attr", "data-status"));
                    jsArray.put(jsArr);
                } while (rs.next());
                return jsArray.toString();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\":\"error\"}";
        }
    }

    @PostMapping("/get")
    public String get(int id, Model model){
        setData(id, model);
        return "userForm";
    }

    @PostMapping("/getView")
    public String getView(int id, Model model){
        setData(id, model);
        return "userView";
    }

    @PostMapping("/add")
    public @ResponseBody String add(Emp emp){
        String sql1 = String.format("SELECT * FROM employee WHERE nic='%s'", emp.getNic());
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql1 );
             ResultSet rs = pst.executeQuery()){
            if(rs != null && rs.next()){
                return "{\"data\": \"exist\"}";
            }else {
                String sql2 = String.format("INSERT INTO employee (fName, lName, password, dob, nic, gender, position, address, phone, status) VALUE ('%s','%s','%s','%s','%s','%s','%d','%s','%s','%s')",
                        emp.getfName(), emp.getlName(), emp.getPassword(), emp.getDob(), emp.getNic(), emp.getGender(), emp.getPosition(), emp.getAddress(), emp.getPhone().replaceAll("[\\s-]", ""), emp.isStatus()? 1 : 0);
                return "{\"data\": " + DataSource.writeData(sql2) + "}";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "[{\"data\": false}]";
        }
    }

    @PostMapping("/update")
    public @ResponseBody String update(Emp emp){
        String sql1 = String.format("SELECT * FROM employee WHERE nic='%s' AND empID!=%d", emp.getNic(), emp.getId());
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql1 );
             ResultSet rs = pst.executeQuery()){
            if(rs != null && rs.next()){
                return "{\"data\": \"exist\"}";
            }else {
                String sql2 = String.format("UPDATE employee SET fName='%s', lName='%s', password='%s', dob='%s', nic='%s', gender='%s', position='%d', address='%s', phone='%s', status='%s' WHERE empID='%d'",
                        emp.getfName(), emp.getlName(), emp.getPassword(), emp.getDob(), emp.getNic(), emp.getGender(), emp.getPosition(), emp.getAddress(), emp.getPhone().replaceAll("[\\s-]", ""), emp.isStatus()? 1 : 0, emp.getId());
                return "{\"data\": " + DataSource.writeData(sql2) + "}";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\": false}";
        }
    }

    @PostMapping("/changeStat")
    public @ResponseBody boolean changeStat(int id, int status) {
        return DataSource.writeData(String.format("UPDATE employee SET status=%d WHERE empID=%d", status, id));
    }

    @PostMapping("/delete")
    public @ResponseBody String delete (int id) {
        return "{\"data\": " + DataSource.writeData("DELETE FROM employee WHERE empID=" + id) + "}";
    }

    private void setData(int id, Model model) {

        String sql1 = "SELECT `option` FROM access WHERE type='users' AND `option`='update' AND empID=" + LoginController.getUid();
        boolean options = false;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql1 );
             ResultSet rsUser = pst.executeQuery()){
            if (rsUser!=null && rsUser.next()){
                options = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sql2 = "SELECT * FROM employee WHERE empID=" + id;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql2 );
             ResultSet rs = pst.executeQuery()){
            if(rs != null && rs.next()){
                model.addAttribute("fName", rs.getString("fName"));
                model.addAttribute("lName", rs.getString("lName"));
                model.addAttribute("password", options? rs.getString("password"): "****");
                model.addAttribute("position", rs.getString("position"));
                model.addAttribute("nic", rs.getString("nic"));
                model.addAttribute("gender", rs.getString("gender"));
                model.addAttribute("dob", rs.getDate("dob"));
                model.addAttribute("address", rs.getString("address"));
                model.addAttribute("phone", rs.getString("phone"));
                model.addAttribute("status", rs.getInt("status") == 1? "checked": "");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
