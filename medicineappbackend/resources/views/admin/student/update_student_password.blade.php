<!--non-changing part-->
@include("admin.Includes.topLayout")

<!-- Container Fluid-->
<div class="container-fluid" id="container-wrapper">

  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Manage Students</h1>
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><a href="{{route('dashboard')}}">Home</a></li>
      <li class="breadcrumb-item active" aria-current="page">Manage Students</li>
    </ol>
  </div>
  <!-- Container Form -->
  <div class="row">
    <div class="col-lg-12">

      <div id="formContainer" class="card mb-4">
        <!-- Form Basic -->
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">Update Student</h6>
          update student password
        </div>
        <div class="card-body">
          <form method="post" action='{{route("updateStudentPassword")}}'>
            @csrf
            <div class="form-group row mb-3">


              <div class="col-xl-6">
                <label class="form-control-label">New Password<span class="text-danger ml-2">*</span></label>
                <input type="password" class="form-control" required name="student_new_password">
                @if($errors->has('student_new_password'))

                <span class="text-danger">{{$errors->first('student_new_password')}}</span>
                @endif


              </div>
              <div class="col-xl-6">
                <label class="form-control-label">confirm password<span class="text-danger ml-2">*</span></label>
                <input type="password" class="form-control" required name="student_new_password_confirmation">

              </div>
              <input type="hidden" name="student_id" value="{{$student_id}}">

              <div class="col-xl-6 mt-3">
                <button type="submit" id='submit' class="btn btn-primary">Update</button>

              </div>
            </div>
          </form>
        </div>
      </div>
      <!-- Input Group -->

    </div>
  </div>
</div>
<!-- Container Form -->


<!---Container Fluid-->


<!--non-changing part-->
@include("admin.Includes.bottomLayout")