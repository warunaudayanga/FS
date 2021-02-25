package com.wx.dto;

//@SuppressWarnings("unused")
public class Emp {

    private int id;
    private String fName;
    private String lName;
    private String password;
    private String dob;
    private String nic;
    private String gender;
    private int position;
    private String address;
    private String phone;
    private boolean status;

    public Emp(){

    }

    public Emp(int id, String fName, String lName, String password, String dob, String nic,
               String gender, int position, String address, String phone, boolean status) {
        this.id = id;
        this.fName = fName;
        this.lName = lName;
        this.password = password;
        this.dob = dob;
        this.nic = nic;
        this.gender = gender;
        this.position = position;
        this.phone = phone;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getfName() {
        return fName;
    }

    public void setfName(String fName) {
        this.fName = fName;
    }

    public String getlName() {
        return lName;
    }

    public void setlName(String lName) {
        this.lName = lName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
