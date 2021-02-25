<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form class="ajax-form" data-form="Position" data-path="pos">
    <table class="prompt-table w-100">
        <tr>
            <td>Position Name <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="Name" name="name" maxlength="20" value="${name}">
            </td>
        </tr>
    </table>
</form>