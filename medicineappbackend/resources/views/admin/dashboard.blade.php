<!--non-changing part-->
@include("admin.Includes.topLayout")


<!--changing part-->
<div class="container-fluid" id="container-wrapper"><!-- Container Fluid-->
            <div class="d-sm-flex align-items-center justify-content-between mb-4"><!--header-->
              <h1 class="h3 mb-0 text-gray-800">Administrator Dashboard</h1>
              <ol class="breadcrumb">
                <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
              </ol>
            </div><!--header-end-->

            <div class="row mb-3">
              <!-- Students Card -->
              <div class="col-xl-6 col-md-6 mb-4">
                <div class="card h-100">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-uppercase mb-1">Patients</div>
                        <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">{{$patients_number}}</div>
                        <div class="mt-2 mb-0 text-muted text-xs"></div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-users fa-2x text-info"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- Class Card -->
              <div class="col-xl-6 col-md-6 mb-4">
                <div class="card h-100">
                  <div class="card-body">
                    <div class="row align-items-center">
                      <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-uppercase mb-1">Doctors</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">{{$doctors_number}}</div>
                        <div class="mt-2 mb-0 text-muted text-xs">
                          <!-- <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 3.48%</span>
                          <span>Since last month</span> -->
                        </div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-chalkboard fa-2x text-primary"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div> 
              <div class="col-xl-6 col-md-6 mb-4">
                <div class="card h-100">
                  <div class="card-body">
                    <div class="row align-items-center">
                      <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-uppercase mb-1">Pharmacists</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">{{$pharmacists_number}}</div>
                        
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-chalkboard fa-2x text-primary"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div> 
              <!-- Std Att Card  -->
                       
            </div>
          </div>
          <!---Container Fluid end-->
<!--changing part-->



<!--non-changing part-->@include("admin.Includes.bottomLayout")