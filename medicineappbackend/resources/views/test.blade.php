<!--non-changing part--><?php include "Includes/topLayout.php"; ?><!--non-changing part-->

<!--changing part-->
<div class="container-fluid" id="container-wrapper"><!-- Container Fluid-->

    <div class="d-sm-flex align-items-center justify-content-between mb-4"><!-- header-->
        <h1 class="h3 mb-0 text-gray-800">All Student in (<?php echo ' - '; ?>) Class</h1>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="./">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">All Student in Class</li>
        </ol>
    </div><!-- header-end-->

    <div class="row"><!-- Input Group -->
        <div class="col-lg-12"><!--col-->
            <div class="card mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">All Students</h6>
                </div>
                <div class="table-responsive p-3">
                    <table class="table align-items-center table-flush table-hover" id="dataTableHover">
                        <thead class="thead-light">
                            <tr>
                                <th>#</th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Email</th>
                                <th>Groupe</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Bounaas</td>
                                <td>Rami mohamed zaki</td>
                                <td>rami.bounaas@univ.constantine2.dz</td>
                                <td>G1</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div><!--col-end-->
    </div><!-- Input Group end-->

</div> <!-- Container Fluid end-->
<!--changing part-->

<!--non-changing part--><?php include "Includes/bottomLayout.php"; ?><!--non-changing part-->