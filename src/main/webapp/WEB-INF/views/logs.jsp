<%@ page contentType="text/html;charset=UTF-8"%>
<div id="logsView" class="view">
    <div class="row options">
        <div class="col-lg-6 col-xl-4">
            <div class="input-group input-group-sm mb-3">
                <div class="input-group-prepend">
                    <div class="btn-group btn-group-sm btn-group-toggle date-type" data-toggle="buttons">
                        <label class="btn btn-light border-secondary active">
                            <input type="radio" name="dateType" data-format="MM dd, yyyy" value="days" autocomplete="off" checked> Day
                        </label>
                        <label class="btn btn-light border-secondary">
                            <input type="radio" name="dateType" data-format="MM, yyyy" value="months" autocomplete="off"> Month
                        </label>
                        <label class="btn btn-light border-secondary">
                            <input type="radio" name="dateType" data-format="yyyy" value="years" autocomplete="off"> Year
                        </label>
                    </div>
                </div>
                <input type="text" class="form-control border-secondary datepicker" placeholder="Select">
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary search-log" type="button"><i class="fa fa-search"></i></button>
                </div>
            </div>

        </div>
        <div class="col-lg-5 col-md-6 text-right button-set">

        </div>
    </div>
    <div class="body data-table">
        <table class="table">
            <thead class="thead-dark">
            <tr>
                <th rowspan="2">Code</th>
                <th rowspan="2">Item</th>
                <th rowspan="2" class="text-right">In Stock</th>
                <th colspan="3" class="text-center">Purchases</th>
                <th colspan="3" class="text-center">Sales</th>
            </tr>
            <tr class="text-right">
                <th>Price (Rs)</th>
                <th>QTY</th>
                <th>Value</th>
                <th>Price (Rs)</th>
                <th>QTY</th>
                <th>Value</th>
            </tr>
            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
</div>