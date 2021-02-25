package com.wx.dto;

public class StockItem {
    private int itemCode;
    private double price;
    private double sPrice;
    private double qty;

    public StockItem() {

    }

    public int getItemCode() {
        return itemCode;
    }

    public void setItemCode(int itemCode) {
        this.itemCode = itemCode;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getsPrice() {
        return sPrice;
    }

    public void setsPrice(double sPrice) {
        this.sPrice = sPrice;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

}
