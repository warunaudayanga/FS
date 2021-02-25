<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form class="ajax-form" data-form="User" data-path="emp">
    <table class="prompt-table ml-auto mr-auto">
        <tr>
            <td>First Name</td>
            <td>:</td>
            <td>${fName}</td>
        </tr>
        <tr>
            <td>Last Name</td>
            <td>:</td>
            <td>${lName}</td>
        </tr>
        <tr>
            <td>Password</td>
            <td>:</td>
            <td>${password}</td>
        </tr>
        <tr>
            <td>Birthday</td>
            <td>:</td>
            <td>${dob}</td>
        </tr>
        <tr>
            <td>Gender</td>
            <td>:</td>
            <td>${gender == "m"? "Male": "Female"}</td>
        </tr>
        <tr>
            <td>NIC</td>
            <td>:</td>
            <td>${nic}</td>
        </tr>
        <tr>
            <td>Position</td>
            <td>:</td>
            <td>${position}</td>
        </tr>
        <tr>
            <td>Address</td>
            <td>:</td>
            <td>${address}</td>
        </tr>
        <tr>
            <td>Phone</td>
            <td>:</td>
            <td>${phone}</td>
        </tr>
    </table>
</form>