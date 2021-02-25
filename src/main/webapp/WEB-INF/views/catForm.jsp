<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form class="ajax-form" data-form="Category" data-path="cat">
    <table class="prompt-table w-100">
        <tr>
            <td>Category Name <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="Name" name="name" maxlength="50" value="${name}">
            </td>
        </tr>
        <tr>
            <td>Description</td>
            <td>
                <textarea class="form-control form-control-sm" name="desc" rows="3" maxlength="100">${desc}</textarea>
            </td>
        </tr>
    </table>
</form>