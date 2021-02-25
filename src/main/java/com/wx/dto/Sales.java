package com.wx.dto;

import java.util.List;

public class Sales {
    private int id;
    private int saleId;
    private int user;
    private List<StockItem> items;

    Sales() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSaleId() {
        return saleId;
    }

    @SuppressWarnings("unused")
    public void setSaleId(int saleId) {
        this.saleId = saleId;
    }

    public int getUser() {
        return user;
    }

    public void setUser(int user) {
        this.user = user;
    }

    public List<StockItem> getItems() {
        return items;
    }

    public void setItems(List<StockItem> items) {
        this.items = items;
    }
}
