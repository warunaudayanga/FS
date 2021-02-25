<%@ page import="com.app.App" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div id="preferencesView" class="view">
    <div class="row options">
        <div class="offset-8 col-lg-4 col-md-4 text-right button-set">
            <button type="button" class="btn btn-sm btn-primary save">Save</button>
        </div>
    </div>
    <div class="row body">
        <div class="offset-1 col-10">
            <table class="w-100">
                <tr>
                    <th colspan="2">App</th>
                </tr>
                <tr>
                    <td>Header</td>
                    <td><input type="text" class="form-control form-control-sm" name="appTitle" value="<%=App.getValue("appTitle", "")%>"></td>
                </tr>
                <tr>
                    <td>Footer</td>
                    <td><input type="text" class="form-control form-control-sm" name="appFooter" value="<%=App.getValue("appFooter", "")%>"></td>
                </tr>
                <tr>
                    <th colspan="2">Company</th>
                </tr>
                <tr>
                    <td>Company Name</td>
                    <td><input type="text" class="form-control form-control-sm" name="comName" value="<%=App.getValue("comName", "")%>"></td>
                </tr>
                <tr>
                    <td>Address</td>
                    <td><textarea rows="3" class="form-control form-control-sm" name="comAddress"><%=App.getValue("comAddress", "")%></textarea></td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td><input type="text" class="form-control form-control-sm" name="comEmail" value="<%=App.getValue("comEmail", "")%>"></td>
                </tr>
                <tr>
                    <td>Phone</td>
                    <td><input type="text" class="form-control form-control-sm" name="comPhone" value="<%=App.getValue("comPhone", "")%>"></td>
                </tr>
                <tr>
                    <th colspan="2">Shipping</th>
                </tr>
                <tr>
                    <td>Name</td>
                    <td><input type="text" class="form-control form-control-sm" name="shipName" value="<%=App.getValue("shipName", "")%>"></td>
                </tr>
                <tr>
                    <td>Address</td>
                    <td><textarea rows="3" class="form-control form-control-sm" name="shipAddress"><%=App.getValue("shipAddress", "")%></textarea></td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td><input type="text" class="form-control form-control-sm" name="shipEmail" value="<%=App.getValue("shipEmail", "")%>"></td>
                </tr>
                <tr>
                    <td>Phone</td>
                    <td><input type="text" class="form-control form-control-sm" name="shipPhone" value="<%=App.getValue("shipPhone", "")%>"></td>
                </tr>
                <tr>
                    <th colspan="2">Stock</th>
                </tr>
                <tr>
                    <td>Warning limit for low items</td>
                    <td><input type="number" min="1" class="form-control form-control-sm text-right" name="stockWarning" value="<%=App.getValue("shipPhone", "")%>"></td>
                </tr>
            </table>

            <table class="w-100">
                <tr>
                    <th colspan="2">Purchase</th>
                </tr>
                <tr class="conditions">
                    <td class="col-lg-3">Conditions</td>
                    <td class="col-lg-9"><textarea rows="5" class="form-control form-control-sm" name="conditions"><%=App.getValue("conditions", "")%></textarea></td>
                </tr>
            </table>

            <table class="w-100">
                <tr>
                    <th colspan="2">Key Map</th>
                </tr>
                <tr>
                    <td>Main Menu</td>
                    <td>Number Row <kbd>1</kbd> to <kbd>9</kbd></td>
                </tr>
                <tr>
                    <td>Select Record</td>
                    <td><kbd>&uparrow;</kbd> / <kbd>&downarrow;</kbd></td>
                </tr>
                <tr>
                    <td>Search</td>
                    <td><kbd>S</kbd></td>
                </tr>
                <tr>
                    <td>New Record (Green)</td>
                    <td><kbd>Space</kbd></td>
                </tr>
                <tr>
                    <td>Update Record (Yellow)</td>
                    <td><kbd>Enter</kbd></td>
                </tr>
                <tr>
                    <td>Change Status (Black)</td>
                    <td><kbd>Shift</kbd></td>
                </tr>
                <tr>
                    <td>Delete (Red)</td>
                    <td><kbd>Delete</kbd></td>
                </tr>
                <tr>
                    <td>Stock Change Amount</td>
                    <td><kbd>&leftarrow;</kbd> / <kbd>&rightarrow;</kbd></td>
                </tr>
                <tr>
                    <td>Stock Increase / Stock Decrease</td>
                    <td><kbd>+</kbd> / <kbd>-</kbd></td>
                </tr>
                <tr>
                    <td>Open Selection Box / Check / Uncheck</td>
                    <td><kbd>Space</kbd></td>
                </tr>
                <tr>
                    <td>Select Options</td>
                    <td><kbd>&leftarrow;</kbd> / <kbd>&rightarrow;</kbd></td>
                </tr>
                <tr>
                    <td>Submit</td>
                    <td><kbd>Enter</kbd></td>
                </tr>
                <tr>
                    <td>Print</td>
                    <td><kbd>P</kbd></td>
                </tr>
                <tr>
                    <td>Dialog Box OK / YES / SELECT</td>
                    <td><kbd>Enter</kbd> / <kbd>Space</kbd></td>
                </tr>
                <tr>
                    <td>Dialog Box CANCEL / NO</td>
                    <td><kbd>ESC</kbd></td>
                </tr>
            </table>
        </div>
    </div>
</div>
