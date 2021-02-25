package com.wx.dto;

import java.util.List;

public class AccessList {
    private int empID;
    private List<AccessData> accessDataList;

    public AccessList(){

    }

    public int getEmpID() {
        return empID;
    }

    public void setEmpID(int empID) {
        this.empID = empID;
    }

    public List<AccessData> getAccessDataList() {
        return accessDataList;
    }

    @SuppressWarnings("unused")
    public void setAccessDataList(List<AccessData> accessDataList) {
        this.accessDataList = accessDataList;
    }

    public void add(AccessData accessData){
        accessDataList.add(accessData);
    }
}
