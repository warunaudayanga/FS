package com.wx.dto;

import java.util.List;

@SuppressWarnings("unused")
public class Purchase {
    private int id;
    private int orderId;
    private int supId;
    private String expectDate;
    private List<StockItem> items;

    public Purchase() {

    }

    public Purchase(int id, int orderId, int supId, List<StockItem> items) {
        this.id = id;
        this.orderId = orderId;
        this.supId = supId;
        this.items = items;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSupId() {
        return supId;
    }

    public void setSupId(int supId) {
        this.supId = supId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public List<StockItem> getItems() {
        return items;
    }

    public void setItems(List<StockItem> items) {
        this.items = items;
    }

    public String getExpectDate() {
        return expectDate;
    }

    public void setExpectDate(String expectDate) {
        this.expectDate = expectDate;
    }

}
